//
//  ChoosenCompareViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/27/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol ChoosenCompareViewControllerDelegate {
    func callBackProduct(p: CompareListGetElement)
}

class ChoosenCompareViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate:ChoosenCompareViewControllerDelegate?
    var id : Int?
    var data = CompareListGets()

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .white, name: "")
        if let id = id {
            self.compareListGet(productId: id)
        }
    }
    
    func compareListGet(productId: Int) {
        _ = Network<CompareListGets,Empty>.init(path: "api/products/related", ignoreAuth: true).addParameters(params: ["product_id":"\(productId)"]).get { (res) in
              res.ifSuccess { (data) in
                DispatchQueue.main.async {
                    self.data = data
                    self.tableView.reloadData()
                  }
              }
          }
      }
}

extension ChoosenCompareViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.delegate = self
        let item = data[indexPath.item]
        if let images = item.images {
            if images.count > 0 {
                cell.imageView1.loadImageUsingCache(withUrl: item.images![0], isProduct: true)
            }
        }
        cell.titleLabel1.text = item.title
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // delegate
        self.delegate?.callBackProduct(p: data[indexPath.item])
        self.navigationController?.popViewController(animated: true)
    }
}

extension ChoosenCompareViewController: TableViewCellDelegate {
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.delegate?.callBackProduct(p: data[indexPath.item])
            self.navigationController?.popViewController(animated: true)
        }
    }
}
