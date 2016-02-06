//
//  BooksViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 06/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//


import UIKit

class BooksViewController: UITableViewController, DetailViewProtocol {
    let log = Log(id: "BooksViewController")
    
    var detailItem: MenuItem? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView(){
        /*
        filterButton = UIBarButtonItem(title: getTypeName(nil), style: .Plain, target: self, action: "showFilter:")
        self.navigationItem.rightBarButtonItem = filterButton
        
        fetcher.getNews(){result, error in
            self.news = result
            self.updateFilter()
            self.setFilter(nil)
        }
        */
    }

}
