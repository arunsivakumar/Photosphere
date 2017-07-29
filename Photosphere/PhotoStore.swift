//
//  PhotoStore.swift
//  Photosphere
//
//  Created by Lakshmi on 7/29/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import Foundation


class PhotoStore{

    /// Holds a URLSession instance.
    private let session:URLSession = {
       let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    /**
       Fetches interesting photos.
     
      - Connects to api.flickr.com.
      - Uses URLSession to create URLSessionDataTask to transfer request to server.
     
    */
    func fetchInterestingPhotos(){
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request){
            (data, response, error) -> Void in
            
            if let jsonData = data{
                
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData,
                                                                      options: [])
                    print(jsonObject)
                } catch let error {
                    print("Error creating JSON object: \(error)")
                }
                
            }else if let requestError = error{
                print("error fetching interesting photos: \(requestError)")
            }else{
                print("unexpected error with request")
            }
            
        }
        task.resume()
        
    }
    
}
