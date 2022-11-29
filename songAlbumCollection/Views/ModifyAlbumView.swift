//
//  ModifyAlbumView.swift
//  songAlbumCollection
//
//  Created by Jacob Conacher on 11/28/22.
//

import SwiftUI
import PhotosUI

struct ModifyAlbumView: View {
    
    @Environment(\.managedObjectContext) var dbContext
    @Environment(\.dismiss) var dismiss
    
    @State private var inputTitle = ""
    @State private var inputYear = ""
    @State private var inputArtist = ""
    
    @State var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @State private var valuesLoaded = false
    
    let album: Album?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Title:")
                    TextField("Insert title", text: $inputTitle)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("Year:")
                    TextField("Insert year", text: $inputYear)
                        .textFieldStyle(.roundedBorder)
                }
                
                HStack {
                    Text("Artist:")
                    TextField("Insert artist", text: $inputArtist)
                        .textFieldStyle(.roundedBorder)
                }

                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: 20))
                        
                        Text("Photo Library")
                            .font(.headline)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                
                if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Image("nopicture")
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Modify Album")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newTitle = inputTitle.trimmingCharacters(in: .whitespaces)
                        let year = Int32(inputYear)
                        let newArtist = inputArtist.trimmingCharacters(in: .whitespaces)
                        if !newTitle.isEmpty && year != nil {
                            Task(priority: .high) {
                                await storeAlbum(title: newTitle, year: year!, artist: newArtist)
                            }
                        }
                        
                    }
                }
            }
        }
        .onAppear {
            if !valuesLoaded {
                inputArtist = album?.showArtist ?? ""
                inputTitle = album?.showTitle ?? ""
                inputYear = album?.showYear ?? ""
                selectedImageData = album?.cover
                valuesLoaded = true
            }
        }
    }
    
    func storeAlbum(title: String, year: Int32, artist: String) async {
        await dbContext.perform {
            album?.albumTitle = title
            album?.releaseYear = year
            album?.artistName = artist
            
            if selectedImageData != nil {
                album?.cover = selectedImageData
            } else {
                album?.cover = nil
            }
            
            do {
                try dbContext.save()
                dismiss()
            } catch {
                print(error)
            }
        }
    }
}

struct ModifyBookView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyAlbumView(album: nil)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
