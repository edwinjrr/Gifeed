//
//  DetailViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedGif: Gif!
    var imageIdentifier: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //println(selectedGif.animatedImageURL)
        
        let task = Giphy.sharedInstance().taskForImage(selectedGif.animatedImageURL) { imageData, error in
            
            if let data = imageData {
                let image = UIImage.animatedImageWithData(data)
                
                //update the cell later, on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.detailImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
