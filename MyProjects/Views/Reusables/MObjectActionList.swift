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
}

protocol HasMObjectActionList {
    associatedtype T: MObjectsViewModel
    var model: T { get set }
}

extension HasMObjectActionList {
    public func dateFilterActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("Filter Tasks"),
            message: Text("Show Tasks of"),
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
}
