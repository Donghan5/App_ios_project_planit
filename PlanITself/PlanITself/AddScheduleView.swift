import SwiftUI

struct AddScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var description: String = ""

    var body: some View {
        Form {
            TextField("제목", text: $title)
            DatePicker("날짜", selection: $date, displayedComponents: [.date, .hourAndMinute])
            TextEditor(text: $description)
                .frame(height: 100)
                .border(Color.gray, width: 1)
            Button(action: saveSchedule) {
                Text("일정 추가")
            }
        }
        .navigationTitle("일정 추가")
    }

    private func saveSchedule() {
        let newItem = MyItem(context: viewContext)
        newItem.timestamp = date
        newItem.title = title
        newItem.descriptionText = description

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
