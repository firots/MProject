//
//  AppDelegate.swift
//  MyProjects
//
//  Created by Firot on 29.12.2019.
//  Copyright © 2019 Firot. All rights reserved.
//

import UIKit
import CoreData
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if application.applicationState != .inactive {
            let dm = DataManager(context: coreDataStack
                .persistentContainer.viewContext, text: "startup")
            dm.start()

            Settings.load()
            UNUserNotificationCenter.current().delegate = LocalNotifications.shared
            
            UISwitch.appearance().onTintColor = .systemPurple
            if UIDevice.current.userInterfaceIdiom == .phone {
                UITableView.appearance().separatorStyle = .none
            }
            UITableView.appearance().backgroundColor = .clear

            UISegmentedControl.appearance().backgroundColor = .clear
        }


        /*BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.firot.MyProjects.db_organizer", using: nil) { task in
            // Downcast the parameter to a processing task as this identifier is used for a processing request.
            self.handleDatabaseCleaning(task: task as! BGProcessingTask)
        }*/
        
        registerBackgroundMode()

        return true
    }
    
    func registerBackgroundMode() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier:
        "com.firot.MyProjects.refresh",
        using: nil)
          {task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
          }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.firot.MyProjects.refresh")
        // Fetch no earlier than 15 minutes from now
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
            print("Could not schedule database cleaning: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        

        let appRefreshOperation = DataManager(context: coreDataStack.persistentContainer.newBackgroundContext(), text: "refresh")


        queue.addOperation(appRefreshOperation)

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        let lastOperation = queue.operations.last
        lastOperation?.completionBlock = {
            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
        }
        
        self.scheduleAppRefresh()
    }
    
    /*func scheduleDatabaseCleaning() {
        let request = BGProcessingTaskRequest(identifier: "com.firot.MyProjects.db_organizer")
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = true
        request.earliestBeginDate = Date(timeIntervalSinceNow: 30 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule database cleaning: \(error)")
        }
    }
    
    func handleDatabaseCleaning(task: BGProcessingTask) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
            queue.cancelAllOperations()
        }
        
        
        let cleanDatabaseOperation = DataManager(context: coreDataStack.persistentContainer.newBackgroundContext(), text: "process")

        cleanDatabaseOperation.completionBlock = {
            let success = !cleanDatabaseOperation.isCancelled
            if success {
                // Update the last clean date to the current time.
            }
            
            task.setTaskCompleted(success: success)
        }
        queue.addOperation(cleanDatabaseOperation)
        
        scheduleDatabaseCleaning()
    }*/
    
    
    
    
    
    
    


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack
    /*lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MyProjects")
       
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                 container.viewContext.automaticallyMergesChangesFromParent = true
            }
        })
        
        return container
    }()*/
    
    
    lazy var coreDataStack: CoreDataStack = { return CoreDataStack() }()
    

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = coreDataStack.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.mSave()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

