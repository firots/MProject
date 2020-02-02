//
//  NSManagedObjectContext+deleteWithChilds.swift
//  MyProjects
//
//  Created by Firot on 23.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func deleteWithChilds(_ object: NSManagedObject) {
        if let mObject = object as? MObject {
            mObject.clearNotifications(context: self)
            if let task = mObject as? MTask {
                task.clearSteps(context: self)
                task.setPreviousRepeatedMode(context: self)
            } else if let project = mObject as? MProject {
                project.clearTasks(context: self)
            }
        }
        delete(object)
    }
}
