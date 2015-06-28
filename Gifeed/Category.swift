//
//  Category.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/28/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import Foundation

class Category {
    
    let name: String
    let subCategories: [SubCategory]
    
    init(name: String, subCategories: [SubCategory]) {
        self.name = name
        self.subCategories = subCategories
    }

}