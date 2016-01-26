//
//  NewsViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 15/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, DetailViewProtocol {
    var detailItem: MenuItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
    }
    
    let fetcher = NewsFetcher.sharedInstance()
    var news: [News]?
    
    var filterButton: UIBarButtonItem!
    var filterOptions: UIAlertController?
    var selectedNewsType: NewsFilterType!
    var selectedNews: [News]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        if let table = tableView as? RefreshTableView {
            if let refreshControl = table.refreshControl {
                refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            }
        }
        
        filterButton = UIBarButtonItem(title: "All", style: .Plain, target: self, action: "showFilter:")
        self.navigationItem.rightBarButtonItem = filterButton
        
        news = fetcher.getNews()
        updateFilter()
        setFilter(.All)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newsDetail" {
            let detailController = segue.destinationViewController as! NewsDetailController
            if let selectedRow = tableView.indexPathForSelectedRow {
                let row = selectedRow.section
                detailController.news = selectedNews[row]
            }
        }
    }
 
}

