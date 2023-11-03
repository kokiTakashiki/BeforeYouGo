//
//  ContentView.swift
//  BeforeYouGo
//
//  Created by takedatakashiki on 2023/11/03.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(Array(items.enumerated()), id: \.element) { index, item in
                    NavigationLink {
                        VStack {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            Button("Back", action: {})
                        }
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                            .contextMenu {
                                menuItems(index: index)
                            }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    private func menuItems(index: Int) -> some View {
        Group {
            Button(action: {
                withAnimation {
                    modelContext.delete(items[index])
                }
            }, label: {
                Text("🗑️ Delete")
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
