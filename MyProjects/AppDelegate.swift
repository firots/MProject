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
            Settings.load()
            UNUserNotificationCenter.current().delegate = LocalNotifications.shared
            
            UISwitch.appearance().onTintColor = .systemPurple
            if UIDevice.current.userInterfaceIdiom == .phone {
                UITableView.appearance().separatorStyle = .none
            }
            UITableView.appearance().backgroundColor = .clear

            UISegmentedControl.appearance().backgroundColor = .clear
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.firot.MyProjects.db_organizer", using: nil) { task in
            // Downcast the parameter to a processing task as this identifier is used for a processing request.
            self.handleDatabaseCleaning(task: task as! BGProcessingTask)
        }
        
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
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60)
        
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

        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        appRefreshOperation.completionBlock = {
            task.setTaskCompleted(success: !appRefreshOperation.isCancelled)
        }
        
        queue.addOperation(appRefreshOperation)
        
        self.scheduleAppRefresh()
    }
    
    func scheduleDatabaseCleaning() {
        let request = BGProcessingTaskRequest(identifier: "com.firot.MyProjects.db_organizer")
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = true
        //request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
        
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
            
            task.setTaskCompleted(success: success)
        }
        queue.addOperation(cleanDatabaseOperation)
        
        scheduleDatabaseCleaning()
    }
    
    

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

