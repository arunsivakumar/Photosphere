//
//  FlickrAPI.swift
//  Photosphere
//
//  Created by Lakshmi on 7/29/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import Foundation

/**
    Flickr API Endpoint
    - interestingPhotos: For fetching interesting photos
*/

enum Method:String{
    
    case interestingPhotos = "flickr.interestingness.getList"
    
}

/// A FlickrAPI constructor 
struct FlickrAPI{
    
    private static let baseURLString =  "https://api.flickr.com/services/rest"
    private static let apiKey = "fd3c0d32acfaca425895462a4194ee13"
    
    /**
     Constructs Flickr URL
     
     - Parameters:
        - method: Flickr API Endpoint
        - parameters: Query items
     
     - Returns: URL constructed from method,base parameters and additional parameters
     */
    
    private static func flickrURL(method:Method, parameters:[String:String]?) ->URL{
        
        var components = URLComponents(string:baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters{
            for(key,value) in additionalParams{
              let item = URLQueryItem(name: key, value: value)
              queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    
    /// Construct interestingPhotos URL
    static var interestingPhotosURL:URL{
        return flickrURL(method: .interestingPhotos, parameters: ["extras":"url_h,dateTaken"])
    }
}
