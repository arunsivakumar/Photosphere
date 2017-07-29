//
//  PhotoStore.swift
//  Photosphere
//
//  Created by Lakshmi on 7/29/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import Foundation

/**
 
 Photos result from API
    
    - success: Array of photos
    - failure: Error (Data task Error, JSON processing error )
 
 */
enum PhotosResult{
    case success([Photo])
    case failure(Error)
}

class PhotoStore{

    /// Holds a URLSession instance.
    private let session:URLSession = {
       let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    /**
       Fetches interesting photos by Connecting to api.flickr.com.
       and uses URLSession to create URLSessionDataTask to transfer request to server.
     
     - Parameters:
        - completion: PhotosResult.
     
      - Returns:
        - Void
    */
    func fetchInterestingPhotos(completion:  @escaping (PhotosResult) -> Void){
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            let result = self.processPhotosRequest(data: data, error: error)
            completion(result)
            
        }
        task.resume()
        
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult{
        guard let jsonData = data else{
            return .failure(error!)
        }
        
        return FlickrAPI.photos(fromJSON: jsonData)
    }
}
