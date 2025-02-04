//
//  FAQViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/13/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = FAQS()
    var selectedIndex = -1
    var isCollapse = false

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()
        self.navigationItem.title = "FAQ"
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
        fetch()
    }
    
    func fetch() {
        _ = Network<FAQS,Empty>.init(path: "api/faq", ignoreAuth: false).get { (res) in
            res.ifSuccess { (faqs) in
                self.data = faqs
                print(self.data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let item = data[indexPath.item]
        cell.titleLabel1.text = item.question
        cell.titleLabel2.text = item.answer
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.selectedIndex == indexPath.row {
            if !self.isCollapse {
                self.isCollapse = true
            } else {
                self.isCollapse = false
            }
        } else {
            self.isCollapse = true
        }
        self.selectedIndex = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == indexPath.item && isCollapse {
            return UITableView.automaticDimension
        } else {
            return 60
        }
    }
}

extension FAQViewController {
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
