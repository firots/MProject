//
//  ProjectCellView.swift
//  MyProjects
//
//  Created by Firot on 24.01.2020.
//  Copyright © 2020 Firot. All rights reserved.
//

import SwiftUI

struct ProjectCellView: View {
    @ObservedObject var model: ProjectCellViewModel
    
    init(project: MProject) {
        model = ProjectCellViewModel(project: project)
    }
    
    var body: some View {
        NavigationLink(destination: TasksView(project: model.project)) {
            HStack {
                progressView()
                .padding(.trailing)
                
                VStack(alignment: .leading) {
                    taskCellNameAndSteps()
                        .padding(.bottom, 5)
                    
                    taskCellStartDates()
                        .padding(.bottom, 5)
                    
                    taskCellEndDates()
                        .padding(.bottom, 5)
                    
                }.foregroundColor(Color(.label))
            }
            .padding(.bottom, 5)
        }
        .onAppear() {
            self.model.progress = self.model.project.wrappedProgress
        }
        .listRowBackground(Color(.systemBackground))
    }
    
    private func progressView() -> some View {
        CircularProgressBarView(color: MObjectStatus.barColors[model.project.status], text: "\(model.project.progressPercentage)%", width: 60, thickness: 5, progress: model.progress)
    }
    
    private func taskCellNameAndSteps() -> some View {
        HStack {
            Text(model.project.wrappedName)
                .strikethrough(model.project.wrappedStatus == .done, color: nil)
                 .lineLimit(1)
             
             Spacer()
             
             if !model.project.tasks.isEmpty {
                 
                Text("\(model.project.completedTasks.count)/\(model.project.tasks.count)")
                    .strikethrough(model.project.tasks.count == model.project.completedTasks.count, color: nil)
                    .font(.system(size: 20, design: .monospaced))
                    .bold()
                    .lineLimit(1)
                    .foregroundColor(Color(.systemGray))
             }
        }
    }
    
    private func taskCellEndDates() -> some View {
        HStack {
            Text(model.project.secondDate)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
            
            if model.project.deadline != nil && (model.project.wrappedStatus == .active || model.project.wrappedStatus == .waiting )  {
                Text(model.project.deadline!.remeans())
                .bold()
                .font(.system(size: 20, design: .monospaced))
                .lineLimit(1)
                .foregroundColor(Color(.systemRed))
            }
            
            
        }
    }
    
    private func taskCellStartDates() -> some View {
        HStack {
            Text(model.project.firstDate)
                .font(.subheadline)
                .lineLimit(1)
                .foregroundColor(Color(.systemGray))
            
            Spacer()
            
            if model.project.started != nil && model.project.wrappedStatus == .waiting  {
                Text(model.project.started!.remeans())
                .bold()
                .font(.system(size: 20, design: .monospaced))
                .lineLimit(1)
                .foregroundColor(Color(.systemOrange))
            }
        }
    }
}

class ProjectCellViewModel: ObservableObject {
    var project: MProject
    @Published var progress = CGFloat.zero
    @Published var progressPercentage = CGFloat.zero
    
    init(project: MProject) {
        self.project = project
        self.progress = project.wrappedProgress
    }
}
