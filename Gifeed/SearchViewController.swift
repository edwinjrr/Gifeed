//
//  SearchViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dowloadTest(sender: AnyObject) {
        stringSearchTest()
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
                        println(results)
                    }
                }
            }
        })
    }
    
}

