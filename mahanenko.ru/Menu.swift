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
    let controller: String
    let icon: String?
    var instance: DetailViewProtocol?
    
    init(title: String, controller: String, icon: String?, instance: DetailViewProtocol?){
        self.title = title
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
    let defaultIndex = NSIndexPath(forRow: 2, inSection: 0)
    
    init(){
        list = [
            MenuSection(title: NSLocalizedString("", comment: ""), items: [
                MenuItem(
                    title: NSLocalizedString("menu.item.about", comment: "menu item – About author"),
                    controller: "DetailViewController",
                    icon: nil,
                    instance: nil),
                MenuItem(
                    title: NSLocalizedString("menu.item.news", comment: "menu item – News"),
                    controller: "NewsViewController",
                    icon: nil,
                    instance: nil),
                MenuItem(
                    title: NSLocalizedString("menu.item.books", comment: "menu item – Books"),
                    controller: "BooksViewController",
                    icon: nil,
                    instance: nil)
            ]),
            /*MenuSection(title: NSLocalizedString("menu.section.user", comment: "menu section – User"), items: [
                MenuItem(
                    title: NSLocalizedString("menu.item.login", comment: "menu item – Login"),
                    controller: "DetailViewController",
                    icon: nil,
                    instance: nil)
            ]),*/
            MenuSection(title: NSLocalizedString("", comment: ""), items: [
                MenuItem(
                    title: NSLocalizedString("menu.item.info", comment: "menu item – Info"),
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