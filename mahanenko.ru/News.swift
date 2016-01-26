//
//  News.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

struct News {
    let description: String
    let text: String
    let images: [UIImage]?
    let date: String
    let type: NewsFilterType?
    
    init(text: String, images: [UIImage]?, date: String, type: NewsFilterType?) {
        self.description = text
        self.text = text
        self.images = images
        self.date = date
        self.type = type
    }
    
    init(description: String, text: String, images: [UIImage]? = nil, date: String, type: NewsFilterType? = nil) {
        self.description = description
        self.text = text
        self.images = images
        self.date = date
        self.type = type
    }
}
    
enum NewsFilterType {
    case All
    case Shaman
    case Galaktiona
}

class NewsFetcher {

    let dummyNews = [
        News(
            text: "В марте выходит переиздание 1-й книги Пути Шамана в серии ЛитRPG. Теперь вы сможете собрать фул сет в одном стиле!\n\nP.S.: Встречаем новую обложку! Как Вам?",
            images: [
                UIImage(named: "NewsDummy")!,
                UIImage(named: "NewsDummy2")!
            ],
            date: "15 Янв в 16:52",
            type: .Shaman
        ),
        News(
            text: "Галактиона ололо!",
            images: [
                UIImage(named: "NewsDummy")!,
                UIImage(named: "NewsDummy2")!
            ],
            date: "14 Янв в 13:52",
            type: .Galaktiona
        ),
        News(
            description: "Небольшой соц.опрос :) Какую книгу вы сейчас хотели бы читать?\nСразу скажу, все варианты будут идти без подписки с полной выкладкой текста на моем сайте и самиздате.",
            text: "Небольшой соц.опрос :) Какую книгу вы сейчас хотели бы читать?\nСразу скажу, все варианты будут идти без подписки с полной выкладкой текста на моем сайте и самиздате.\n\nВАРИАНТЫ:\n\n1. Галактиона 2\nПродолжение приключений Хирурга в игровом мире Галактиона. Получит он чек, или нет? Сможет остановить нашествие врага?\n\n2. Темный Паладин (он же Судья) \nЛитРПГ в реальном мире. Попытка показать, что все наши сказки, страхи неизведанного и прочие вещи — отголоски второго мира, скрытого от обычных людей. Местами книга будет не совсем доброй.\n\n3. Лиара Арнейская\nКлассическое фэнтези. Приключения рыжеволосой стервы (в прямом смысле) в магическом мире. Никаких попаданцев и прочих вещей. Просто приключения.\n\n4. Вторжение\nПродолжение Барлионы с момента открытия нового материка. Прокачка с нуля нового героя в мире Барлионы. Битва с демонами и прочими тварями. Эпизодические встречи с героями Пути Шамана.",
            date: "16 Янв в 15:45"
        )
    ]

    func getNews() -> [News] {
        return dummyNews
    }

    class func sharedInstance() -> NewsFetcher {
        struct Singleton {
            static var sharedInstance = NewsFetcher()
        }
        
        return Singleton.sharedInstance
    }
}