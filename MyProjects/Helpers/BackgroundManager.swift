//
//  BackgroundHelper.swift
//  MyProjects
//
//  Created by Firot on 26.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import BackgroundTasks

class BackgroundManager {
    static let shared = BackgroundManager()
    
    private init() {
        
    }
    
    func register() {
        print("registered")
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier:
        "com.firot.MyProjects.refresh",
        using: nil)
          {task in
             self.handleAppRefresh(task: task as! BGAppRefreshTask)
          }
    }
    
    func scheduleAppRefresh() {
        print("scheduled")
        
        let request = BGAppRefreshTaskRequest(identifier: "com.firot.MyProjects.refresh")
       // Fetch no earlier than 15 minutes from now
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        print("App refresh")

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let appRefreshOperation = DataManager()
        queue.addOperation(appRefreshOperation)

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        let lastOperation = queue.operations.last
        lastOperation?.completionBlock = {
            task.setTaskCompleted(success: !(lastOperation?.isCancelled ?? false))
        }

        scheduleAppRefresh()
    }
}
