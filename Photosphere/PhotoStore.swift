//
//  PhotoStore.swift
//  Photosphere
//
//  Created by Lakshmi on 7/29/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import UIKit
import CoreData

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
    
    let imageStore = ImageStore()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photosphere")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()



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
            
//            let result = self.processPhotosRequest(data: data, error: error)
            var result = self.processPhotosRequest(data: data, error: error)

            // saving changes
            if case .success(_) = result {
                do {
                    try self.persistentContainer.viewContext.save()
                } catch {
                    result = .failure(error)
                }
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
        
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> PhotosResult{
        guard let jsonData = data else{
            return .failure(error!)
        }
        
        return FlickrAPI.photos(fromJSON: jsonData, into: persistentContainer.viewContext)
    }
    
    func fetchAllPhotos(completion: @escaping (PhotosResult) -> Void) {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDateTaken = NSSortDescriptor(key: #keyPath(Photo.dateTaken), ascending: true)
        fetchRequest.sortDescriptors = [sortByDateTaken]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    
    func fetchImage(for photo:Photo, completion: @escaping (ImageResult) -> Void){
        
        
        // cache images/retrive
        guard let photoKey = photo.photoID else{
            preconditionFailure("photoexpected to have an ID")
        }
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
                completion(.success(image))
            }
        }
        
        guard let photoURL = photo.remoteURL else{
            preconditionFailure("photoexpected to have remote URL")
        }
        let request = URLRequest(url:photoURL as URL)
        
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            let result = self.processImageRequest(data: data, error: error)
           
             // cache images
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
            
            OperationQueue.main.addOperation {
                completion(result)
            }
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
