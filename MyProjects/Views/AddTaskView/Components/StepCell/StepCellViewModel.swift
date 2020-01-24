//
//  StepCellViewModel.swift
//  MyProjects
//
//  Created by Firot on 10.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//
import Foundation

class StepCellViewModel: ObservableObject, Identifiable {
    var id: UUID
    @Published var name: String
    @Published var editing: Bool
    @Published var statusIndex: Int
    var created: Date
    
    init(name: String?) {
        self.id = UUID()
        self.name = name ?? ""
        statusIndex = 0
        self.created = Date()
        self.editing = true
    }
    
    init(step: MStep) {
        self.id = step.wrappedID
        self.name = step.name ?? ""
        self.statusIndex = MStepStatus.all.firstIndex(of: step.wrappedStatus) ?? 0
        self.created = step.wrappedCreated
        self.editing = false
    }
}

/*struct StepCellViewModel: Identifiable {
    var id: UUID
    var name: String
    var editing: Bool
    var done: Bool
    var created: Date
    
    init(name: String?, done: Bool, created: Date) {
        self.id = UUID()
        self.name = name ?? ""
        self.done = done
        self.created = created
        self.editing = true
    }
    
    init(step: MStep) {
        self.id = step.wrappedID
        self.name = step.name ?? ""
        self.done = step.done
        self.created = step.wrappedCreated
        self.editing = false
    }
}*/
