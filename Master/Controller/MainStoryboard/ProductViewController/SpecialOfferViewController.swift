//
//  SpecialOfferViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/27/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class SpecialOfferViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var specialSwitch: UISwitch!
    
    var id: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        let touch = UITapGestureRecognizer(target: self, action: #selector(tapped))
        bgView.addGestureRecognizer(touch)
    }
    
    @objc func tapped() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonTapped() {
        guard let id = id else {
            return
        }
        notifySpecialOffer(enable: self.specialSwitch.isOn, productId: id)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchButtonTapped(_ sender: UISwitch) {

    }
    
    func notifySpecialOffer(enable: Bool,productId: Int) {
        var path:String
        if enable {
           path = "api/products/\(productId)/notify-me"
            _ = Network<Empty,Empty>.init(path: path, ignoreAuth: false).setBodyType(type: .jsonBody).addParameters(params: ["type":"on_special_offer"]).post { (_) in

            }
        } else {
           path = "api/products/\(productId)/notify-me"
            _ = Network<Empty,Empty>.init(path: path, ignoreAuth: false).setBodyType(type: .jsonBody).addParameters(params: ["off":"1","type":"on_special_offer"]).post { (_) in

            }
        }
    }
}
