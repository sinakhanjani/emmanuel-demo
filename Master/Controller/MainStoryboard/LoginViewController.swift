//
//  LoginViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/10/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.autocorrectionType = .yes
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        if #available(iOS 12.0, *) {
//            passwordTextField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        self.navigationItem.title = "Login"
        addBarButton()
        view.dismissedKeyboardByTouch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        self.emailTextField.becomeFirstResponder()
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        present(RegisterViewController.create().addToNav(), animated: true, completion: nil)
    }
}

extension LoginViewController {
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
        guard !self.emailTextField.text!.isEmpty && !self.pTextField.text!.isEmpty else {
            self.presentIOSAlertWarning(message: "Failed. Please check your inputs", completion: {})
            return
        }
        let loginSend = LoginSend(email: self.emailTextField.text!, password: self.pTextField.text!, push_token: (UIApplication.shared.delegate as! AppDelegate).fcmToken)
        view.endEditing(true)
        self.startIndicatorAnimate()
        _ = Network<Login,LoginSend>.init(path: "api/login", ignoreAuth: true).addModel(loginSend).post { (response) in
            response.ifSuccess { (login) in
                print(login)
                var message = ""
                DispatchQueue.main.async {
                    if let msg = login.message {
                        message = msg
                        self.presentIOSAlertWarning(message: message, completion: {})
                    }
                    if let error = login.errors {
                        if let email = error.email {
                            message = email[0]
                        }
                        if let password = error.password {
                            message = password[0]
                        }
                        self.presentIOSAlertWarning(message: message, completion: {})
                    }
                    if let token = login.token, let orderToken = login.orderToken {
                        Authentication.auth.authenticationUser(token: token, oder_Token: orderToken, isLoggedIn: true)
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.stopIndicatorAnimate()
                }
            }
        }
    }
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
