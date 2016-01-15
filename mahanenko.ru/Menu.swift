//
//  Menu.swift
//  mahanenko.ru
//
//  Created by norlin on 23/12/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

struct MenuSection {
    let title: String
    var items: [MenuItem]
}

struct MenuItem {
    let title: String
    let url: NSURL
    let controller: String
    let icon: String?
    var instance: DetailViewProtocol?
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

    class func sharedInstance() -> Menu {
        struct Singleton {
            static var sharedInstance = Menu()
        }
        
        return Singleton.sharedInstance
    }
}