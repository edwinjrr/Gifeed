//
//  SearchViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var searchTextField: UITextField! //<--- Set up delegate.
    @IBOutlet weak var trendingGifsCollectionView: UICollectionView!
    
    var gifs = [Gif]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    //MARK: Test methods...

    @IBAction func dowloadTest(sender: AnyObject) {
        trendingSearchTest()
    }
    
    func stringSearchTest() {
        
        let textFieldString: String = "grumpy funny cat"
        let searchStringTest = textFieldString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        Giphy.sharedInstance().getGifFromGiphyBySearch(searchStringTest, completionHandler: { (results, error) -> Void in
            
            if let error = error {
                println("Error with the Giphy method.") //<--- Setup an AlertView here!
            }
            else {
                
                if let results = results as [Gif]? {
                    
                    if results.isEmpty {
                        println("Empty array")
                    }
                    else {
                        println(results)
                    }
                }
            }
        })
    }
    
    func trendingSearchTest() {
        
        Giphy.sharedInstance().getTrendingGifFromGiphy({ (results, error) -> Void in
            
            if let error = error {
                println("Error with the Giphy method.") //<--- Setup an AlertView here!
            }
            else {
                
                if let results = results as [Gif]? {
                    
                    if results.isEmpty {
                        println("Empty array")
                    }
                    else {
                        self.gifs = results
                        dispatch_async(dispatch_get_main_queue()) {
                            self.trendingGifsCollectionView.reloadData()
                        }
                    }
                }
            }
        })
    }
    
}

