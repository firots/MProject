//
//  AddTaskView.swift
//  MyProjects
//
//  Created by Firot on 1.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct AddTaskView: View {
    @ObservedObject private var model = AddTaskViewModel()
    
    var body: some View {
        Text("Add Task")
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
