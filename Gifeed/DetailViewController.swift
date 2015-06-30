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
        
        if selectedGif.photoImage != nil {
            let image = UIImage.animatedImageWithData(selectedGif.photoImage!)
            
            //Update the cell later, on the main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.detailImageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }
        else {
        
            let task = Giphy.sharedInstance().taskForImage(selectedGif.animatedImageURL) { imageData, error in
                
                if let data = imageData {
                    //Create the image
                    let image = UIImage.animatedImageWithData(data)
                    
                    //Update the model, so that the information gets cashed
                    self.selectedGif.photoImage = data
                    
                    //Update the cell later, on the main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.detailImageView.image = image
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
