//
//  ResultsCache.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 7/2/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class ResultsCache {
    
    private var inMemoryCache = NSCache()
    
    // MARK: - Retreiving images
    
    func imageWithIdentifier(identifier: String?) -> NSData? {
        
        let path = pathForIdentifier(identifier!)
        var data: NSData?
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? NSData {
            return image
        }
        
        // Next Try the hard drive
//        if let data = NSData(contentsOfFile: path) {
//            return data
//        }
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(image: NSData?, withIdentifier identifier: String) {
        let path = pathForIdentifier(identifier)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            //NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        // And in documents directory
        //image!.writeToFile(path, atomically: true)
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
}
