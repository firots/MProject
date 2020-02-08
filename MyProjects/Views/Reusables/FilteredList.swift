//
//  FilteredProjectsList.swift
//  MyProjects
//
//  Created by Firot on 6.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI
import CoreData

class TimerContainer {
    var timer: Timer
    
    init() {
        timer = Timer()
    }
    
    func reschedule(to interval: TimeInterval, action: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {_ in
            action()
        }
    }
    
    func stop() {
        timer.invalidate()
    }
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    @State private var predicate: NSPredicate?
    @Environment(\.managedObjectContext) var moc

    private let listID: UUID
    private var fetchRequest: FetchRequest<T>
    private var results: FetchedResults<T> {
        fetchRequest.wrappedValue }
    private let content: (T) -> Content
    private let placeholder: PlaceholderViewModel
    @State private var deletedItems = [T]()
    private let timer = TimerContainer()

    var body: some View {
        ZStack {
            if !results.isEmpty {
                List {
                    ForEach(results, id: \.self) { result in
                        self.contentView(result)
                    }.onDelete(perform: removeItems)
                }.listStyle(GroupedListStyle())
                        .id(listID)

            } else {
                PlaceholderView(model: placeholder)
            }
            if !deletedItems.isEmpty {
                undoView()
                    .transition(.move(edge: .bottom))
            }
        }
    }
    
    private func contentView(_ item: T) -> some View {
        Group {
            if !isDeleted(item) {
                self.content(item)
            }
        }
    }
    
    init(listID: UUID, predicate: NSPredicate?, sorter: NSSortDescriptor, placeholder: PlaceholderViewModel, @ViewBuilder content: @escaping (T) -> Content) {
        self.fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [sorter], predicate: predicate)
        self.content = content
        self.placeholder = placeholder
        self.listID = listID
        self.predicate = predicate
        
    }
    
    private func isDeleted(_ item: T) -> Bool {
        if deletedItems.isEmpty { return false }
        for deletedItem in deletedItems {
            if item.objectID == deletedItem.objectID {
                return true
            }
        }
        return false
    }
    
    private func emptyBin()  {
        timer.stop()
        for item in deletedItems {
            moc.deleteWithChilds(item)
        }

        deletedItems.removeAll()
        
        if moc.hasChanges {
            try? moc.save()
        }
    }
    
    private func undoView() -> some View {
        return VStack {
            Spacer()
            HStack {
                Text("\(deletedItems.count) item deleted")
                Button("Undo") {
                    self.timer.stop()
                    self.deletedItems.removeAll()
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 24)
            
        }
    }
    
    private func removeItems(at offsets: IndexSet) {
        timer.stop()
        timer.reschedule(to: 3.0) {
            self.emptyBin()
        }
        for index in offsets {
            self.deletedItems.append(results[index])
            
        }
    }
}

/*struct FilteredProjectsList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList(predicate: nil, placeholder: PlaceholderViewModel(title: "Hello There", subtitle: "This is an empty placeholder", image: UIImage(named: "pencil"))) {_ in
            Text("Test")
        }
    }
}*/
