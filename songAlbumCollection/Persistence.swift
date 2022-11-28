//
//  Persistence.swift
//  songAlbumCollection
//
//  Created by Jacob Conacher on 11/28/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let defaultAlbum1 = Album(context: viewContext)
        defaultAlbum1.albumTitle = "Elsewhere"
        defaultAlbum1.artistName = "Set It Off"
        defaultAlbum1.releaseYear = 2022
        defaultAlbum1.cover = nil
        
        let defaultAlbum2 = Album(context: viewContext)
        defaultAlbum2.albumTitle = "OK ORCHESTRA"
        defaultAlbum2.artistName = "AJR"
        defaultAlbum2.releaseYear = 2021
        defaultAlbum2.cover = nil

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "songAlbumCollection")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
