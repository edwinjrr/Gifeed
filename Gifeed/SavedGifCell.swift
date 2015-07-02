//
//  SavedGifCell.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/30/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class SavedGifCell: UICollectionViewCell {
    
    //Elements of the custom collection view cell:
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var deleteButton: UIButton!
    
//    var deleteButton: UIButton!
//    var deleteButtonIcon: UIImage!
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        // Create a UIButton
//        self.deleteButton = UIButton(frame: CGRect(x: frame.size.width/10, y: frame.size.width/16, width: frame.size.width/4, height: frame.size.width/4))
//        
//        // Set the UIButton's image property
//        self.deleteButtonIcon = UIImage(named: "delete_icon")
//        self.deleteButton.setImage(deleteButtonIcon, forState: UIControlState.Normal)
//        
//        // Add the UIButton to the collection view
//        contentView.addSubview(deleteButton)
//    }
}
