//
//  Photo.swift
//  Photorama
//
//  Created by Jawaher Alagel on 10/28/20.
//

import Foundation


class Photo: Codable {
    let photoID: String
    let title: String
    let remoteURL: URL?
    let dateTaken: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
    
}

// Defining Photo equality
extension Photo: Equatable {
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}
