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
 
}

