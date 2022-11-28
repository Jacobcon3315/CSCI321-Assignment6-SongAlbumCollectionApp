//
//  songAlbumCollectionApp.swift
//  songAlbumCollection
//
//  Created by Jacob Conacher on 11/28/22.
//

import SwiftUI

@main
struct songAlbumCollectionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
