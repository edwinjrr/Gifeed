//
//  ResultsViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultsTableView: UITableView!
    
    var gifs = [Gif]()
    var searchString: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTableView.rowHeight = UITableViewAutomaticDimension
        resultsTableView.estimatedRowHeight = 350
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if !searchString.isEmpty {
            downloadGifsBySearchString()
        }
        else {
            println("Empty searchString. Show placeholder")
        }
    }
    
    //MARK: Giphy API search method:
    
    func downloadGifsBySearchString() {
        
        let searchStringFormatted = searchString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        Giphy.sharedInstance().getGifFromGiphyBySearch(searchStringFormatted, completionHandler: { (results, error) -> Void in
            
            if let error = error {
                println("Error with the Giphy method.") //<--- Setup an AlertView here!
            }
            else {
                
                if let results = results as [Gif]? {
                    
                    if results.isEmpty {
                        println("Empty array") //<--- Setup an placeholder image here!
                    }
                    else {
                        self.gifs = results
                        dispatch_async(dispatch_get_main_queue()) {
                            self.resultsTableView.reloadData()
                        }
                    }
                }
            }
        })
    }
    
    //MARK: Table view data source methods:
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell", forIndexPath: indexPath) as! ResultCell
        
        let gif = gifs[indexPath.row]
        
        cell.loadingIndicator.startAnimating()
        cell.resultImageView.image = nil
        cell.sourceLabel.text = ""
        cell.sizeLabel.text = ""
        
        var sourceStringFormatted: String!
        
        if gif.imageSource != "" {
            sourceStringFormatted = gif.imageSource.stringByReplacingOccurrencesOfString("http://", withString: "")
        }
        else {
            sourceStringFormatted = "Nothing to see here..."
        }
        
        var imageSizeFormatted = sizeNumberFormatting(gif.imageSize)
        
        let task = Giphy.sharedInstance().taskForImage(gif.stillImageURL) { imageData, error in
            
            if let data = imageData {
                let image = UIImage(data: data)
                
                // update the cell later, on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    cell.resultImageView.image = image
                    cell.loadingIndicator.stopAnimating()
                    cell.sourceLabel.text = "Source: \(sourceStringFormatted)"
                    cell.sizeLabel.text = "Size: \(imageSizeFormatted)"
                }
            }
        }
        
        // This is the custom property on this cell. It uses a property observer,
        // any time its value is set it canceles the previous NSURLSessionTask.
        cell.taskToCancelifCellIsReused = task
        
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
