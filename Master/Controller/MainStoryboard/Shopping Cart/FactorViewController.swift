//
//  FactorViewController.swift
//  Master
//
//  Created by Sina khanjani on 2/11/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class FactorViewController: UIViewController {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var totalPayLabel: UILabel!
    @IBOutlet weak var deliveryConstLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    var code = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.dismissedKeyboardByTouch()
        if let add = StepInfo.instance.address {
            var details = ""
            details += add.name + "\n"
            details += add.address + "\n"
            details += add.zipcode + "\n"
            details += add.phoneNumbers.mobilePhoneNumber + "\n"
            details += add.phoneNumbers.phoneNumber + "\n"
            self.infoLabel.text = details
            self.deliveryConstLabel.text = "\(add.deliveryCost) £"
//            let total = (StepInfo.instance.Baskets.map { Double($0.price ?? 0) }).reduce(0.0) { (total, num) -> Double in
//                return total + num
//            }
            let totalDiscount = (StepInfo.instance.Baskets.map { Double($0.discount ?? 0) }).reduce(0.0) { (total, num) -> Double in
                return total + num
            }
//            let totalPay = (total - totalDiscount) + Double(add.deliveryCost)
            let totalPay = StepInfo.instance.totalPriceServer + Double(add.deliveryCost)
            self.totalPriceLabel.text = "\(StepInfo.instance.totalPriceServer ?? 0.0)) £"
            self.discountLabel.text = "\(Double(totalDiscount)) £"
            self.totalPayLabel.text = "\(totalPay) £"
        }
    }

    @IBAction func discountButtonTapped(_ sender: Any) {
        self.startIndicatorAnimate()
        _ = Network<Defa,Empty>.init(path: "api/helper/check-discount-code/\(codeTextField.text!)", ignoreAuth: false).post { (res) in
            DispatchQueue.main.async {
                self.stopIndicatorAnimate()
            }
            res.ifSuccess { (data) in
                DispatchQueue.main.async {
                    if data.status == 0 {
                        self.errLabel.text = data.message
                    } else if data.status == 1 {
                        //success
                        self.code = self.codeTextField.text!
                        self.errLabel.text = data.message
                    }
                }
            }
        }
    }
    
    @IBAction func bankButtonTapped(_ sender: Any) {
//        let send = Network<Defa,Empty>.init(path: "orders/final", ignoreAuth: true).withGet().setBodyType(type: .jsonBody).addParameters(params: ["ctoken":Authentication.auth.orderToken,"address":"\( StepInfo.instance.addIndex!)","method":"1"])
//        print(["ctoken":Authentication.auth.orderToken,"address":"\( StepInfo.instance.addIndex!)","method":"1"])
//        if !self.code.isEmpty {
//            _ = send.addParameter(key: "discount_code", value: code)
//        }
//        _ = send.post { (res) in
//            DispatchQueue.main.async {
//                self.stopIndicatorAnimate()
//
//            }
//            res.ifSuccess { (data) in
//                //
//            }
//        }
        let url = URL.init(string: "https://sweetemmanuel.co.uk/orders/final?")?.withQuries(["ctoken":Authentication.auth.orderToken,"address":"\(StepInfo.instance.addIndex!)","method":"1"])
        print(["ctoken":Authentication.auth.orderToken,"address":"\( StepInfo.instance.addIndex!)","method":"1"])
        if !self.code.isEmpty {
            let finalURL = url?.withQuries(["discount_code":code])
            openURL(url: finalURL)
            navigationController?.popToRootViewController(animated: true)
            return
        } else {
            openURL(url: url)
            navigationController?.popToRootViewController(animated: true)
            return
        }
    }
    
    func openURL(url:URL?) {
        if let url = url {
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
