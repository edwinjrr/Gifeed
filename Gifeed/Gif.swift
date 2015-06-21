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
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(dictionary: [String:AnyObject], insertIntoManagedObjectContext context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Gif", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        imageID = dictionary["id"] as! String
        animatedImageURL = dictionary["url"] as! String //image >> original >> url
        stillImageURL = dictionary["url"] as! String //image >> original_still >> url
        imageSize = dictionary["size"] as! String //image >> original >> size
    }
}
