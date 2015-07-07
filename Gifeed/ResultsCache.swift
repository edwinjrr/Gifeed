//
//  ResultsCache.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 7/2/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

//This class only stores images inside the cache for the results in ResultsViewController and the SearchViewController.

class ResultsCache {
    
    private var inMemoryCache = NSCache()
    
    // MARK: - Retreiving images
    
    func imageWithIdentifier(identifier: String?) -> NSData? {
        
        let path = pathForIdentifier(identifier!)
        var data: NSData?
        
        // Try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? NSData {
            return image
        }
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(image: NSData?, withIdentifier identifier: String) {
        let path = pathForIdentifier(identifier)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
}
