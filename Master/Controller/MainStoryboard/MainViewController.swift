//
//  MainViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/10/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

enum DataType:String {
    case banner
    case category
    case specialOffer = "Special offer"
    case list
    case lastest = "Lastest"
}

class MainViewController: UIViewController,API {
    
    @IBOutlet weak var tableView: UITableView!

    var searchController: UISearchController!
    let lblBadge = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 18, height: 18))

    var dataType: [DataType] = [.banner,.category,.specialOffer,.lastest,.list,.list,.list]

    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .white, name: "")
        configureSideBar()
        addBarButtons()
        searchBarDelegates()
        configuteTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(notif), name: Constant.Notify.basketCount, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchBasketCount()
    }
    
    
    @objc func notif() {
        if let no = DataManager.shared.basketCount {
            self.lblBadge.text = "\(no)"

        } else {
            lblBadge.text = "0"
        }
    }
    
    func configuteTableView() {
//        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "BannerTableViewCell", bundle: nil), forCellReuseIdentifier: "bannerCell")
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        tableView.register(UINib(nibName: "SpecialOfferTableViewCell", bundle: nil), forCellReuseIdentifier: "specialOffer")

    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.main.list.count+2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerCell", for: indexPath) as! BannerTableViewCell
             cell.delegate = self
            cell.data = DataManager.shared.main.banner
             return cell
        } else if indexPath.item == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
            cell.delegate = self
            return cell
        } else {
            let item = DataManager.shared.main.list[indexPath.item-2]
            let type = item.type
            let cell = tableView.dequeueReusableCell(withIdentifier: "specialOffer", for: indexPath) as! SpecialOfferTableViewCell
            cell.data = item.products
            cell.delegate = self
            cell.dataType = type
            if type == .lastest || type == .specialOffer {
                cell.nameLabel.text = type.rawValue
            } else {
                cell.nameLabel.text = item.name
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item == 0 {
            return 210
        } else if indexPath.item == 1 {
            return 80
        } else {
            return SpecialOfferTableViewCell.collectionHeigh+30.0
        }
    }
}

extension MainViewController : CategoryTableViewCellDelegate, SpecialOfferTableViewCellDelegate, BannerTableViewCellDelegate {
    func bannerTapped(cell: BannerTableViewCell,banner: Banner) {
        if let productId = banner.productId {
            let vc = ProductViewController.create().fetchDataBy(id: productId)
            self.show(vc, sender: nil)
        }
        if let categoryId = banner.categoryId {
            let vc = ProductListViewController.create().fetchDataByCategory(id: categoryId)
            self.show(vc, sender: nil)
        }
    }
    
    func buttonTapped(cell: CategoryTableViewCell) {
        let vc = CategoryListViewController.create()
        show(vc, sender: nil)
    }
    
    func productSelectedAt(productId: Int) {
        let vc = ProductViewController.create().fetchDataBy(id: productId)
        self.show(vc, sender: nil)
    }
}

extension MainViewController {
    func addBarButtons() {
        // left
        let menuBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(menuButtonTapped(_:)))
        menuBarButtonItem.image = UIImage(named: "menuIcon")
        menuBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = menuBarButtonItem
        navigationController?.navigationItem.leftBarButtonItem = menuBarButtonItem
        // rights
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        filterBtn.setImage(UIImage(named: "basketBarButton"), for: .normal)
        filterBtn.addTarget(self, action: #selector(basketButtonTapped), for: .touchUpInside)
        lblBadge.backgroundColor = .white
        lblBadge.font = UIFont(name: "Arial", size: 11)
        lblBadge.clipsToBounds = true
        lblBadge.layer.cornerRadius = 9
        if Authentication.auth.isLoggedIn {
            if let no = DataManager.shared.basketCount {
                lblBadge.text = "\(no)"
            } else {
                lblBadge.text = "0"
            }
        } else {
            lblBadge.text = "0"
        }
        lblBadge.textAlignment = .center
        filterBtn.addSubview(lblBadge)
        // search
        let searchBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(searchButtonTapped))
        let basketBarButton = UIBarButtonItem(customView: filterBtn)
        basketBarButton.action = #selector(basketButtonTapped(_:))
        basketBarButton.tintColor = .white
        navigationItem.rightBarButtonItem = basketBarButton
        navigationController?.navigationItem.rightBarButtonItem = basketBarButton
        // basket
        searchBarButtonItem.image = UIImage(named: "ic_toolbar_search2")
        searchBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItems?.append(searchBarButtonItem)
        navigationController?.navigationItem.rightBarButtonItems?.append(searchBarButtonItem)
    }

    @objc func menuButtonTapped(_ sender: UIBarButtonItem) {
        toggleSideMenu()
    }
    
    @objc func searchButtonTapped(_ sender: UIBarButtonItem) {
        searchController.isActive = true
    }
    
    @objc func basketButtonTapped(_ sender: UIBarButtonItem) {
        guard Authentication.auth.isLoggedIn else {
            self.presentIOSAlertWarning(message: "Please Login with your email and password", completion: {})
            return
        }
        let vc = BasketViewController.create()
        vc.isParent = .no
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBarDelegates() {
        let resultController = ProductListViewController.create()
        self.searchController = UISearchController(searchResultsController: resultController)
        self.searchController.searchResultsUpdater = resultController
        resultController.delegate = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        self.definesPresentationContext = true
        SearchBarAppearence()
    }
    
    func SearchBarAppearence() {
        searchController.searchBar.searchBarStyle = .default
        self.navigationController!.view.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string:"Search products ...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: "Search products ...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textFieldInsideSearchBar?.textColor = UIColor.white
        searchController.searchBar.tintColor = .white
    }
}

extension MainViewController: ProductListViewControllerDelegate {
    func callBack(product: Product) {
        searchController.isActive = false
        let vc = ProductViewController.create().fetchDataBy(id: product.id)
        self.show(vc, sender: nil)
    }
}
