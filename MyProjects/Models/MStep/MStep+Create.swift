//
//  MStep+Bind.swift
//  MyProjects
//
//  Created by Firot on 11.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation
import CoreData

extension MStep {
    static func create(from model: StepCellViewModel, context moc: NSManagedObjectContext, rank: Int) -> MStep {
        let step = MStep(context: moc)
        step.id = model.id
        step.name = model.name
        step.status = MStepStatus.all[model.statusIndex].rawValue
        step.created = model.created
        step.rank = rank
        return step
    }
}
