//
//  SearchViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField! //<--- Set up delegate.
    @IBOutlet weak var trendingGifsCollectionView: UICollectionView!
    @IBOutlet weak var trendingNowLabel: UILabel!
    
    var gifs = [Gif]()
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    var temporaryContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
        
        // Set the temporary context
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
        
        //Download the more trending Gifs from Giphy
        downloadTrendingGifs()
        
        //Setting up the textfield
        searchTextField.delegate = self
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // Layout the collection view
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Lay out the collection view so that cells take up 1/3 of the width, with a small space in between.
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        
        let width = floor((self.trendingGifsCollectionView.frame.size.width/3) - 2)
        layout.itemSize = CGSize(width: width, height: width)
        trendingGifsCollectionView.collectionViewLayout = layout
    }
    
    //MARK: Collection view data source methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TrendingGifCell", forIndexPath: indexPath) as! TrendingGifCell
        
        let gif = gifs[indexPath.item]
        
        cell.loadingIndicator.startAnimating()
        cell.imageView.image = nil
        
        let task = Giphy.sharedInstance().taskForImage(gif.stillImageURL) { imageData, error in
            
            if let data = imageData {
                let image = UIImage(data: data)
                
                // update the cell later, on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    cell.imageView!.image = image
                    cell.loadingIndicator.stopAnimating()
                }
            }
        }
        
        // This is the custom property on this cell. It uses a property observer,
        // any time its value is set it canceles the previous NSURLSessionTask.
        cell.taskToCancelifCellIsReused = task
        
        return cell
    }
    
    //MARK: Collection view delegate methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as! DetailViewController
        detailController.selectedGif = self.gifs[indexPath.item]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    func gifsFromResults(results: [[String : AnyObject]]) -> [Gif] {
        var gifs = [Gif]()
        
        for result in results {
            gifs.append(Gif(dictionary: result, insertIntoManagedObjectContext: self.temporaryContext))
        }
        
        return gifs
    }
    
    func downloadTrendingGifs() {
        
        Giphy.sharedInstance().getTrendingGifFromGiphy({ (results, error) -> Void in
            
            if let error = error {
                println("Error with the Giphy method.") //<--- Setup an AlertView here!
            }
            else {
                
                if let results = results {
                    
                    if results.isEmpty {
                        println("Empty array") //<--- Setup an placeholder image!
                    }
                    else {
                    
                        self.gifs = Gif.gifsFromResults(results, insertIntoManagedObjectContext: self.temporaryContext)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.trendingGifsCollectionView.reloadData()
                        }
                    }
                }
            }
        })
    }
    
    //MARK: Textfield delegate methods:
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.trendingGifsCollectionView.alpha = 0.25
        self.trendingNowLabel.alpha = 0.25
        
        /* Add tap recognizer to dismiss keyboard */
        self.addKeyboardDismissRecognizer()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        segueToResultsViewController()
        
        return true
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.searchTextField.endEditing(true)
        self.searchTextField.text = ""
        self.trendingGifsCollectionView.alpha = 1
        self.trendingNowLabel.alpha = 1
        
        /* Remove tap recognizer */
        self.removeKeyboardDismissRecognizer()
    }
    
    func segueToResultsViewController() {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ResultsViewController")! as! ResultsViewController
        detailController.searchString = searchTextField.text
        detailController.navigationBarTitle = searchTextField.text
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}

