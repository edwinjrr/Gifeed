//
//  SubCategoriesTableViewController.swift
//  Gifeed
//
//  Created by Edwin Rodriguez on 6/21/15.
//  Copyright (c) 2015 Edwin Rodriguez. All rights reserved.
//

import UIKit

class SubCategoriesTableViewController: UITableViewController {
    
    var subCategories = [SubCategory]()
    var navigationBarTitle: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Replace the title with the category selected.
        self.navigationItem.title = navigationBarTitle
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return subCategories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubCategoryCell", forIndexPath: indexPath) as! UITableViewCell

        let subCategory = subCategories[indexPath.row]
        
        cell.textLabel?.text = subCategory.name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("ResultsViewController")! as! ResultsViewController
        
        let subCategory = subCategories[indexPath.row]
        
        detailController.searchString = subCategory.name
        detailController.navigationBarTitle = subCategory.name
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
