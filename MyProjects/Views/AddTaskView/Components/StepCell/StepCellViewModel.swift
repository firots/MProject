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
    var step: MStep?
    
    init(name: String?) {
        self.id = UUID()
        self.name = name ?? ""
        statusIndex = 0
        self.editing = true
    }
    
    init(step: MStep) {
        self.id = step.wrappedID
        self.name = step.name ?? ""
        self.statusIndex = MStepStatus.all.firstIndex(of: step.wrappedStatus) ?? 0
        self.editing = false
        self.step = step
    }
}
