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
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
        }
    }
}

