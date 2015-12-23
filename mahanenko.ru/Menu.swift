//
//  Menu.swift
//  mahanenko.ru
//
//  Created by norlin on 23/12/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation

struct MenuSection {
    let title: String
    let items: [MenuItem]
}

struct MenuItem {
    let title: String
    let url: NSURL
    let icon: String?
}

class Menu {
    let list: [MenuSection]
    
    init(){
        list = [
            MenuSection(title: "Основное", items: [
                MenuItem(title: "Главная", url: NSURL(string: "/main")!, icon: nil)
            ]),
            MenuSection(title: "Пользователь", items: [
                MenuItem(title: "Войти", url: NSURL(string: "/login")!, icon: nil)
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

    class func sharedInstance() -> Menu {
        struct Singleton {
            static var sharedInstance = Menu()
        }
        
        return Singleton.sharedInstance
    }
}