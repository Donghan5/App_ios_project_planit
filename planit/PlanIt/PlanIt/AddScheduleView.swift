//
//  AddScheduleView.swift
//  PlanIt
//
//  Created by 김동한 on 26/09/2024.
//

import Foundation
import SwiftUI

struct newSchedule {
    var title: String
    var timestamp: Date
    var description: String
}

struct AddScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var description: String = ""

    var body: some View {
        Form {
            TextField("제목", text: $title)
            DatePicker("날짜", selection: $date, displayedComponents: .date)
            TextEditor(text: $description)
                .frame(height: 100)
            Button(action: saveSchedule) {
                Text("일정 추가")
            }
        }
        .navigationTitle("일정 추가")
    }

    private func saveSchedule() {
        let newSchedule = Item(context: viewContext)
        newSchedule.timestamp = date
        newSchedule.title = title
        newSchedule.description = description

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
