//
//  News.swift
//  mahanenko.ru
//
//  Created by norlin on 18/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class News {
    let description: NSAttributedString
    let text: NSAttributedString
    var images: [UIImage]
    let imageUrls: [String]?
    let date: String
    let type: NewsFilterType?
    var hasImages: Bool {
        return imageUrls != nil
    }
    
    let font = UIFont(name: "Helvetica Neue", size: 16)!
    
    init(text: NSAttributedString, images: [String]?, date: String, type: NewsFilterType?) {
        self.description = text.attributedStringWith(font)
        self.text = self.description
        self.imageUrls = images
        self.images = []
        self.date = date
        self.type = type
    }
    
    init(description: NSAttributedString, text: NSAttributedString, images: [String]? = nil, date: String, type: NewsFilterType? = nil) {
        self.description = description.attributedStringWith(font)
        self.text = text.attributedStringWith(font)
        self.imageUrls = images
        self.images = []
        self.date = date
        self.type = type
    }
    
    func fetchImage(index: Int, completion: (image: UIImage)->Void){
        guard let urls = imageUrls else {
            return
        }
        
        if index >= urls.count {
            return
        }
        let url = urls[index]
        let imageURL = NSURL(string: url)
        // TODO: move to bg thread
        if let imageData = NSData(contentsOfURL: imageURL!) {
            if let image = UIImage(data: imageData) {
                self.images.append(image)
                completion(image: image)
            }
        }
    }
}
    
enum NewsFilterType {
    case All
    case Shaman
    case Galaktiona
}

class NewsFetcher {
    var api = SiteAPI.sharedInstance()

    /*let dummyNews = [
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
            text: "Галактиона ололо! http://mahanenko.ru/ru/article/vyhod-galaktiony",
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
    ]*/

    func getNews(completion: (result: [News]?, error: NSError?) -> Void) {
        api.getNewsList(completion)
    }

    class func sharedInstance() -> NewsFetcher {
        struct Singleton {
            static var sharedInstance = NewsFetcher()
        }
        
        return Singleton.sharedInstance
    }
}