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
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var notFoundImageView: UIImageView!
    
    var gifs = [Gif]()
    var searchString: String!
    var navigationBarTitle: String!
    var notFoundImage: UIImage!
    
    var temporaryFiles = [String]()
    
    var temporaryContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = navigationBarTitle

        resultsTableView.rowHeight = UITableViewAutomaticDimension
        resultsTableView.estimatedRowHeight = 350
        
        let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
        
        // Set the temporary context
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
        
        //Prepare the placeholder image in case no gifs where found.
        var notFoundImageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("infinite", withExtension: "gif")!)
        notFoundImage = UIImage.animatedImageWithData(notFoundImageData!)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if !searchString.isEmpty {
            downloadGifsBySearchString()
        }
        else {
            println("Empty searchString. Show placeholder")
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
                    println("Error with the Giphy method.") //<--- Setup an AlertView here!
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
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    //MARK: Table view data source methods:
    
    //TODO:---->Short it!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let gif = gifs[indexPath.row]
        var stillImage: UIImage!
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultCell
        
        cell.loadingIndicator.startAnimating()
        cell.resultImageView.image = nil
        //cell.sourceLabel.text = ""
        cell.sizeLabel.text = ""
        
        //var sourceStringFormatted: String!
        
//        if gif.imageSource != "" {
//            sourceStringFormatted = gif.imageSource.stringByReplacingOccurrencesOfString("http://", withString: "")
//        }
//        else {
//            sourceStringFormatted = "We know nothing..."
//        }
        
        var imageSizeFormatted = sizeNumberFormatting(gif.imageSize)
        
        if gif.cacheStillPhotoImage != nil {
            
            let image = UIImage(data: gif.cacheStillPhotoImage!)
            stillImage = image
            cell.loadingIndicator.stopAnimating()
            //cell.sourceLabel.text = "Source: \(sourceStringFormatted)"
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
                        //cell.sourceLabel.text = "Source: \(sourceStringFormatted)"
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
        detailController.selectedGif = self.gifs[indexPath.row]
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    //MARK: Helper methods:
    
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
    
    func subStringByRange(string: String, start: Int, end: Int) -> String {
        let range = Range(start: advance(string.startIndex, start),
            end: advance(string.startIndex, end))
        return string.substringWithRange(range)
    }
}
