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
                HStack {
                    Text("Total Albums")
                    Spacer()
                    Text("\(totalAlbums)")
                }
                .foregroundColor(.green)
                
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
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu("Sort") {
                        Button("Sort by Title") {
                            let sort = SortDescriptor(\Album.albumTitle, order: .forward)
                            listOfAlbums.sortDescriptors = [sort]
                        }
                        
                        
                        Button("Sort by Artist") {
                            let sort1 = SortDescriptor(\Album.artistName, order: .forward)
                            let sort2 = SortDescriptor(\Album.releaseYear, order: .reverse)
                            listOfAlbums.sortDescriptors = [sort1, sort2]
                        }

                        Button("Sort by Year") {
                            let sort1 = SortDescriptor(\Album.releaseYear, order: .reverse)
                            let sort2 = SortDescriptor(\Album.albumTitle, order: .forward)
                            listOfAlbums.sortDescriptors = [sort1, sort2]
                        }

                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: InsertAlbumView(), label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .searchable(text: $search, prompt: Text("Insert year"))
            .onChange(of: search) { value in
                if value.count == 4 {
                    if let year = Int32(value) {
                        listOfAlbums.nsPredicate = NSPredicate(format: "year >= %@", NSNumber(value: year))
                    } else {
                        listOfAlbums.nsPredicate = nil
                    }
                } else {
                    listOfAlbums.nsPredicate = nil
                }
            }
            .onAppear {
                countAlbums()
            }
        }
    }
    
    func countAlbums() {
        let request: NSFetchRequest<Album> = Album.fetchRequest()
        if let list = try? self.dbContext.fetch(request) {
            totalAlbums = list.count
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
