//
//  AddProjectViewModel.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import Foundation

class AddProjectViewModel: ObservableObject {
    @Published var name: String?
    @Published var notes: String?
}
