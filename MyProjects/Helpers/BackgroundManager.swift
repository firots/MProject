//
//  BackgroundHelper.swift
//  MyProjects
//
//  Created by Firot on 26.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

/*import Foundation
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
      // Schedule a new refresh task
      scheduleAppRefresh()

      // Create an operation that performs the main part of the background task
        let operation = DataManager.shared
      
      // Provide an expiration handler for the background task
      // that cancels the operation
      task.expirationHandler = {
         operation.cancel()
      }

      // Inform the system that the background task is complete
      // when the operation completes
      operation.completion = {
         task.setTaskCompleted(success: !operation.cancelled)
      }

      // Start the operation
        operation.syncAll()
    }
    
    
}*/
