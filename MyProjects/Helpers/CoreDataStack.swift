//
//  CoreDataStack.swift
//  MyProjects
//
//  Created by Firot on 4.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    let appTransactionAuthorName: String
    var historyRunCount = 0
    
    var dataManagerFired = false

    lazy var persistentContainer: NSPersistentContainer = {
        
        // Create a container that can load CloudKit-backed stores
        let container = NSPersistentCloudKitContainer(name: "MyProjects")
        
        // Enable history tracking and remote notifications
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("###\(#function): Failed to load persistent stores:\(error)")
        })
        
        
        //try? container.initializeCloudKitSchema(options: [NSPersistentCloudKitContainerSchemaInitializationOptions.printSchema])
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.transactionAuthor = appTransactionAuthorName

        //try? container.viewContext.setQueryGenerationFrom(.current)
        
        // Pin the viewContext to the current generation token and set it to keep itself up to date with local changes.
        container.viewContext.automaticallyMergesChangesFromParent = true
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
            fatalError("###\(#function): Failed to pin viewContext to the current generation:\(error)")
        }
        
        // Observe Core Data remote change notifications.
        NotificationCenter.default.addObserver(
            self, selector: #selector(type(of: self).storeRemoteChange(_:)),
            name: .NSPersistentStoreRemoteChange, object: container.persistentStoreCoordinator)
    
        return container
    }()
    
    func addObservers() {
        
    }
    
    
    /**
     Track the last history token processed for a store, and write its value to file.
     
     The historyQueue reads the token when executing operations, and updates it after processing is complete.
     */
    private var lastHistoryToken: NSPersistentHistoryToken? = nil {
        didSet {
            guard let token = lastHistoryToken,
                let data = try? NSKeyedArchiver.archivedData( withRootObject: token, requiringSecureCoding: true) else { return }
            
            do {
                try data.write(to: tokenFile)
            } catch {
                print("###\(#function): Failed to write token data. Error = \(error)")
            }
        }
    }
    
    
    /**
     The file URL for persisting the persistent history token.
    */
    private lazy var tokenFile: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CoreDataCloudKitDemo", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("###\(#function): Failed to create persistent container URL. Error = \(error)")
            }
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()
    
    
    /**
     An operation queue for handling history processing tasks: watching changes, deduplicating tags, and triggering UI updates if needed.
     */
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    
    /**
     The URL of the thumbnail folder.
     */
    static var attachmentFolder: URL = {
        var url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CoreDataCloudKitDemo", isDirectory: true)
        url = url.appendingPathComponent("attachments", isDirectory: true)
        
        // Create it if it doesn’t exist.
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

            } catch {
                print("###\(#function): Failed to create thumbnail folder URL: \(error)")
            }
        }
        return url
    }()
    
    
    init() {
        appTransactionAuthorName = UIDevice.current.identifierForVendor!.uuidString
        
        // Load the last token from the token file.
        if let tokenData = try? Data(contentsOf: tokenFile) {
            do {
                lastHistoryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
            } catch {
                print("###\(#function): Failed to unarchive NSPersistentHistoryToken. Error = \(error)")
            }
        }
    }
}


// MARK: - Notifications

extension CoreDataStack {
    /**
     Handle remote store change notifications (.NSPersistentStoreRemoteChange).
     */
    @objc
    func storeRemoteChange(_ notification: Notification) {
        if dataManagerFired == false { historyRunCount += 1 }
        print("###\(#function): Merging changes from the other persistent store coordinator.")
        
        // Process persistent history to merge changes from other coordinators.
        historyQueue.addOperation {
            self.processPersistentHistory()
        }
        
        if dataManagerFired == false {
            let hRC = self.historyRunCount
            DispatchQueue.global().asyncAfter(deadline: .now() + 2.2) {
                if hRC == self.historyRunCount {
                    self.dataManagerFired = true
                    let dataManager = DataManager(context: self.persistentContainer.newBackgroundContext(), text: "coredatastack")
                    self.historyQueue.addOperation(dataManager)
                }
            }
        }

    }
}

extension CoreDataStack {
    
