//
//  ContentView.swift
//  songAlbumCollection
//
//  Created by Jacob Conacher on 11/28/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [SortDescriptor(\Album.albumTitle, order: .forward)], predicate: nil, animation: .default)
    private var listOfAlbums: FetchedResults<Album>

    var body: some View {
        Text("Hello")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
