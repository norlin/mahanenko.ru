//
//  MenuViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 23/12/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    let menu = Menu.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        tableView.backgroundView?.backgroundColor = UIColor(netHex: 0xFBFBFB)
        
        self.performSegueWithIdentifier("showDetail", sender: self)
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            var index: NSIndexPath!
            if let _ = sender as? MenuViewController {
                index = menu.defaultIndex
            } else if let indexPath = self.tableView.indexPathForSelectedRow {
                index = indexPath
            }
            if index != nil {
                let item = menu.getItem(index)
                var controller: DetailViewProtocol?
                if (item.instance != nil) {
                    controller = item.instance!
                } else if let instance = self.storyboard?.instantiateViewControllerWithIdentifier(item.controller) as? DetailViewProtocol {
                    controller = instance
                    controller!.detailItem = item
                    menu.setInstance(index, instance: controller!)
                }
                if controller != nil {
                    let navigation = segue.destinationViewController as! UINavigationController
                    navigation.setViewControllers([controller as! UIViewController], animated: false)
                    
                    if let destController = navigation.topViewController {
                        destController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                        destController.navigationItem.leftItemsSupplementBackButton = true
                    }
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menu.list.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let menuSection = menu.getSection(section)
        return menuSection.title
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.list[section].items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let item = menu.getItem(indexPath)
        cell.textLabel!.text = item.title
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

}

