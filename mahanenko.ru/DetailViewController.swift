//
//  DetailViewController.swift
//  mahanenko.ru
//
//  Created by norlin on 23/12/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, DetailViewProtocol {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var ready = false

    func configureView() -> Void {
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let build = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        detailDescriptionLabel.text = String(format: NSLocalizedString("Version: %@\nBuild: %@", comment: "Version: {version number}\nBuild: {Build number}"), version, build)
        detailDescriptionLabel.sizeToFit()
        
        ready = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
    }
}

