//
//  SelectionViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/13/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol SelectionViewControllerDelegate {
    func selected(id:Int, name: String, type: SectionType)
}
enum SectionType {
    case none,province,city
}

class SelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var delegate: SelectionViewControllerDelegate?
    
    var data = [Province]()
    var selectedIndex: Int?
    var type: SectionType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        backBarButtonAttribute(color: .white, name: "")
    }
}

extension SelectionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = data[indexPath.item]
        cell.textLabel?.text = item.name
        if let index = selectedIndex {
            if indexPath.item == index {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.item]
        self.selectedIndex = indexPath.item
        tableView.reloadData()
        delegate?.selected(id: item.id, name: item.name, type: type)
    }
}


extension SelectionViewController {
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
        dismiss(animated: true, completion: nil)
    }
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
