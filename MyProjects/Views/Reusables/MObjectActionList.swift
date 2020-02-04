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
    var fContainer: MObjectFilterContainer { get }
    var actionSheetType: MObjectActionSheetType { get set }
    var showActionSheet: Bool { get set }
    var showSortPopUp: Bool { get set }
}

protocol MObjectLister {
    associatedtype T: MObjectsViewModel
    var model: T { get set }
}

extension MObjectLister {
    var mObjectName: String {
        if self is TasksView {
            return "Tasks"
        } else {
            return "Projects"
        }
    }
    
    
    func filterButtonAction() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            model.actionSheetType = .filter
            model.showActionSheet = true
        } else {

        }
    }
    
    var topPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 10 : 40
    }
    
    
    func sortButtonAction() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            model.actionSheetType = .sort
            model.showActionSheet = true
        } else {
            model.showSortPopUp = true
        }
    }
    
    public func actionSheet() -> ActionSheet {
        if model.actionSheetType == .filter {
            return dateFilterActionSheet()
        }
        return sortActionSheet()
    }
    
    func setSortBy(to sorter: MObjectSortType) {
        let fContainer = model.fContainer
        fContainer.sortBy = sorter
    }
    
    public func sortPopOver() -> some View {
        Group {
            Text("Sort By")
                .foregroundColor(.secondary)
                .padding(.top, 20)
            Divider()
            ForEach(1..<MObjectSortType.all.count) { index in
                Button(action: {
                    self.setSortBy(to: MObjectSortType.all[index])
                    self.model.showSortPopUp = false
                }) {
                    Text(MObjectSortType.names[index])
                        .font(.system(size: 18))
                }.padding()
                Divider()
            }
            Button(action: {
                self.model.showSortPopUp = false
            }) {
                Text("Cancel")
                    .font(.system(size: 18))
                    .foregroundColor(Color(.systemRed))
            }.padding()
            Divider()
        }.padding(.vertical, 100)
    }
    
    public func dateFilterActionSheet() -> ActionSheet {
        ActionSheet(
            title: Text("Show \(mObjectName) of"),
            message: nil,
            buttons: [
                    .default(
                        Text("Today"),
                        action: {
                            self.model.fContainer.dateFilter = MObjectDateFilterType.today.rawValue
                    }),
                    .default(
                        Text("This Week"),
                        action: {
                         self.model.fContainer.dateFilter = MObjectDateFilterType.week.rawValue
                    }),
                    .default(
                        Text("This Month"),
                        action: {
                         self.model.fContainer.dateFilter = MObjectDateFilterType.month.rawValue
                    }),
                    .default(
                        Text("This Year"),
                        action: {
                         self.model.fContainer.dateFilter = MObjectDateFilterType.year.rawValue
                    }),
                    .default(
                        Text("All"),
                        action: {
                         self.model.fContainer.dateFilter = MObjectDateFilterType.anytime.rawValue
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
                        Text("Name"),
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
