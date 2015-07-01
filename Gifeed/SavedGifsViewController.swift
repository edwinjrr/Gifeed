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
    
    var gifs = [Gif]()

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
            
            // This is the custom property on this cell. It uses a property observer,
            // any time its value is set it canceles the previous NSURLSessionTask.
            //cell.taskToCancelifCellIsReused = task
        }

        
        cell.imageView.image = stillImage
        
        return cell
    }
    
    //MARK: Collection view delegate methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as! DetailViewController
        detailController.selectedGif = self.gifs[indexPath.item]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
