import SwiftUI

struct DetailView: View {
    @ObservedObject var item: MyItem

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let title = item.title {
                Text(title)
                    .font(.largeTitle)
                    .padding(.bottom, 4)
            }

            if let timestamp = item.timestamp {
                Text("날짜: \(timestamp, formatter: itemFormatter)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let description = item.descriptionText, !description.isEmpty {
                Text(description)
                    .font(.body)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("상세 보기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddScheduleView(editingItem: item)) {
                    Text("수정")
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()
