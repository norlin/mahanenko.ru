//
//  NewsViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 15/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController, DetailViewProtocol {
    let log = Log(id: "NewsViewController")
    var detailItem: MenuItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView(){
        filterButton = UIBarButtonItem(title: getTypeName(nil), style: .Plain, target: self, action: "showFilter:")
        self.navigationItem.rightBarButtonItem = filterButton
        
        fetcher.getNews(){result, error in
            self.news = result
            self.updateFilter()
            self.setFilter(nil)
        }
    }
    
    let NEWS_ROW_HEIGHT: CGFloat = 40
    let NEWS_IMAGE_HEIGHT: CGFloat = 212
    
    let sizer = Sizer.sharedInstance()
    let api = SiteAPI.sharedInstance()
    let fetcher = NewsFetcher.sharedInstance()
    var news: [News]?
    
    var filterButton: UIBarButtonItem!
    var filterOptions: UIAlertController?
    var selectedNewsType: String!
    var selectedNews: [News]!


    override func viewDidLoad() {
        log.notice("viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        if let table = tableView as? RefreshTableView {
            if let refreshControl = table.refreshControl {
                refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            }
        }
        
        let imageHeight = sizer.getScale(CGSize(width: 326, height: 184), byWidth: tableView.frame.width).height
        tableView.rowHeight = NEWS_ROW_HEIGHT + imageHeight
        
//        self.configureView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.notice("prepareForSegue")
        if segue.identifier == "newsDetail" {
            let detailController = segue.destinationViewController as! NewsDetailController
            if let selectedRow = tableView.indexPathForSelectedRow {
                let row = selectedRow.section
                detailController.news = selectedNews[row]
            }
        }
    }
 
}

