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

    var detailItem: MenuItem? {
        didSet {}
    }

    func configureView() -> Void {
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let build = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        detailDescriptionLabel.text = "Version: \(version)\nBuild: \(build)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

