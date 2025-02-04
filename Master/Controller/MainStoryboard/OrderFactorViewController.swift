//
//  OrderFactorViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/13/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class OrderFactorViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var invoices = Invoices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()
        navigationItem.title = "Order Factor"
        backBarButtonAttribute(color: .white, name: "")
        fetch()
    }
    
    func fetch() {
        Network<Invoices,Empty>.init(path: "api/customer/invoices", ignoreAuth: false).get { (res) in
            res.ifSuccess { (invoices) in
                self.invoices = invoices
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension OrderFactorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let item = self.invoices[indexPath.row]
        // label L5 pending
        //l1 date
        //l2 time
        //l3 code
        //l4 dollar
        //r1 roundedView pending
        cell.titleLabel3.text = "\(item.id)"
        cell.titleLabel1.text = item.time
        cell.titleLabel4.text = "\(item.totalPaid)"
        if item.status == 3 {
            cell.roundedView1.backgroundColor = #colorLiteral(red: 0, green: 0.6459867358, blue: 0.5796889663, alpha: 1)
            cell.titleLabel5.text = "Delivered"
        } else if item.status == 1 {
            cell.roundedView1.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            cell.titleLabel5.text = "Pending"
        } else if item.status == 2 {
            cell.roundedView1.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
            cell.titleLabel5.text = "Sending"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = invoices[indexPath.item]
        let vc = OrderDetailViewController.create()
        vc.title = "Oder Factor \(item.id)"
        vc.id = item.id
        vc.invoice = item
        show(vc, sender: true)
    }
}

extension OrderFactorViewController {
    func addBarButton() {
        // Right
//        let rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(doneBarButtonTapped))
//        rightBarButtonItem.image = UIImage(named: "ic_toolbar_app_tik")
//        rightBarButtonItem.tintColor = .white
//        navigationItem.rightBarButtonItem = rightBarButtonItem
//        navigationController?.navigationItem.rightBarButtonItem = rightBarButtonItem
        // Left
        let leftBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonTapped))
        leftBarButtonItem.image = UIImage(named: "down_icon")
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
