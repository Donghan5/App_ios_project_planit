import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: MyItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MyItem.timestamp, ascending: true)],
        animation: .default
    ) private var items: FetchedResults<MyItem>

    private var groupedItems: [(String, [MyItem])] {
        let grouped = Dictionary(grouping: items) { item -> String in
            guard let date = item.timestamp else { return "날짜 없음" }
            return sectionFormatter.string(from: date)
        }
        return grouped.sorted { lhs, rhs in
            let lhsDate = lhs.value.first?.timestamp ?? .distantPast
            let rhsDate = rhs.value.first?.timestamp ?? .distantPast
            return lhsDate < rhsDate
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if items.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 56))
                            .foregroundStyle(.secondary)
                        Text("일정이 없습니다")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                        Text("+ 버튼을 눌러 새 일정을 추가하세요")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(groupedItems, id: \.0) { sectionTitle, sectionItems in
                            Section(header: Text(sectionTitle)) {
                                ForEach(sectionItems, id: \.self) { item in
                                    NavigationLink(destination: DetailView(item: item)) {
                                        VStack(alignment: .leading) {
                                            if let title = item.title {
                                                Text(title)
                                                    .font(.headline)
                                            }

                                            if let timestamp = item.timestamp {
                                                Text(timestamp, formatter: timeFormatter)
                                                    .font(.subheadline)
                                                    .foregroundStyle(.secondary)
                                            }

                                            if let description = item.descriptionText, !description.isEmpty {
                                                Text(description)
                                                    .font(.body)
                                                    .foregroundStyle(.secondary)
                                                    .lineLimit(2)
                                            }
                                        }
                                    }
                                }
                                .onDelete { offsets in
                                    deleteItems(sectionItems: sectionItems, offsets: offsets)
                                }
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    NavigationLink(destination: AddScheduleView()) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("일정 목록")
        }
    }

    private func deleteItems(sectionItems: [MyItem], offsets: IndexSet) {
        withAnimation {
            offsets.map { sectionItems[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let sectionFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter
}()
