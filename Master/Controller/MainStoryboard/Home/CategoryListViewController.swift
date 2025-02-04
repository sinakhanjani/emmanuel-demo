//
//  CategoryListViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = Categorys()

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .white, name: "")
        self.navigationItem.title = "Category"
        fetch()
        tableView.tableFooterView = UIView()
    }
    
    func fetch() {
        _ = Network<Categorys,Empty>.init(path: "api/categories/get", ignoreAuth: true).get { (res) in
            res.ifSuccess { (items) in
                self.data = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data[section].isOpen {
            return data[section].children.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = data[indexPath.section]
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            cell.titleLabel1.text = category.title
            cell.titleLabel1.font = UIFont.boldSystemFont(ofSize: 17)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
            let child = category.children[indexPath.item-1]
            cell.titleLabel1.text = child.title
            cell.titleLabel1.font = UIFont.systemFont(ofSize: 16)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard indexPath.item == 0 else {
//            let item = data[indexPath.section].children[indexPath.item-1]
//            let vc = self.fetchDataByCategory(id: item.id)
//            self.show(vc, sender: nil)
//            print(item)
//            return
//        }
//        if data[indexPath.section].isOpen {
//            let item = data[indexPath.section]
//            if item.inHomepage == 1 {
//                let vc = self.fetchDataByCategory(id: item.id)
//                self.show(vc, sender: nil)
//            }
//            data[indexPath.section].isOpen = false
//            let sections = IndexSet.init(integer: indexPath.section)
//            tableView.reloadSections(sections, with: .none)
//        } else {
//            data[indexPath.section].isOpen = true
//            let sections = IndexSet.init(integer: indexPath.section)
//            tableView.reloadSections(sections, with: .none)
//        }
// ISSUE APPSTORE BUG 
        let item = data[indexPath.section]
        let vc = self.fetchDataByCategory(id: item.id)
        self.show(vc, sender: nil)
    }
}

extension CategoryListViewController {
    // MARK: - Category
    struct Category: Codable {
        let id: Int
        let title: String
        let parentID: Int?
        let inHomepage: Int
        let children: [Category]
        var isOpen = false

        enum CodingKeys: String, CodingKey {
            case id, title
            case parentID = "parent_id"
            case inHomepage = "in_homepage"
            case children
        }
    }

    typealias Categorys = [Category]
}

extension CategoryListViewController: ProductListInjection { }
