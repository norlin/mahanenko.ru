//
//  Log.swift
//  mahanenko.ru
//
//  Created by norlin on 06/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import Foundation

class Log {
    enum Level {
        case Critical
        case Error
        case Warning
        case Notice
        case Debug
    }
    
    let levelWeight:[Level: Int] = [
        .Critical: 4,
        .Error: 3,
        .Warning: 2,
        .Notice: 1,
        .Debug: 0
    ]
    
    let levelIcon:[Level: String] = [
        .Critical: "‼️",
        .Error: "❗️",
        .Warning: "❕",
        .Notice: "💡",
        .Debug: "❔"
    ]
    
    let verbose = Level.Warning
    let id:String
    
    init(id: String){
        self.id = id
    }
    
    func debug(msg: String){ self.log(.Debug, msg: msg) }
    func notice(msg: String){ self.log(.Notice, msg: msg) }
    func warning(msg: String){ self.log(.Warning, msg: msg) }
    func error(msg: String){ self.log(.Error, msg: msg) }
    func critical(msg: String){ self.log(.Critical, msg: msg) }
    
    private func log(level: Level, msg: AnyObject){
        let weight = levelWeight[level]
        let verbose = levelWeight[self.verbose]

        guard weight >= verbose else {
            return
        }
        
        let icon = levelIcon[level]!
        
        print("\(icon)\(id): \(msg)")
    }

}