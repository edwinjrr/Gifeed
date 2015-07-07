//
//  Gif.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit
import CoreData

@objc(Gif)

class Gif: NSManagedObject {
    
    @NSManaged var imageID: String
    @NSManaged var animatedImageURL: String
    @NSManaged var stillImageURL: String
    @NSManaged var imageSize: String
    @NSManaged var imageSource: String
    @NSManaged var imageBitlyURL: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(dictionary: [String:AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Gif", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        imageID = dictionary["id"] as! String
        imageSource = dictionary["source"] as! String
        imageBitlyURL = dictionary["bitly_url"] as! String
        
        //This properties help to navigate through the JSON objects from the Giphy response.
        let images = dictionary["images"] as! [String:AnyObject]
        let original = images["original"] as! [String:AnyObject]
        let originalStill = images["original_still"] as! [String:AnyObject]
        
        animatedImageURL = original["url"] as! String
        stillImageURL = originalStill["url"] as! String
        imageSize = original["size"] as! String
    }
    
    // Helper: Given an array of dictionaries, convert them to an array of GIF objects
    static func gifsFromResults(results: [[String : AnyObject]], insertIntoManagedObjectContext context: NSManagedObjectContext) -> [Gif] {
        var gifs = [Gif]()
        
        for result in results {
            gifs.append(Gif(dictionary: result, insertIntoManagedObjectContext: context))
        }
        
        return gifs
    }
    
    //These properties will get and save the images of the photos from/to the documents directory.
    var photoImage: NSData? {
        
        get {
            return Giphy.Caches.imageCache.imageWithIdentifier(imageID)
        }
        
        set {
            Giphy.Caches.imageCache.storeImage(newValue, withIdentifier: imageID)
        }
    }
    
    var stillPhotoImage: NSData? {
        
        get {
            return Giphy.Caches.imageCache.imageWithIdentifier("\(imageID)_still")
        }
        
        set {
            Giphy.Caches.imageCache.storeImage(newValue, withIdentifier: "\(imageID)_still")
        }
    }
    
    var cacheStillPhotoImage: NSData? {
        
        get {
            return Giphy.Caches.resultsCache.imageWithIdentifier("\(imageID)_still")
        }
        
        set {
            Giphy.Caches.resultsCache.storeImage(newValue, withIdentifier: "\(imageID)_still")
        }
    }
}
