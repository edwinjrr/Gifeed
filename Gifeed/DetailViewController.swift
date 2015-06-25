//
//  DetailViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var selectedGif: Gif!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
                
        let task = Giphy.sharedInstance().taskForImage(selectedGif.animatedImageURL) { imageData, error in
            
            if let data = imageData {
                let image = UIImage.animatedImageWithData(data)
                
                //update the cell later, on the main thread
                dispatch_async(dispatch_get_main_queue()) {
                    
                    //self.detailImageView.image = image
                    self.detailImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
