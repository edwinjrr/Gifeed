//
//  TrendingGifCell.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/22/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class TrendingGifCell: UICollectionViewCell {
    
    //Elements of the custom collection view cell:
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // The property uses a property observer. Any time its
    // value is set it canceles the previous NSURLSessionTask
    
    var imageName: String = ""
    
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}