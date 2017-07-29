//
//  Photo.swift
//  Photosphere
//
//  Created by Lakshmi on 7/29/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import Foundation

/// 📷 Photo from Flickr
class Photo {
    
    /// The Title of the photo
    let title: String
    
    /// The URL of the photo
    let remoteURL: URL
    
    /// The unique ID of the photo
    let photoID: String
    
    /// The date the photo was taken
    let dateTaken: Date
    
    /**
     Initializes a photo.
     
     - Parameters:
        - title: The Title of the photo
        - photoID: The unique ID of the photo
        - remoteURL: The URL of the photo
        - dateTaken: The date the photo was taken
     
     - Returns: Photo
     */
    
    init(title: String, photoID: String, remoteURL: URL, dateTaken: Date) {
        self.title = title
        self.photoID = photoID
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
}

extension Photo: Equatable {
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        // compare if the two photos arethe same
        return lhs.photoID == rhs.photoID
    }
}
