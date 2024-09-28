import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: MyItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MyItem.timestamp, ascending: true)],
        animation: .default
    ) private var items: FetchedResults<MyItem>

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        VStack(alignment: .leading) {
                            if let title = item.title {
                                Text(title)
                                    .font(.headline) // upper headline
                            }
                            
                            if let timestamp = item.timestamp {
                                Text(timestamp, formatter: itemFormatter)
                                    .font(.subheadline) // smalle time and date
                                    .foregroundColor(.gray) // print as gray
                            }
                            
                            if let description = item.descriptionText {
                                Text(description)
                                    .font(.body) // description as default size
                                    .lineLimit(2) // limit line
                            }
                        }
                    }
                }
                .onDelete(perform: deleteItems)
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
    
    private func addItem() {
        withAnimation {
            let newItem = MyItem(context: viewContext)
            newItem.timestamp = Date()
            newItem.title = "New Item"
            newItem.descriptionText = "Description of new item"

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }


    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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


