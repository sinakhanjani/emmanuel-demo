//
//  VerificationCodeViewController.swift
//  Master
//
//  Created by Sina khanjani on 12/2/1399 AP.
//  Copyright © 1399 AP iPersianDeveloper. All rights reserved.
//

import UIKit

class VerificationCodeViewController: UIViewController {
    
    struct VerifyModel: Codable {
        let email: String
        let code: String
    }

    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    let segue = "unwindVerificationToLoaderViewController"
    var email: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        verificationCodeTextField.keyboardType = .asciiCapableNumberPad
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        guard let code = self.verificationCodeTextField.text else {
            self.presentIOSAlertWarning(message: "Please enter the code", completion: {})
            return
        }
        let verifyModel = VerifyModel(email: email, code: code)
        _ = Network<Login,VerifyModel>.init(path: "api/verify", ignoreAuth: true).addModel(verifyModel).post { (response) in
            response.ifSuccess { (result) in
                print(result)
                // if success:
//                Authentication.auth.authenticationUser(token: "", oder_Token: orderToken, isLoggedIn: false)
//                self.performSegue(withIdentifier: segue, sender: nil)
                // if failed:
                self.presentIOSAlertWarning(message: "The code entered is a mistake", completion: {})
                }
            }
        }
    
}
