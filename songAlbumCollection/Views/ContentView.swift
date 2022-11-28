//
//  ContentView.swift
//  songAlbumCollection
//
//  Created by Jacob Conacher on 11/28/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var dbContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\Album.albumTitle, order: .forward)], predicate: nil, animation: .default)
    private var listOfAlbums: FetchedResults<Album>
    
    @State private var totalAlbums = 0
    @State private var search = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(listOfAlbums) { album in
                    NavigationLink(destination: ModifyAlbumView(album: album), label: {
                        AlbumRow(album: album).id(UUID())
                    })
                }
                .onDelete(perform: { indexes in
                    Task(priority: .high) {
                        await deleteAlbum(indexes: indexes)
                    }
                })
            }
            .listStyle(.plain)
            .navigationTitle("Album")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: InsertAlbumView(), label: {
                        Image(systemName: "plus")
                    })
                }
            }
        }
    }
    func deleteAlbum(indexes: IndexSet) async {
        await dbContext.perform {
            for index in indexes {
                dbContext.delete(listOfAlbums[index])
                totalAlbums -= 1
            }
            
            do {
                try dbContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
