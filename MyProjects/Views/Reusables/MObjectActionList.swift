//
//  MObjectActionList.swift
//  MyProjects
//
//  Created by Firot on 29.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import SwiftUI

protocol MObjectsViewModel: ObservableObject {
    var fContainer: MObjectFilterContainer { get  set }
    var actionSheetType: MObjectActionSheetType { get set }
}

protocol HasMObjectActionList {
    associatedtype T: MObjectsViewModel
    var model: T { get set }
}

extension HasMObjectActionList {
    var mObjectName: String {
        if self is TasksView {
            return "Tasks"
        } else {
            return "Projects"
        }
    }
    
    public func actionSheet() -> ActionSheet {
        if model.actionSheetType == .filter {
            return dateFilterActionSheet()
        }
        return sortActionSheet()
    }
    
    public func dateFilterActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("Show \(mObjectName) of"),
            message: nil,
            buttons: [
                    .default(
                        Text("Today"),
                        action: {
                         self.model.fContainer.dateFilter = .today
                    }),
                    .default(
                        Text("This Week"),
                        action: {
                         self.model.fContainer.dateFilter = .week
                    }),
                    .default(
                        Text("This Month"),
                        action: {
                         self.model.fContainer.dateFilter = .month
                    }),
                    .default(
                        Text("This Year"),
                        action: {
                         self.model.fContainer.dateFilter = .year
                    }),
                    .default(
                        Text("All"),
                        action: {
                         self.model.fContainer.dateFilter = .anytime
                    }),
                    .cancel()
            ])
    }
    
    public func sortActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("Sort \(mObjectName) by"),
            message: nil,
            buttons: [
                    .default(
                        Text("Priority"),
                        action: {
                            self.model.fContainer.sortBy = .priority
                    }),
                    .default(
                        Text("Alphabetic"),
                        action: {
                         self.model.fContainer.sortBy = .name
                    }),
                    .default(
                        Text("Date Created"),
                        action: {
                         self.model.fContainer.sortBy = .created
                    }),
                    .default(
                        Text("Date Started"),
                        action: {
                         self.model.fContainer.sortBy = .started
                    }),
                    .default(
                        Text("Deadline"),
                        action: {
                         self.model.fContainer.sortBy = .deadline
                    }),
                    .cancel()
            ])
    }
}
