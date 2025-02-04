
//
//  SideTableViewController.swift
//  Master
//
//  Created by Sina khanjani on 6/21/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit

class SideTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = DataManager.shared.profile?.name {
            self.nameLabel.text = name
        } else {
            self.nameLabel.text = ""
        }
        NotificationCenter.default.addObserver(self, selector: #selector(notif), name: Constant.Notify.basketCount, object: nil)
    }
    
    @objc func notif() {
        self.countLabel.text = "\(DataManager.shared.basketCount ?? 0)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Authentication.auth.isLoggedIn {
            if let no = DataManager.shared.basketCount {
                self.countLabel.text = "\(no)"
            } else {
                self.countLabel.text = "0"
            }
        } else {
            self.countLabel.text = "0"
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item
        if index >= 6 {
            switch index {
            case 6:
                self.present(AboutViewController.create().addToNav(), animated: true, completion: nil)
            case 7:
                self.present(SupportViewController.create().addToNav(), animated: true, completion: nil)
                case 8:
                    present(FAQViewController.create().addToNav(), animated: true, completion: nil)
            case 9:
                self.presentIOSAlertWarningWithTwoButton(message: "Are you sure want exit from account ?", buttonOneTitle: "Yes", buttonTwoTitle: "No", handlerButtonOne: {
                    Authentication.auth.logOutAuth()
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }, handlerButtonTwo: {})
            default:
                break
            }
        }
        if index < 6 {
            let isLogin = Authentication.auth.isLoggedIn
            if !isLogin {
                present(LoginViewController.create().addToNav(), animated: true, completion: nil)
            } else {
                switch index {
                case 1:
                    present(ProfileTableViewController.create().addToNav(), animated: true, completion: nil)
                case 2:
                    let vc = BasketViewController.create().addToNav()
                    self.present(vc, animated: true, completion: nil)
                case 3:
                    present(OrderFactorViewController.create().addToNav(), animated: true, completion: nil)
                case 4:
                    present(FavoriteViewController.create().addToNav(), animated: true, completion: nil)
                case 5:
                    present(MyAddressViewController.create().addToNav(), animated: true, completion: nil)
                default:
                    break
                }
            }
        }
    }

}

