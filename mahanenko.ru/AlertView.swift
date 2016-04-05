//
//  AlertView.swift
//  mahanenko.ru
//
//  Created by norlin on 25/02/16.
//  Copyright © 2016 norlin. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    var message: String?
    var tap: UIGestureRecognizer!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        view.bringSubviewToFront(dismissButton)
        view.bringSubviewToFront(label)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(AlertViewController.dismiss))
        self.view.addGestureRecognizer(tap)

        label.text = message
        label.sizeToFit()
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissButton(sender: AnyObject) {
        dismiss()
    }
    
    class func showAlert(sender: UIViewController, message: String) {
        if let alertViewController = sender.storyboard?.instantiateViewControllerWithIdentifier("AlertView") as? AlertViewController {
            alertViewController.message = message
            sender.presentViewController(alertViewController, animated: true, completion: nil)
        }
    }
}