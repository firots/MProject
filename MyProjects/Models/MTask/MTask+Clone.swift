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
    public func setPreviousRepeatedMode(context: NSManagedObjectContext) {
        guard let originalID = originalID else { return }
        let predicate = NSPredicate(format: "originalID == %@ AND repeatCount == %d", originalID.uuidString, repeatCount - 1)
        
        let fetchRequest: NSFetchRequest<MTask> = MTask.fetchRequest()
        fetchRequest.predicate = predicate
        
        context.perform{
            do {
                let task = try context.fetch(fetchRequest).first
                task?.repeated = false
            } catch {
                fatalError("Unable to fetch tasks.")
            }
        }
    }
    
    
    public func repeatIfNeeded(force: Bool, context: NSManagedObjectContext) {
        if wrappedRepeatMode == .none { return } //not repeating type
        
        if repeated == true { return } //already has repeated task
        
        guard let nextFireDate = self.nextFireDate else { return } //be sure next fire date is valid
        
        if force == false && nextFireDate > Date() { return } //its not time yet
        
        

        print("OH I WILL REPEAT NOW")
        
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
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            repeated?.setStatus(to: .done, context: context)
        }*/
        repeatedTask?.repeatIfNeeded(force: false, context: context)
    }
    
    func clone(force: Bool) -> MTask? {
        guard let context = self.managedObjectContext else { return nil }
        
        let viewModel = AddTaskViewModel(self, self.project)
        
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
        
        self.repeated = true
        
        self.setNextFireDate()
        
        if force == true {
            if context.hasChanges == true {
                try? context.save()
            }
        }

        
        return task
        
    }
    
}
