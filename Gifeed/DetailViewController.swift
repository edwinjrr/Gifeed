//
//  DetailViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveGifButton: UIButton!
    
    var selectedGif: Gif!
    var imageIdentifier: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        showAnimatedGif(selectedGif)
    }
    
    // MARK: - Core Data Convenience. This will be useful for fetching. And for adding and saving objects as well.
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func showAnimatedGif(gif: Gif) {
        
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

    @IBAction func saveGif(sender: AnyObject) {
        
        // The gif that was selected is from a different managed object context.
        // We need to make a new gif. The easiest way to do that is to make a dictionary.
        let dictionary: [String: AnyObject] = [
            "id" : selectedGif.imageID,
            "source" : selectedGif.imageSource,
            "images" : ["original" : [
                                "url": selectedGif.animatedImageURL,
                                "size": selectedGif.imageSize],
                        "original_still" : ["url": selectedGif.stillImageURL]
            ]
        ]
        
        // Now we create a new Gif, using the shared Context
        let gifToBeSaved = Gif(dictionary: dictionary, insertIntoManagedObjectContext: sharedContext)
        
        saveContext()
    }
}
