//
//  OrderDetailViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/13/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deliveryCostLabel: UILabel!
    @IBOutlet weak var paidPriceLabel: UILabel!
    @IBOutlet weak var discountCodeLabel: UILabel!
    @IBOutlet weak var discountCodeStackView: UIStackView!
    
    var id: Int?
    var data = InvoiceDetailElements()
    var invoice: InvoiceElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        self.discountCodeStackView.alpha = 0.0
        if let invoice = invoice {
            if let code = invoice.payingInfo.discountCode  {
                if !code.isEmpty {
                    self.discountCodeStackView.alpha = 1.0
                    self.discountCodeLabel.text = invoice.payingInfo.discountCode

                }
            }
            self.deliveryCostLabel.text = "\(invoice.informations.deliveryCost)"
            self.paidPriceLabel.text = "\(invoice.totalPaid)"
        }
        tableView.tableFooterView = UIView()
    }
    
    func fetch() {
        guard let id = self.id else { return }
        _ = Network<InvoiceDetailElements,Empty>.init(path: "api/customer/invoices/\(id)", ignoreAuth: false).get { (res) in
            res.ifSuccess { (data) in
                DispatchQueue.main.async {
                    self.data = data
                    self.tableView.reloadData()
                }
            }
        }
    }

}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let item = self.data[indexPath.item]
        cell.titleLabel1.text = "\(indexPath.item+1)"
        cell.titleLabel2.text = item.title
        cell.titleLabel3.text = "\(item.price.self ?? 0)"
    
        cell.titleLabel4.text = "\(item.paid ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
