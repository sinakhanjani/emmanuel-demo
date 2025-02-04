//
//  SupportViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/13/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SupportViewController: UITableViewController {
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var messageTextField: SkyFloatingLabelTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()
        self.navigationItem.title = "Support"
        // Do any additional setup after loading the view.
    }
}

extension SupportViewController {
    func addBarButton() {
         // Right
        let rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(doneBarButtonTapped))
        rightBarButtonItem.image = UIImage(named: "ic_toolbar_app_tik")
        rightBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationItem.rightBarButtonItem = rightBarButtonItem
         // Left
        let leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.image = UIImage(named: "down_icon")
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        guard !self.emailTextField.text!.isEmpty && !self.messageTextField.text!.isEmpty else {
            self.presentIOSAlertWarning(message: "The text field is required.", completion: {})
            return
        }
        _ = Network<Empty,Empty>.init(path: "api/contact", ignoreAuth: false).setBodyType(type: .formdata).addAllParameters(["contact":self.emailTextField.text!,"text":self.messageTextField.text!]).post { (res) in
            res.ifSuccess { (_) in
                DispatchQueue.main.async {
                    self.presentIOSAlertWarning(message: "Message sent successfully", completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
    }
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
