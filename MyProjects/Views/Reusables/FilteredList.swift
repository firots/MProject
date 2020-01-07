//
//  FilteredProjectsList.swift
//  MyProjects
//
//  Created by Firot on 6.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI
import CoreData

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @State private var predicate: NSPredicate?
    @Environment(\.managedObjectContext) var moc
    
    private var fetchRequest: FetchRequest<T>
    private var results: FetchedResults<T> {
        fetchRequest.wrappedValue }
    private let content: (T) -> Content

    var body: some View {
        List {
            ForEach(results, id: \.self) { result in
                self.content(result)
            }.onDelete(perform: removeItems)
        }.listStyle(GroupedListStyle())
    }
    
    init(predicate: NSPredicate?, @ViewBuilder content: @escaping (T) -> Content) {
        self.fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: predicate)
        self.content = content
        self.predicate = predicate
    }
    
    private func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let project = results[index]
            moc.delete(project)
        }
        if moc.hasChanges { try? moc.save() }
    }
}

struct FilteredProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(predicate: nil) {_ in
            Text("Test")
        }
    }
}
