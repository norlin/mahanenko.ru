//
//  DetailViewProtocol.swift
//  mahanenko.ru
//
//  Created by norlin on 15/01/16.
//  Copyright © 2016 norlin. All rights reserved.
//

protocol DetailViewProtocol {
    var detailItem: MenuItem? { get set }
    
    func configureView() -> Void
}