    /**
     Process persistent history, posting any relevant transactions to the current view.
     */
    func processPersistentHistory() {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {
            
            // Fetch history received from outside the app since the last token
            let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
            historyFetchRequest.predicate = NSPredicate(format: "author != %@", appTransactionAuthorName)
            let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
            request.fetchRequest = historyFetchRequest

            let result = (try? taskContext.execute(request)) as? NSPersistentHistoryResult
            guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                  !transactions.isEmpty
                else { return }

            // Post transactions relevant to the current view.
            /*DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didFindRelevantTransactions, object: self, userInfo: ["transactions": transactions])
            }*/

            // Deduplicate the new tags.
            var newMTaskObjectIDs = [NSManagedObjectID]()
            let mTaskEntityName = MTask.entity().name

            for transaction in transactions where transaction.changes != nil {
                for change in transaction.changes!
                    where change.changedObjectID.entity.name == mTaskEntityName && change.changeType == .insert {
                        newMTaskObjectIDs.append(change.changedObjectID)
                }
            }
            if !newMTaskObjectIDs.isEmpty {
                deduplicateAndWait(mTaskObjectIDs: newMTaskObjectIDs)
            }
            
            
            var changedNotifications = [ChangedNotification]()
            let mNotificationEntityName = MNotification.entity().name

            for transaction in transactions where transaction.changes != nil {
                for change in transaction.changes!
                    where change.changedObjectID.entity.name == mNotificationEntityName {
                        changedNotifications.append(ChangedNotification(objectID: change.changedObjectID, changeType: change.changeType))
                }
            }
            
            if !changedNotifications.isEmpty {
                processChangedNotifications(notifications: changedNotifications)
            }
            
            // Update the history token using the last transaction.
            lastHistoryToken = transactions.last!.token
        }
    }
}

extension CoreDataStack {
    struct ChangedNotification {
        var objectID: NSManagedObjectID
        var changeType: NSPersistentHistoryChangeType
    }
    
    func processChangedNotifications(notifications: [ChangedNotification]) {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.performAndWait {
            var candidates = [NotificationCandidate]()
            notifications.forEach { notification in
                if let mNotification = taskContext.object(with: notification.objectID) as? MNotification, notification.changeType != .delete {
                    candidates.append(contentsOf: mNotification.getCandidates())
                }
            }
            
            LocalNotifications.shared.create(from: candidates)
            
            // Save the background context to trigger a notification and merge the result into the viewContext.
            try? taskContext.save()
        }
    }
}





// MARK: - Deduplicate tags

extension CoreDataStack {
    /**
     Deduplicate tags with the same name by processing the persistent history, one tag at a time, on the historyQueue.
     
     All peers should eventually reach the same result with no coordination or communication.
     */
    private func deduplicateAndWait(mTaskObjectIDs: [NSManagedObjectID]) {
        // Make any store changes on a background context
        let taskContext = persistentContainer.newBackgroundContext()
        
        // Use performAndWait because each step relies on the sequence. Since historyQueue runs in the background, waiting won’t block the main queue.
        taskContext.performAndWait {
            mTaskObjectIDs.forEach { mTaskObjectID in
                self.deduplicate(mTaskObjectID: mTaskObjectID, performingContext: taskContext)
            }
            // Save the background context to trigger a notification and merge the result into the viewContext.
            try? taskContext.save()
        }
    }

    /**
     Deduplicate a single tag.
     */
    private func deduplicate(mTaskObjectID: NSManagedObjectID, performingContext: NSManagedObjectContext) {
        guard let mTask = performingContext.object(with: mTaskObjectID) as? MTask, let originalID = mTask.originalID, mTask.repeatCount > 0 else { return }

        // Fetch all tags with the same name, sorted by uuid
        let fetchRequest: NSFetchRequest<MTask> = MTask.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: MObjectSortType.created.rawValue, ascending: false)]
        
        fetchRequest.predicate = NSPredicate(format: "originalID == %@ AND repeatCount == %d", originalID.uuidString, mTask.repeatCount)
        
        // Return if there are no duplicates.
        guard var duplicatedMTasks = try? performingContext.fetch(fetchRequest), duplicatedMTasks.count > 1 else {
            return
        }
        
        duplicatedMTasks.sort {
            $0.wrappedCreated < $1.wrappedCreated
        }
        
        // Pick the first tag as the winner.
        let winner = duplicatedMTasks.first!
        duplicatedMTasks.removeFirst()
        remove(duplicatedMTasks: duplicatedMTasks, winner: winner, performingContext: performingContext)
    }
    
    /**
     Remove duplicate tags from their respective posts, replacing them with the winner.
     */
    private func remove(duplicatedMTasks: [MTask], winner: MTask, performingContext: NSManagedObjectContext) {
        duplicatedMTasks.forEach { mTask in
            defer { performingContext.deleteWithChilds(mTask) }
            
            
            for notification in mTask.notifications {
                notification.deleteFromIOS(clearFireDate: false)
            }
        
            /*guard let project = mTask.project else { return }
            project.task?.removeObjk
            winner.project = project*/
        }
        
        var notificationCandidates = [NotificationCandidate]()
        for notification in winner.notifications {
            notificationCandidates.append(contentsOf: notification.getCandidates())
        }
         
         LocalNotifications.shared.create(from: notificationCandidates)
    }
}
