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
    public func repeatIfNeeded(force: Bool, context: NSManagedObjectContext, count: Int) {
        if wrappedRepeatMode == .none { return } //not repeating type
        
        if repeated == true { return } //already has repeated task
        
        guard let nextFireDate = self.nextFireDate else { return } //be sure next fire date is valid
        
        if force == false && nextFireDate > Date() { return } //its not time yet
        
        deleteNotificationsFromIOS(clearFireDate: true)
        
        let repeatedTask = self.clone(force: force)
        
        if force == false && count < 50 {
            repeatedTask?.repeatIfNeeded(force: false, context: context, count: count + 1)
        }
    }
    
    func clone(force: Bool) -> MTask? {
        guard let context = self.managedObjectContext else { return nil }
        
        guard let nextFireDate = self.nextFireDate else { return nil }
        
        let viewModel = AddTaskViewModel(self, self.project, pCellViewModel: nil, cloning: true)
        
        for step in viewModel.stepsModel.steps {
            step.step = nil
            step.statusIndex = MStepStatus.active.rawValue
            step.id = UUID()
        }
        
        if viewModel.repeatModeConfiguration.wrappedRepeatMode != .none {
            viewModel.repeatModeConfiguration.repeatStartDate = nextFireDate
        }
        
        viewModel.statusIndex = MObjectStatus.active.rawValue
        
        
        var hourDiff = nextFireDate.hoursPassed(from: self.repeatStartDate)
        
        if hourDiff == 0 {
            if repeatMode == RepeatMode.hour.rawValue {
                hourDiff = repeatPeriod
            }
        }
        
        viewModel.started = nextFireDate
        
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
        self.nextFireDate = nil
        
        if force == true {
            if context.hasChanges == true {
                try? context.mSave()
            }
        }

        
        return task
        
    }
    
}
