//
//  ProductListViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol ProductListViewControllerDelegate {
    func callBack(product: Product)
}

protocol ProductListInjection {
    func fetchDataByCategory(id: Int) -> ProductListViewController
}

extension ProductListInjection {
    func fetchDataByCategory(id: Int) -> ProductListViewController {
        let vc = ProductListViewController.create()
        vc.categoryID = id
        return vc
    }
}

class ProductListViewController: UIViewController, ProductListInjection {
    // MARK: - SearchElement
    struct SearchElement: Codable {
        let id: Int
        let title: String
        let titleFull:String?
        let images: String
        let productStatus, discount: Int
        let price: Double // CHANGE Ints

        enum CodingKeys: String, CodingKey {
            case id, title
            case titleFull = "title_full"
            case images
            case productStatus = "product_status"
            case price, discount
        }
    }
    typealias Searchs = [SearchElement]

    // MARK: - ProductListElement
    struct ProductListElement: Codable {
        let id: Int
        let title: String
        let price: Double // CHANGE
        let categoryID: Int
        let images: [String]
        let category: String
        enum CodingKeys: String, CodingKey {
            case id
            case title = "title"
            case price
            case categoryID = "category_id"
            case images
            case category
        }
    }
    typealias ProductLists = [ProductListElement]
    
    
    var collectionView: UICollectionView!
    
    var delegate: ProductListViewControllerDelegate?
    var productDatasource: ProductListDatasource!
    var categoryID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .white, name: "")
        self.navigationItem.title = "Products"
        configureCollectionView()
        fetchProducts()
    }
    
    func fetchProducts() {
        if let categoryID = categoryID {
            self.startIndicatorAnimate()
            _ = Network<ProductLists,Empty>.init(path: "api/products", ignoreAuth: true).addParameters(params: ["category":"\(categoryID)"]).get(completion: { (res) in
                res.ifSuccess { (items) in
                    // convert to products
                    self.productDatasource.data = items.map { Product(id: $0.id, name: $0.title, price: $0.price, discountPrice: nil, imageName: $0.images.count > 0 ? $0.images[0]:"", counter: nil)}
                    DispatchQueue.main.async {
                        if items.count > 0 {
                            self.navigationItem.title = items[0].category
                        }
                        self.stopIndicatorAnimate()
                        self.collectionView.reloadData()
                    }
                }
            })
        }
    }
    
    func fetch(value: String) {
        _ = Network<Searchs,Empty>.init(path: "api/search", ignoreAuth: true).addParameters(params: ["query":value]).get(completion: { (res) in
            res.ifSuccess { (items) in
                self.productDatasource.data = items.map { Product(id: $0.id, name: $0.title, price: $0.price, discountPrice: $0.discount, imageName: $0.images.split(separator: ",").count > 0 ? String($0.images.split(separator: ",")[0]):"", counter: nil)}
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    func configureCollectionView() {
        self.productDatasource = ProductListDatasource(data: [])
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let cgRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.collectionView = UICollectionView(frame: cgRect, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = productDatasource
        self.collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.keyboardDismissMode = .onDrag
        self.view.addSubview(collectionView)
    }
}

extension ProductListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        self.fetch(value: searchController.searchBar.text ?? "")
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = productDatasource.data[indexPath.item]
        if let _ = categoryID {
            let vc = ProductViewController.create().fetchDataBy(id: selectedItem.id)
            self.show(vc, sender: nil)
            return
        }
        self.dismiss(animated: true, completion: {
            self.delegate?.callBack(product: selectedItem)
        })
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns: CGFloat = 2
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 2
        }
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimention = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns

        return CGSize.init(width: cellDimention, height: SpecialOfferTableViewCell.collectionHeigh+16)
    }
}
