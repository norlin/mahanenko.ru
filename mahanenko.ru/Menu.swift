//
//  Menu.swift
//  mahanenko.ru
//
//  Created by norlin on 23/12/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class MenuSection {
    let title: String
    var items: [MenuItem]
    
    init(title: String, items: [MenuItem]){
        self.title = title
        self.items = items
    }
    
    func clearInstances(){
        for item in items {
            item.clearInstance()
        }
    }
}

class MenuItem {
    let title: String
    let url: NSURL
    let controller: String
    let icon: String?
    var instance: DetailViewProtocol?
    
    init(title: String, url: NSURL, controller: String, icon: String?, instance: DetailViewProtocol?){
        self.title = title
        self.url = url
        self.controller = controller
        self.icon = icon
        self.instance = instance
    }
    
    func clearInstance(){
        instance = nil
    }
}

class Menu {
    var list: [MenuSection]
    let defaultIndex = NSIndexPath(forRow: 1, inSection: 0)
    
    init(){
        list = [
            MenuSection(title: NSLocalizedString("menu.section.main", comment: "menu section – Main"), items: [
                MenuItem(
                    title: NSLocalizedString("menu.item.about", comment: "menu item – About author"),
                    url: NSURL(string: "/about")!,
                    controller: "DetailViewController",
                    icon: nil,
                    instance: nil),
                MenuItem(
                    title: NSLocalizedString("menu.item.news", comment: "menu item – News"),
                    url: NSURL(string: "/news")!,
                    controller: "NewsViewController",
                    icon: nil,
                    instance: nil)
            ]),
            MenuSection(title: NSLocalizedString("menu.section.user", comment: "menu section – User"), items: [
                MenuItem(
                    title: NSLocalizedString("menu.item.login", comment: "menu item – Login"),
                    url: NSURL(string: "/login")!,
                    controller: "DetailViewController",
                    icon: nil,
                    instance: nil)
            ]),
        ]
        // TODO: read list from the file
    }
    
    func getSection(section: Int) -> MenuSection {
        return self.list[section]
    }
    
    func getSection(indexPath: NSIndexPath) -> MenuSection {
        return self.getSection(indexPath.section)
    }
    
    func getItem(indexPath: NSIndexPath) -> MenuItem {
        let section = self.getSection(indexPath)
        return section.items[indexPath.row]
    }
    
    func setInstance(indexPath: NSIndexPath, instance: DetailViewProtocol) {
        list[indexPath.section].items[indexPath.row].instance = instance
    }
    
    func clearAll(){
        for section in list {
            section.clearInstances()
        }
    }

    class func sharedInstance() -> Menu {
        struct Singleton {
            static var sharedInstance = Menu()
        }
        
        return Singleton.sharedInstance
    }
}