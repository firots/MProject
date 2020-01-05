//
//  FilteredProjectsList.swift
//  MyProjects
//
//  Created by Firot on 6.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct FilteredProjectsList: View {
    var fetchRequest: FetchRequest<MProject>
    @State private var predicate: NSPredicate?
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        List {
            ForEach(fetchRequest.wrappedValue, id: \.self) { project in
                self.projectCell(project)
            }.onDelete(perform: removeProjects)
        }
    }
    
    init(predicate: NSPredicate?) {
        self.fetchRequest = FetchRequest<MProject>(entity: MProject.entity(), sortDescriptors: [], predicate: predicate)
        self.predicate = predicate
    }
    
    func projectCell(_ project: MProject) -> some View {
        VStack(alignment: .leading) {
            Text(project.wrappedName)
            Text(project.wrappedDetails).font(.footnote)
            Text("Due: \(project.deadline?.toString() ?? "No Deadline")").font(.footnote)
        }
    }
    
    func removeProjects(at offsets: IndexSet) {
        for index in offsets {
            let project = fetchRequest.wrappedValue[index]
            moc.delete(project)
        }
        if moc.hasChanges { try? moc.save() }
    }
}

struct FilteredProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredProjectsList(predicate: nil)
    }
}
