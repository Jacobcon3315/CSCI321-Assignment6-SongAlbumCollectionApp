//
//  AlbumViewModel.swift
//  songAlbumCollection
//
//  Created by Jacob Conacher on 11/28/22.
//

import Foundation
import SwiftUI

extension Album {
    var showTitle: String {
        return albumTitle ?? "Undefined"
    }
    
    var showAuthor: String {
        return artistName ?? "Undefined"
    }
    
    var showYear: String {
        return releaseYear ?? "Undefined"
    }
    
    var showCover: UIImage {
        if let data = cover, let image = UIImage(data: data) {
            return image
        } else {
            return UIImage(named: "nopicture")!
        }
    }
}