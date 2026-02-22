import SwiftUI

struct AddScheduleView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var description: String = ""
    @State private var showPastDateWarning: Bool = false

    var editingItem: MyItem?

    var isEditing: Bool { editingItem != nil }

    var body: some View {
        Form {
            Section {
                TextField("제목", text: $title)
            } footer: {
                if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("제목을 입력해주세요")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            Section {
                DatePicker("날짜", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    .onChange(of: date) {
                        showPastDateWarning = date < Date()
                    }
            } footer: {
                if showPastDateWarning {
                    Text("선택한 날짜가 과거입니다")
                        .foregroundColor(.orange)
                        .font(.caption)
                }
            }

            Section {
                TextEditor(text: $description)
                    .frame(height: 100)
            } header: {
                Text("설명")
            }

            Button(action: saveSchedule) {
                Text(isEditing ? "수정 완료" : "일정 추가")
                    .frame(maxWidth: .infinity)
            }
            .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .navigationTitle(isEditing ? "일정 수정" : "일정 추가")
        .onAppear {
            if let item = editingItem {
                title = item.title ?? ""
                date = item.timestamp ?? Date()
                description = item.descriptionText ?? ""
                showPastDateWarning = date < Date()
            }
        }
    }

    private func saveSchedule() {
        let item = editingItem ?? MyItem(context: viewContext)
        item.timestamp = date
        item.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        item.descriptionText = description

        do {
            try viewContext.save()
            dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
