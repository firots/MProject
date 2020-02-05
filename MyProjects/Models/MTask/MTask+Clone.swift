//
//  MTask+Clone.swift
//  MyProjects
//
//  Created by Firot on 26.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MTask {
    /*public func setPreviousRepeatedMode(to state: Bool, context: NSManagedObjectContext) {
        guard let originalID = originalID else { return }
        let predicate = NSPredicate(format: "(originalID == %@ OR id == %@) AND repeatCount < %d",originalID.uuidString, originalID.uuidString, repeatCount)
        
        let sort = NSSortDescriptor(key: #keyPath(MTask.repeatCount), ascending: false)
        
        let fetchRequest: NSFetchRequest<MTask> = MTask.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sort]
        
        context.perform {
            do {
                if let task = try context.fetch(fetchRequest).first {
                    if state == false && task.hasRepeatedTask(context: context) {
                        return
                    }
                    task.repeated = state
                }
                
            } catch {
                fatalError("Unable to fetch tasks.")
            }
            
            if context.hasChanges {
                try? context.mSave()
            }
        }
    }
    
    public func hasRepeatedTask(context: NSManagedObjectContext) -> Bool {
        let predicate = NSPredicate(format: "(originalID == %@ OR originalID == %@) AND repeatCount > %d", wrappedOriginalID.uuidString, wrappedID.uuidString, repeatCount)

        let fetchRequest: NSFetchRequest<MTask> = MTask.fetchRequest()
        fetchRequest.predicate = predicate
        var tasks = [MTask]()
        context.performAndWait {
            do {
                tasks = try context.fetch(fetchRequest)
            } catch {
                fatalError("Unable to fetch tasks.")
            }
        }
        return !tasks.isEmpty
    }*/
    
    
    public func repeatIfNeeded(force: Bool, context: NSManagedObjectContext) {
        if wrappedRepeatMode == .none { return } //not repeating type
        
        if repeated == true { return } //already has repeated task
        
        guard let nextFireDate = self.nextFireDate else { return } //be sure next fire date is valid
        
        if force == false && nextFireDate > Date() { return } //its not time yet
        
        /*let newTask = self.clone()
         clone will have nextfiredate as its repeatstartdate+
         startdate as current date+
         repeatTask = clone+
         clone.repeatedfrom = self+
         
         will copy steps to itself in active state+
         
         will copy all notifications by:
            get time diff between current repeatstartdate and repeatstartdate+
            add diff to notificaon date if notif state is none+
            else if notifstate is repeating add it to notifrepeatstartdate+
         
         create nextfiredate for all notifications
         
         call repeatifneeded on new task in case missed some repeats
        */
        
        
        
        deleteNotificationsFromIOS(clearFireDate: true)
        
        let repeatedTask = self.clone(force: force)
        
        if force == false {
            repeatedTask?.repeatIfNeeded(force: false, context: context)
        }
    }
    
    func clone(force: Bool) -> MTask? {
        guard let context = self.managedObjectContext else { return nil }
        
        let viewModel = AddTaskViewModel(self, self.project, pCellViewModel: nil)
        
        for step in viewModel.stepsModel.steps {
            step.step = nil
            step.statusIndex = MStepStatus.active.rawValue
            step.id = UUID()
        }
        
        if viewModel.repeatModeConfiguration.wrappedRepeatMode != .none {
            viewModel.repeatModeConfiguration.repeatStartDate = self.nextFireDate ?? Date()
        }
        
        viewModel.statusIndex = MObjectStatus.active.rawValue
        
        
        var hourDiff = (self.nextFireDate ?? Date()).hoursPassed(from: self.repeatStartDate)
        
        if hourDiff == 0 {
            if repeatMode == RepeatMode.hour.rawValue {
                hourDiff = repeatPeriod
            }
        }
        
        viewModel.started = self.started
        viewModel.started?.addHours(hourDiff)
        
        for notification in viewModel.notificationsModel.notifications {
            notification.mNotification = nil
            if notification.repeatModeConfiguration.wrappedRepeatMode == .none {
                notification.date.addHours(hourDiff)
            } else {
                notification.repeatModeConfiguration.repeatStartDate.addHours(hourDiff)
                notification.repeatModeConfiguration.repeatEndDate.addHours(hourDiff)
            }
            notification.id = UUID()
        }
        
        if var deadline = self.deadline {
            viewModel.hasDeadline = true
            deadline.addHours(hourDiff)
            viewModel.deadline = deadline
        }
        
        let newTaskOriginalID = originalID ?? wrappedID
        let newTaskRepeatCount = repeatCount + 1
        
        let task = MTask.createOrSync(from: viewModel, context: context, task: nil, project: project, originalID: newTaskOriginalID, repeatCount: newTaskRepeatCount)
        
        //self.repeated = true
        self.repeatMode = RepeatMode.none.rawValue
        
        self.setNextFireDate()
        
        if force == true {
            if context.hasChanges == true {
                try? context.mSave()
            }
        }

        
        return task
        
    }
    
}
