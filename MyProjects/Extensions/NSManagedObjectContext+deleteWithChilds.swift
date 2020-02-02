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
                //task.setPreviousRepeatedMode(to: false, context: self)
            } else if let project = mObject as? MProject {
                project.clearTasks(context: self)
            }
        }
        delete(object)
    }
    
    func mSave() throws {
        
        for object in self.updatedObjects {
            if let datestampObject = object as? HasDateStamp {
                datestampObject.lastModified = Date()
            }
        }
        
        for object in self.insertedObjects {
            if let datestampObject = object as? HasDateStamp {
                let now = Date()
                if datestampObject.created == nil {
                    datestampObject.created = now
                }
                datestampObject.lastModified = now
            }
        }

        try save()
    }
}

protocol HasDateStamp: class {
    var lastModified: Date? { get set }
    var created: Date? { get set }
}
