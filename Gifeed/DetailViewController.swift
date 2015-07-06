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
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var selectedGif: Gif!
    var imageIdentifier: String!
    var imageData: NSData!
    var doubleTapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTapRecognizer.numberOfTapsRequired = 2
    }
    
    override func viewWillAppear(animated: Bool) {
        showAnimatedGif(selectedGif)
        
        self.view.addGestureRecognizer(doubleTapRecognizer!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.view.removeGestureRecognizer(doubleTapRecognizer!)
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
            
            //Hide the save button
            hideSaveButton(true)
            
            let image = UIImage.animatedImageWithData(selectedGif.photoImage!)
            
            self.imageData = selectedGif.photoImage
           
            //Update the cell later, on the main thread
            dispatch_async(dispatch_get_main_queue()) {
                self.detailImageView.image = image
                self.activityIndicator.stopAnimating()
                self.shareButton.enabled = true
            }
        }
        else {
                //Checking for internet connection first.
                if Reachability.isConnectedToNetwork() == true {
                
                let task = Giphy.sharedInstance().taskForImage(selectedGif.animatedImageURL) { imageData, error in
                    
                    if let data = imageData {
                        //Create the image
                        let image = UIImage.animatedImageWithData(data)
                        
                        self.imageData = data
                        
                        //Update the cell later, on the main thread
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.detailImageView.image = image
                            self.activityIndicator.stopAnimating()
                            self.shareButton.enabled = true
                        }
                    }
                }
            }
            else {
                var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
                    self.activityIndicator.stopAnimating()
                    hideSaveButton(true)
            }
        }
    }

    @IBAction func shareButton(sender: AnyObject) {
        shareImage()
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        saveImage()
    }
    
//    @IBAction func saveButton(sender: AnyObject) {
//        saveImage()
//    }
    
    func hideSaveButton(status: Bool) {
        if status {
            saveButton.hidden = true
        }
    }
    
    func saveImage() {
        
        //Hide the save button
        self.hideSaveButton(true)
        
        //Update the model, so that the information gets save inside documents directory
        self.selectedGif.photoImage = imageData
        
        // The gif that was selected is from a different managed object context.
        // We need to make a new gif. An easy way is to make a dictionary.
        let dictionary: [String: AnyObject] = [
            "id" : selectedGif.imageID,
            "source" : selectedGif.imageSource,
            "bitly_url" : selectedGif.imageBitlyURL,
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
    
    func shareImage() {
        
        /* By now, the best way for sharing an animated gif from an app is to copy the link of it. In case of facebook, it recognize it and insert the GIF ready to be animated with a clic inside the post. If you try to share the UIImage or NSData of the animated GIF, only the first frame will get shared. */
        
        let stringForSharing = "\(selectedGif.imageBitlyURL) via Gifeed App"
        
        let activityController = UIActivityViewController(activityItems: [stringForSharing], applicationActivities: nil)
        
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    func handleDoubleTap(sender: UITapGestureRecognizer){
        if !saveButton.hidden {
            saveImage()
        }
        else {
            println("Already saved!")
        }
    }
    
}
