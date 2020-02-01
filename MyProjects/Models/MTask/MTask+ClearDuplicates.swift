//
//  MTask+ClearDuplicates.swift
//  MyProjects
//
//  Created by Firot on 2.02.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MTask {
    
    func deduplicate(context: NSManagedObjectContext) {
        if repeatCount == 0 { return }
        guard let originalID = self.originalID else { return }

        let predicate = NSPredicate(format: "originalID == %@ AND repeatCount == %d", originalID.uuidString, repeatCount)
        
        let fetchRequest: NSFetchRequest<MTask> = MTask.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            var tasks = try context.fetch(fetchRequest)
            if tasks.count < 2 {
                return
            } else {
                tasks.sort {
                    $0.wrappedCreated > $1.wrappedCreated
                }
                for (i, task) in tasks.enumerated() {
                    if i != tasks.count - 1 {
                        context.deleteWithChilds(task)
                    }
                }
            }
        } catch {
            fatalError("Unable to fetch tasks.")
        }
    }

}
