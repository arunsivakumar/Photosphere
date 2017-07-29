//
//  ViewController.swift
//  Photosphere
//
//  Created by Lakshmi on 7/29/17.
//  Copyright © 2017 com.arunsivakumar. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView:UIImageView!
    var store:PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchInterestingPhotos { (photosResult) in
            
            switch photosResult {
            case let .success(photos):
                print("sucessfully found \(photos.count) photos")
                if let firstPhoto = photos.first{
                    self.updateImageView(for: firstPhoto)
                }
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
    
    
    
    func updateImageView(for photo:Photo){
        store.fetchImage(for: photo) { (imageResult) in
            
          switch imageResult{
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error downloading image:\(error)")
            }
        }
    }
}

