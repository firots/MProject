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
    private let placeholder: PlaceholderViewModel

    var body: some View {
        Group {
            if results.count > 0 {
                List {
                    ForEach(results, id: \.self) { result in
                        self.content(result)
                    }.onDelete(perform: removeItems)
                }.listStyle(GroupedListStyle())
            } else {
                PlaceholderView(model: placeholder)
            }
        }
    }
    
    init(predicate: NSPredicate?, sorter: NSSortDescriptor, placeholder: PlaceholderViewModel, @ViewBuilder content: @escaping (T) -> Content) {
        self.fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [sorter], predicate: predicate)
        self.content = content
        self.placeholder = placeholder
        self.predicate = predicate
    }
    
    private func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let object = results[index]
            moc.deleteWithChilds(object)
        }
        if moc.hasChanges { try? moc.save() }
    }
}

/*struct FilteredProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(predicate: nil, placeholder: PlaceholderViewModel(title: "Hello There", subtitle: "This is an empty placeholder", image: UIImage(named: "pencil"))) {_ in
            Text("Test")
        }
    }
}*/
