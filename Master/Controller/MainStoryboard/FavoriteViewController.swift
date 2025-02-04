//
//  FavoriteViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/13/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation

class FavoriteViewController: UIViewController, TableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = Favorites()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "My Favourites"
        addBarButton()
        fetch()
    }
    
    func button1Tapped(sender: UIButton, cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            // remove
            let id = self.data[indexPath.row].id
            _ = Network<Empty,Empty>.init(path: "api/products/\(id)/favorite", ignoreAuth: false).post { (res) in
                res.ifSuccess { (empty) in
                    self.fetch()
                }
            }
        }
    }
    
    func fetch() {
        _ = Network<Favorites,Empty>.init(path: "api/customer/favorites", ignoreAuth: false).get(completion: { (res) in
            res.ifSuccess { (data) in
                self.data = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }

}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let item = data[indexPath.item]
        cell.delegate = self
        if let images = item.images {
            if !images.isEmpty {
                cell.imageView1.loadImageUsingCache(withUrl: images[0],isProduct: true)
            }
        }
        cell.titleLabel1.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension FavoriteViewController {
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
