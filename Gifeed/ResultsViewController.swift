//
//  ResultsViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Outlets
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var notFoundImageView: UIImageView!
    
    //Properties
    var gifs = [Gif]()
    var searchString: String!
    var navigationBarTitle: String!
    var notFoundImage: UIImage!
    var temporaryContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get the managed object context
        let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
        
        //Replace the title with the search string
        self.navigationItem.title = navigationBarTitle

        //Set the row height of the TableViewCells.
        resultsTableView.rowHeight = UITableViewAutomaticDimension
        resultsTableView.estimatedRowHeight = 350
        
        // Set the temporary context
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
        
        //Prepare the placeholder image in case no gifs where found.
        var notFoundImageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("infinite", withExtension: "gif")!)
        notFoundImage = UIImage.animatedImageWithData(notFoundImageData!)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if !searchString.isEmpty {
            downloadGifsBySearchString()
        }
        else {
            self.notFoundImageView.hidden = false
            self.notFoundImageView.image = self.notFoundImage
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.notFoundImageView.hidden = true
    }
    
    //MARK: Giphy API search method:
    
    func downloadGifsBySearchString() {
        
        //Check for internet connection first.
        if Reachability.isConnectedToNetwork() == true {
        
            let searchStringFormatted = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+")
            
            Giphy.sharedInstance().getGifFromGiphyBySearch(searchStringFormatted, completionHandler: { (results, error) -> Void in
                
                if let error = error {
                    self.alertView("Oops!!", message: "Something went wrong, try again...")
                }
                else {
                    
                    if let results = results {
                        
                        if results.isEmpty {
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.notFoundImageView.hidden = false
                                self.notFoundImageView.image = self.notFoundImage
                            }
                        }
                        else {
                            
                            self.gifs = Gif.gifsFromResults(results, insertIntoManagedObjectContext: self.temporaryContext)
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.resultsTableView.reloadData()
                            }
                        }
                    }
                }
            })
        }
        else {
            
            //If there isn't internet connection, an alert view will appear.
            var alert = UIAlertView(
                title: "No Internet Connection",
                message: "Make sure your device is connected to the internet.",
                delegate: nil,
                cancelButtonTitle: "OK")
            
            alert.show()
        }
    }
    
    //MARK: Table view data source methods:
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let gif = gifs[indexPath.row]
        var stillImage: UIImage!
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultCell
        
        cell.loadingIndicator.startAnimating()
        cell.resultImageView.image = nil
        cell.sizeLabel.text = ""
        
        //Get the image size in a format easy to understand.
        var imageSizeFormatted = sizeNumberFormatting(gif.imageSize)
        
        if gif.cacheStillPhotoImage != nil {
            
            let image = UIImage(data: gif.cacheStillPhotoImage!)
            stillImage = image
            cell.loadingIndicator.stopAnimating()
            cell.sizeLabel.text = "Size: \(imageSizeFormatted)"
        }
        else {
        
            let task = Giphy.sharedInstance().taskForImage(gif.stillImageURL) { imageData, error in
                
                if let data = imageData {
                    //Create the image
                    let image = UIImage(data: data)
                    
                    //Update the model, so that the information gets cashed
                    gif.cacheStillPhotoImage = data
                    
                    // update the cell later, on the main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.resultImageView.image = image
                        cell.loadingIndicator.stopAnimating()
                        cell.sizeLabel.text = "Size: \(imageSizeFormatted)"
                    }
                }
            }
            
            // This is the custom property on this cell. It uses a property observer,
            // any time its value is set it canceles the previous NSURLSessionTask.
            cell.taskToCancelifCellIsReused = task
        }
        
        cell.resultImageView.image = stillImage
        
        return cell
    }
    
    //MARK: Table view delegate methods:
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as! DetailViewController
        
        //Send the selected GIF to the DetailViewController.
        detailController.selectedGif = self.gifs[indexPath.row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
        //Prevent that the cell stays selected.
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //MARK: Helper methods:
    
    //Get the image size in a format easy to understand.
    func sizeNumberFormatting(imageSizeString: String) -> String {
        
        let imageSizeNumber = (imageSizeString as NSString).floatValue
        var formattedSizeString = ""
        
        if imageSizeNumber > 1000000 {
            
            var numberOfMB = imageSizeNumber / 1000000
            var stringNumber = String(stringInterpolationSegment: numberOfMB)
            formattedSizeString = "\(subStringByRange(stringNumber, start: 0, end: 3)) MB"
        }
        else{
            
            var numberOfKB = imageSizeNumber / 1000
            var stringNumber = String(stringInterpolationSegment: numberOfKB)
            formattedSizeString = "\(subStringByRange(stringNumber, start: 0, end: 3)) KB"
        }
        
        return formattedSizeString
    }
    
    //Meant to format the image source string. Currently not used.
    func subStringByRange(string: String, start: Int, end: Int) -> String {
        let range = Range(start: advance(string.startIndex, start),
            end: advance(string.startIndex, end))
        return string.substringWithRange(range)
    }
    
    //Show a alert view controller with a title, a message and an "OK" button.
    func alertView(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
