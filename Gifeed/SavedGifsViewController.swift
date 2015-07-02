//
//  SavedGifsViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class SavedGifsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var savedGifsCollectionView: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var gifs = [Gif]()
    var editModeEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        gifs = fetchAllGifs()
    }
    
    // Layout the collection view
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Lay out the collection view so that cells take up 1/3 of the width, with a small space in between.
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        
        let width = floor((self.savedGifsCollectionView.frame.size.width/3) - 2)
        layout.itemSize = CGSize(width: width, height: width)
        savedGifsCollectionView.collectionViewLayout = layout
    }
    
    // MARK: - Core Data Convenience
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    
    func fetchAllGifs() -> [Gif] {
        let error: NSErrorPointer = nil
        
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Gif")
        
        // Execute the Fetch Request
        let results = sharedContext.executeFetchRequest(fetchRequest, error: error)
        
        // Check for Errors
        if error != nil {
            println("Error in fectchAllActors(): \(error)")
        }
        
        // Return the results, cast to an array of Person objects
        return results as! [Gif]
    }
    
    //MARK: Collection view data source methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let gif = gifs[indexPath.item]
        var stillImage: UIImage!
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SavedGifCell", forIndexPath: indexPath) as! SavedGifCell
        
        cell.loadingIndicator.startAnimating()
        cell.imageView.image = nil
        
        // Add an action function to the delete button
        //cell.deleteButton.addTarget(self, action: "deleteGif:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if gif.stillPhotoImage != nil {
            
            let image = UIImage(data: gif.stillPhotoImage!)
            stillImage = image
            cell.loadingIndicator.stopAnimating()
        }
        else {
            
            let task = Giphy.sharedInstance().taskForImage(gif.stillImageURL) { imageData, error in
                
                if let data = imageData {
                    //Create the image
                    let image = UIImage(data: data)
                    
                    //Update the model, so that the information gets cashed
                    gif.stillPhotoImage = data
                    
                    // update the cell later, on the main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.imageView.image = image
                        cell.loadingIndicator.stopAnimating()
                    }
                }
            }
        }
        
        cell.imageView.image = stillImage
        
        return cell
    }
    
    //MARK: Collection view delegate methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if editModeEnabled {
            deleteGIF(collectionView, indexPath: indexPath)
        }
        else {
            let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as! DetailViewController
            detailController.selectedGif = self.gifs[indexPath.item]
            detailController.itemSaved = true
            
            self.navigationController!.pushViewController(detailController, animated: true)
        }
    }
    
    func deleteGIF(collectionView: UICollectionView, indexPath: NSIndexPath) {
        
        //Get the selected object
        let gif = gifs[indexPath.item]
        
        //Remove object from array
        gifs.removeAtIndex(indexPath.item)
        
        //Remove item from collection
        collectionView.deleteItemsAtIndexPaths([indexPath])
        
        //Remove object from core data
        sharedContext.deleteObject(gif)
        
        //Prepare the images identifiers
        let animatedImageIdentifier: String = gif.imageID
        let stillImageIdentifier: String = "\(gif.imageID)_still"
        
        //Remove the images files from the documents directory
        removeFromDocumentsDirectory(animatedImageIdentifier)
        removeFromDocumentsDirectory(stillImageIdentifier)
        
        self.saveContext()
    }
    
    //Remove images from the documents directory
    func removeFromDocumentsDirectory(identifier: String) {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        let path = fullURL.path!
        
        NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
        NSCache().removeObjectForKey(path)
    }
    
    @IBAction func editMode(sender: AnyObject) {  //TODO: Test with non-visible cells.
        if !editModeEnabled {
            
            //Put the collection view in edit mode
            editButton.title = "Done"
            editButton.style = .Done
            editModeEnabled = true
            
            // Loop through the collectionView's visible cells
            for item in self.savedGifsCollectionView.visibleCells() {
                var indexPath = self.savedGifsCollectionView.indexPathForCell(item as! SavedGifCell)!
                var cell = self.savedGifsCollectionView.cellForItemAtIndexPath(indexPath) as! SavedGifCell!
                cell.deleteButton.hidden = false // Show all of the delete buttons
                cell.imageView.alpha = 0.50
            }
        }
        else {
            //Take the collection view out of edit mode
            editButton.title = "Edit"
            editButton.style = .Plain
            editModeEnabled = false
            
            // Loop through the collectionView's visible cells
            for item in self.savedGifsCollectionView.visibleCells() {
                var indexPath = self.savedGifsCollectionView.indexPathForCell(item as! SavedGifCell)!
                var cell = self.savedGifsCollectionView.cellForItemAtIndexPath(indexPath) as! SavedGifCell!
                cell.deleteButton.hidden = true // Show all of the delete buttons
                cell.imageView.alpha = 1
            }
        }
    }
}
