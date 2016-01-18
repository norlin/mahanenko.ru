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
    
    var cells = 1
    
    let news = [
        News(text: "В марте выходит переиздание 1-й книги Пути Шамана в серии ЛитRPG. Теперь вы сможете собрать фул сет в одном стиле!\n\nP.S.: Встречаем новую обложку! Как Вам?", images: [
                UIImage(named: "NewsDummy")!,
                UIImage(named: "NewsDummy2")!
            ], date: "15 Янв в 16:52")
        ]

    func configureView() {
        // Update the user interface for the detail item.
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.refreshControl = refreshControl
    }
    
    func refresh(sender: AnyObject) {
        cells += 1
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newsDetail" {
            let detailController = segue.destinationViewController as! NewsDetailController
            if let selectedRow = tableView.indexPathForSelectedRow {
                detailController.news = news[selectedRow.row]
            }
        }
    }
}

// UITableViewDataSource
extension NewsViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCellView
        
        let news = self.news[indexPath.row]
        cell.configure(news)
        
        return cell
    }
}

// UITableViewDelegate
extension NewsViewController {

    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        super.scrollViewDidScroll(scrollView)
        let scroll = scrollView.contentOffset.y + scrollView.frame.size.height
        let height = max(scrollView.contentSize.height, scrollView.frame.height)
        print("\(scroll) > \(height) == \(scroll > height)")
    }

}