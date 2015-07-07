//
//  CategoriesTableViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    let categories = Categories()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return categories.categoriesArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! UITableViewCell
        
        let category = categories.categoriesArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let subCategoriesController = self.storyboard!.instantiateViewControllerWithIdentifier("SubCategoriesTableViewController")! as! SubCategoriesTableViewController
        
        let category = categories.categoriesArray[indexPath.row]
        
        subCategoriesController.subCategories = category.subCategories
        subCategoriesController.navigationBarTitle = category.name
        
        self.navigationController!.pushViewController(subCategoriesController, animated: true)
    }
}
