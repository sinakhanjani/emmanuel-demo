//
//  MyAddressViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/14/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class MyAddressViewController: UIViewController, TableViewCellDelegate,callbackDelegate {
    
    func back() {
        self.fetch()
    }

    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    var data = Addresses()
    var isParent: Navigate = .yes

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()
        backBarButtonAttribute(color: .white, name: "")
        self.navigationItem.title = "My Address"
        fetch()
        if isParent == .yes {
            self.stepView.alpha = 0.0
            self.topConstraint.constant = 0
        } else {
            self.stepView.alpha = 1.0
            self.topConstraint.constant = 64
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if self.data.count > 0 {
            
        } else {
            self.presentIOSAlertWarning(message: "Please add an address", completion: {})
        }
    }
    
    func fetch() {
        _ = Network<Addresses,Empty>.init(path: "api/customer/addresses", ignoreAuth: false).get { (res) in
            res.ifSuccess { (data) in
                self.data = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            // trash
            self.startIndicatorAnimate()
            let item = data[indexPath.item]
            let id = indexPath.item
            _ = Network<Empty,Empty>.init(path: "api/customer/addresses/\(id)/delete", ignoreAuth: false).post { (res) in
                DispatchQueue.main.async {
                       self.stopIndicatorAnimate()
                   }
                res.ifSuccess { (_) in
                    self.fetch()
                }
            }
        }
    }
    
    func button2Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            // edit
            let vc = AddressDetailTableViewController.create()
            let item = data[indexPath.item]
            vc.data = item
            vc.title = item.name
            vc.isNew = false
            vc.delegate = self
            vc.index = indexPath.item
            self.show(vc, sender: sender)
        }
    }
    
    func button3Tapped(sender: UIButton, cell: TableViewCell) {
        // selected address
        if let indexPath = self.tableView.indexPath(for: cell) {
            let vc = BasketViewController.create()
            vc.title = "Review"
            vc.isFinalStep = true
            vc.isParent = .no
            StepInfo.instance.address = self.data[indexPath.item]
            StepInfo.instance.addIndex = indexPath.item
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addAddressButtonTapped(_ sender: Any) {
        let vc = AddressDetailTableViewController.create()
        let nav = vc.addToNav()
        vc.title = "New Address"
        vc.isNew = true
        vc.delegate = self
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension MyAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.delegate = self
        let item = data[indexPath.item]
        cell.titleLabel1.text = item.name
        cell.titleLabel2.text = item.province
        cell.titleLabel3.text = item.city
        cell.titleLabel4.text = item.address
        cell.titleLabel5.text = item.zipcode
        cell.titleLabel6.text = item.phoneNumbers.mobilePhoneNumber
        cell.titleLabel7.text = item.phoneNumbers.phoneNumber
        if self.isParent == .no {
            cell.button3.isHidden = false
        } else {
            cell.button3.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension MyAddressViewController {

    func addBarButton() {
        if isParent == .yes {
        let leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.image = UIImage(named: "down_icon")
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        // Right
//        let rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(doneBarButtonTapped))
//        rightBarButtonItem.image = UIImage(named: "ic_toolbar_app_tik")
//        rightBarButtonItem.tintColor = .white
//        navigationItem.rightBarButtonItem = rightBarButtonItem
//        navigationController?.navigationItem.rightBarButtonItem = rightBarButtonItem
        // Left
    }
    
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
