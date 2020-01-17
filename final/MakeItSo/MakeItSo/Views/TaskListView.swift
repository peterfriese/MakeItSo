//
//  ContentView.swift
//  MakeItSo
//
//  Created by Peter Friese on 10/01/2020.
//  Copyright © 2020 Google LLC. All rights reserved.
//

import SwiftUI

struct TaskListView: View {
  var tasks: [Task] = testDataTasks
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        List {
          ForEach (self.tasks) { task in
            HStack {
              Image(systemName: "circle")
              .resizable()
              .frame(width: 20, height: 20)
              Text(task.title)
            }
          }
          .onDelete { indexSet in
          }
        }
        Button(action: {}) {
          HStack {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 20, height: 20)
            Text("New Task")
          }
        }
        .padding()
        .accentColor(Color(UIColor.systemRed))
      }
      .navigationBarTitle("Tasks")
    }
  }
}

struct TaskListView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView()
  }
}
