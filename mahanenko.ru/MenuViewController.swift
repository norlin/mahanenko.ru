//
//  MenuViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 23/12/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class MenuViewController: UITableViewController {
    let log = Log(id: "MenuViewController")

    var detailViewController: DetailViewController? = nil
    let menu = Menu.sharedInstance()
    let api = SiteAPI.sharedInstance()

    override func viewDidLoad() {
        log.notice("viewDidLoad")
        super.viewDidLoad()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        tableView.backgroundView?.backgroundColor = UIColor(netHex: 0xFBFBFB)

        updateLangControl()

        //self.performSegueWithIdentifier("showDetail", sender: self)
    }

    override func viewWillAppear(animated: Bool) {
        log.notice("viewWillAppear")
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        log.notice("didReceiveMemoryWarning")
        super.didReceiveMemoryWarning()
    }
    
    func updateLangControl(){
        log.notice("updateLangControl")
        let langSelect = UIBarButtonItem(title: api.oppositeLangName, style: .Plain, target: self, action: "switchLang:")
        self.navigationItem.rightBarButtonItem = langSelect
    }
    
    func switchLang(sender: AnyObject?){
        log.notice("switchLang")
        api.switchLang()
        updateLangControl()
        menu.clearAll()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        log.notice("prepareForSegue")
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
                    (controller as! UIViewController).title = item.title
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

