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
    
    let news = [
        News(text: "В марте выходит переиздание 1-й книги Пути Шамана в серии ЛитRPG. Теперь вы сможете собрать фул сет в одном стиле!\n\nP.S.: Встречаем новую обложку! Как Вам?",
            images: [
                UIImage(named: "NewsDummy")!,
                UIImage(named: "NewsDummy2")!
            ],
            date: "15 Янв в 16:52",
            type: .Shaman),
            
        News(text: "Галактиона ололо!",
            images: [
                UIImage(named: "NewsDummy")!,
                UIImage(named: "NewsDummy2")!
            ],
            date: "14 Янв в 13:52",
            type: .Galaktiona)
        ]
    
    var filterButton: UIBarButtonItem!
    var filterOptions: UIAlertController?
    var selectedNewsType: NewsFilterType = .All
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
        
        updateFilter()
        selectedNews = news
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
    
    func refresh(sender: AnyObject) {
        guard let refreshControl = sender as? UIRefreshControl else {
            return
        }
        tableView.reloadData()
        
        updateFilter()
        
        refreshControl.endRefreshing()
    }
 
}

// UITableViewDataSource
extension NewsViewController {

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return selectedNews.count + 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.alpha = 0
        return view
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section < selectedNews.count {
            return tableView.rowHeight
        }
        
        return 41
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section < selectedNews.count {
            let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCellView
            
            let news = selectedNews[indexPath.section]
            cell.configure(news, index: indexPath.section)
            
            return cell
        }
        
        return tableView.dequeueReusableCellWithIdentifier("MoreCell", forIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section < selectedNews.count {
            return
        }
        
//        cells += 5
        tableView.reloadData()
    }
}

// News Filter
extension NewsViewController {
    
    func getTypeName(type: NewsFilterType) -> String {
        switch (type) {
            case .All: return "All"
            case .Shaman: return "Shaman"
            case .Galaktiona: return "Galaktiona"
        }
    }
    
    func updateFilter(){
        if filterOptions != nil {
            filterOptions?.removeFromParentViewController()
            filterOptions = nil
        }
        
        filterOptions = UIAlertController(title: "Select news category", message: "", preferredStyle: .ActionSheet)
        
        let types:[NewsFilterType] = [.All, .Shaman, .Galaktiona]
        
        for type in types {
            let title = getTypeName(type)
            let handler = createHandler(type)
            filterOptions!.addAction(UIAlertAction(title: title, style: .Default, handler: handler))
        }
        
        filterOptions!.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: dismissFilter))
        
    }
    
    func setFilter(type: NewsFilterType) {
        selectedNewsType = type
        let title = getTypeName(type)
        self.filterButton.title = title
        
        if type == .All {
            selectedNews = news
        } else {
            selectedNews = news.filter { return $0.type == type }
        }
        
        self.tableView.reloadData()
    }
    
    func createHandler(type: NewsFilterType) -> ((action: UIAlertAction) -> Void) {
        return {(action: UIAlertAction) in
            self.setFilter(type)
            self.dismissFilter(action)
        }
    }
    
    func showFilter(sender: AnyObject) {
        guard let filter = filterOptions else {
            return
        }
        
        self.presentViewController(filter, animated: true, completion: nil)
    }
    
    func dismissFilter(action: UIAlertAction) {
        guard let filter = filterOptions else {
            return
        }
        
        filter.dismissViewControllerAnimated(true, completion: nil)
    }
}