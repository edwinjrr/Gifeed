//
//  Giphy.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class Giphy {
    
    /* Shared session */
    var session: NSURLSession
    
    init() {
        session = NSURLSession.sharedSession()
    }
    
    let apiKey = "dc6zaTOxFJmzC" //Public API for development
    
    func getGifFromGiphyBySearch(searchString: String, completionHandler: (results: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        let methodParameters = [
            "q": searchString,
            "api_key": apiKey,
            "limit": "50"
        ]
        
        let session = NSURLSession.sharedSession()
        let urlString = "http://api.giphy.com/v1/gifs/search" + escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
        
            if let error = downloadError {
                completionHandler(results: nil, error: downloadError)
            }
            else {
                
                /* Parsing the data */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                /* Using the data! */
                if let imagesArray = parsedResult.valueForKey("data") as? [[String:AnyObject]] {
                    
                    completionHandler(results: imagesArray, error: nil)
                    
                } else {
                    
                    completionHandler(results: nil, error: NSError(domain: "getGifFromGiphyBySearch parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getGifFromGiphyBySearch"]))
                }
            }
        }
        task.resume()
    }
    
    func getTrendingGifFromGiphy(completionHandler: (results: [[String:AnyObject]]?, error: NSError?) -> Void) {
        
        let methodParameters = [
            "api_key": apiKey,
        ]
        
        let session = NSURLSession.sharedSession()
        let urlString = "http://api.giphy.com/v1/gifs/trending" + escapedParameters(methodParameters)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(results: nil, error: downloadError)
            }
            else {
                
                /* Parsing the data */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                /* Using the data! */
                if let imagesArray = parsedResult.valueForKey("data") as? [[String:AnyObject]] {
                    
                    completionHandler(results: imagesArray, error: nil)
                    
                } else {
                    
                    completionHandler(results: nil, error: NSError(domain: "getTrendingGifFromGiphy parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getTrendingGifFromGiphy"]))
                }
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - All purpose task method for images
    
    func taskForImage(filePath: String, completionHandler: (imageData: NSData?, error: NSError?) ->  Void) -> NSURLSessionTask {
        
        let url = NSURL(string: filePath)!
        
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(imageData: nil, error: downloadError)
            } else {
                completionHandler(imageData: data, error: nil)
            }
        }
        
        task.resume()
        
        return task
    }

    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    // MARK: - Core Data Convenience
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> Giphy {
        
        struct Singleton {
            static var sharedInstance = Giphy()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: - Shared Image Cache and Results Cache
    
    struct Caches {
        static let imageCache = ImageCache()
        static let resultsCache = ResultsCache()
    }
}