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

    //Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var trendingGifsCollectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var trendingNowLabel: UILabel!
    
    //If the connection fails this button will appear allowing the user to try again.
    @IBOutlet weak var retryButton: UIButton!
    
    //Properties
    var gifs = [Gif]()
    var tapRecognizer: UITapGestureRecognizer!
    var refreshControl: UIRefreshControl!
    var temporaryContext: NSManagedObjectContext!
    var searchImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the temporary context for the trending GIFs objects.
        temporaryContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        temporaryContext.persistentStoreCoordinator = sharedContext.persistentStoreCoordinator
        
        //Download the trending Gifs from Giphy
        downloadTrendingGifs()
        
        //Setting up the textfield delegate
        searchTextField.delegate = self
        
        //Configure the UI
        configureUI()
    }
    
    // Setup the shake gesture for secret search.
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if motion == .MotionShake {
            self.searchTextField.text = "Shake it off"
            segueToResultsViewController()
        }
    }
    
    // MARK: - Core Data Convenience.
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
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
        
        cell.backgroundColor = UIColor.grayColor()
        cell.loadingIndicator.startAnimating()
        cell.imageView.image = nil
        
        if gif.cacheStillPhotoImage != nil {
            
            //Retrieve the image
            let image = UIImage(data: gif.cacheStillPhotoImage!)
            cell.imageView.image = image
            cell.loadingIndicator.stopAnimating()
            
        } else {
            
            let task = Giphy.sharedInstance().taskForImage(gif.stillImageURL) { imageData, error in
                
                if let data = imageData {
                    let image = UIImage(data: data)
                    
                    //Update the model, so that the information gets cashed
                    gif.cacheStillPhotoImage = data
                    
                    //Update the cell later, on the main thread
                    dispatch_async(dispatch_get_main_queue()) {
                        cell.imageView!.image = image
                        cell.loadingIndicator.stopAnimating()
                    }
                }
            }
            
            // This is the custom property on this cell. It uses a property observer,
            // any time its value is set it canceles the previous NSURLSessionTask.
            cell.taskToCancelifCellIsReused = task
        }
        
        return cell
    }
    
    //MARK: Collection view delegate methods
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as! DetailViewController
        
        //Send the selected GIF to the DetailViewController.
        detailController.selectedGif = self.gifs[indexPath.item]
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //MARK: Giphy API search method:
    
    func downloadTrendingGifs() {
        
        //Check for internet connection first.
        if Reachability.isConnectedToNetwork() == true {
            
            //Make sure that the retry will be hidden if there is internet connection.
            retryButton.hidden = true
            
            Giphy.sharedInstance().getTrendingGifFromGiphy({ (results, error) -> Void in
                
                if let error = error {
                    self.alertView("Oops!!", message: "Something went wrong, try again...")
                }
                else {
                    
                    if let results = results {
                        
                        if results.isEmpty {
                            self.alertView("Oops!!", message: "Nothing found")
                        }
                        else {
                            
                            self.gifs = Gif.gifsFromResults(results, insertIntoManagedObjectContext: self.temporaryContext)
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.trendingGifsCollectionView.reloadData()
                                self.refreshControl.endRefreshing()
                            }
                        }
                    }
                }
            })
        }
        else {
            
            //If there isn't internet connection, an alert view will appear and the "Retry" button too.
            var alert = UIAlertView(
                title: "No Internet Connection",
                message: "Make sure your device is connected to the internet.",
                delegate: nil,
                cancelButtonTitle: "OK")
            
            alert.show()
            
            //Show the "Retry" button.
            retryButton.hidden = false
        }
    }

    //MARK: Textfield delegate methods:
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.trendingGifsCollectionView.alpha = 0.25
        self.searchButton.enabled = true
        self.searchButton.imageView?.image = searchImage
        
        /* Add tap recognizer to dismiss keyboard */
        self.addKeyboardDismissRecognizer()
    }
    
    //Called when the "Enter" button in the keyboard gets pressed.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        segueToResultsViewController()
        
        return true
    }
    
    //Adding and removing the recognizer for one tap
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    //Called when the keyboard is active and the user taps the view.
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.searchTextField.endEditing(true)
        self.searchTextField.text = ""
        self.trendingGifsCollectionView.alpha = 1
        self.searchButton.enabled = false
        
        /* Remove tap recognizer */
        self.removeKeyboardDismissRecognizer()
    }
    
    //Called when the user pulls down the collection view.
    func handleRefreshControl(sender: UIRefreshControl) {
        downloadTrendingGifs()
    }
    
    //MARK: IBActions:
    
    @IBAction func searchButton(sender: AnyObject) {
        segueToResultsViewController()
    }
    @IBAction func retryLoading(sender: AnyObject) {
        downloadTrendingGifs()
    }
    
    //MARK: Helper methods:
    
    func configureUI() {
        
        //Set a tap recognizer to hide the keyboard touching the view.
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        
        //Set a refresh control to allow pull down to refresh the collection view items.
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "handleRefreshControl:", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.backgroundColor = UIColor(red: 177/255, green: 45/255, blue: 1, alpha: 1)
        trendingGifsCollectionView.addSubview(refreshControl)
        
        //Prepare the animated gif image for the search button.
        var searchImageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("search", withExtension: "gif")!)
        searchImage = UIImage.animatedImageWithData(searchImageData!)
        searchButton.setImage(searchImage, forState: UIControlState.Normal)
        
        // Configure textfield
        let textFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let textFieldPaddingView = UIView(frame: textFieldPaddingViewFrame)
        searchTextField.leftView = textFieldPaddingView
        searchTextField.leftViewMode = .Always
        
        //Configure the title
        let title = UIImage(named: "title.png")
        navigationItem.titleView = UIImageView(image: title)
    }
    
    func segueToResultsViewController() {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ResultsViewController")! as! ResultsViewController
        
        //Send the text from the textfield to the ResultsViewController as the searchString.
        detailController.searchString = searchTextField.text
        
        //Replace the title with the search string
        detailController.navigationBarTitle = searchTextField.text
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    //Show a alert view controller with a title, a message and an "OK" button.
    func alertView(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

