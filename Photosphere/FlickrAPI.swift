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
    - interestingPhotos: For fetching interesting photos.
*/

enum FlickrError: Error{
    case invalidJSONData
}

enum Method:String{
    case interestingPhotos = "flickr.interestingness.getList"
}

/// A FlickrAPI constructor 
struct FlickrAPI{
    
    private static let baseURLString =  "https://api.flickr.com/services/rest"
    private static let apiKey = "fd3c0d32acfaca425895462a4194ee13"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-ss HH:mm:ss"
        return formatter
    }()
    
    /**
     Constructs Flickr URL.
     
     - Parameters:
        - method: Flickr API Endpoint.
        - parameters: Query items.
     
     - Returns: URL constructed from method,base parameters and additional parameters.
     */
    
    private static func flickrURL(method:Method, parameters:[String:String]?) -> URL{
        
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
        return flickrURL(method: .interestingPhotos, parameters: ["extras":"url_h,date_taken"])
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult{
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable:Any],
                let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]] else{
                    
                    // The JSON structure if not valid
                    return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            
            for photoJSON in photosArray{
                if let photo = photo(fromJSON: photoJSON){
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty{
                // Error parsing JSON
                return .failure(FlickrError.invalidJSONData)
            }
            return .success(finalPhotos)
            
        }catch let error{
            return .failure(error)
        }
    }

    private static func photo(fromJSON json:[String: Any]) -> Photo?{
        guard
            let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string:photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else{
                
                // Information is not enough to construct a photo
                return nil
            }
         return Photo(title: title, photoID: photoID, remoteURL: url, dateTaken: dateTaken)
    }
}
