//
//  PhotoStore.swift
//  Photosphere
//
//  Created by Lakshmi on 7/29/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import UIKit

/**
 
 Downloaded Photo from URL
 
 - success: UIImage
 - failure: Error
 
 */

enum ImageResult {
      case success(UIImage)
      case failure(Error)
}

enum PhotoError: Error{
     case imageCreationError
}

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
    
    
    func fetchImage(for photo:Photo, completion: @escaping (ImageResult) -> Void){
        
        let photoURL = photo.remoteURL
        let request = URLRequest(url:photoURL)
        
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> ImageResult{
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else{
                
                
                // error creating image
                if data == nil{
                    return .failure(error!)
                }else{
                    return .failure(PhotoError.imageCreationError)
                }
        }
        
        return .success(image)
    }
}
