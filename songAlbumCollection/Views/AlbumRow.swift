//
//  AlbumRow.swift
//  songAlbumCollection
//
//  Created by Jacob Conacher on 11/28/22.
//

import SwiftUI

struct AlbumRow: View {
    
    let album: Album
    
    var body: some View {
        
        HStack(alignment: .top) {
            Image(uiImage: album.showCover)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 100)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(album.showTitle)
                    .bold()
                Text(album.showArtist)
                    .foregroundColor((album.artistName != nil) ? .black : .gray)
                
                Text(album.showYear)
                    .font(.caption)
                
            }
            .padding(.top, 5)
            
            Spacer()
        }
    }
}

struct BookRow_Previews: PreviewProvider {
    
    static let viewContext = PersistenceController.preview.container.viewContext
    
    static var album: Album {
        let defaultAlbum = Album(context: viewContext)
        defaultAlbum.albumTitle = "Elsewhere"
        defaultAlbum.artistName = "Set It Off"
        defaultAlbum.releaseYear = 2022
        defaultAlbum.cover = nil
        
        return defaultAlbum
    }
    
    static var previews: some View {
        AlbumRow(album: album)
            .previewLayout(.sizeThatFits)
    }
}
