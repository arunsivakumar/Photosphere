//
//  FlickrAPI.swift
//  Photosphere
//
//  Created by Lakshmi on 7/29/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import Foundation

enum Method:String{
    case interestingPhotos = "flickr.interestingness.getList"
}
struct FlickrAPI{
    private static let baseURLString = "https://api.flickr.com/service/rest"
    
    
    private static func flickrURL(method:Method, parameters:[String:String]?) ->URL{
        return URL(string:"")!
    }
    
    
    static var interestingPhotosURL:URL{
        return flickrURL(method: .interestingPhotos, parameters: ["extras":"url_h,dateTaken"])
    }
}
