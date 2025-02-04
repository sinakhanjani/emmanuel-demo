//
//  ProductViewController.swift
//  Master
//
//  Created by Sina khanjani on 1/27/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
import Cosmos

protocol ProducttInjection {
    func fetchDataBy(id: Int) -> ProductViewController
}

extension ProducttInjection {
    func fetchDataBy(id: Int) -> ProductViewController {
        let vc = ProductViewController.create()
        vc.fetch(id: id)
        return vc
    }
}

class ProductViewController: UITableViewController, ProducttInjection {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var detailTableView: ScrollTableView!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secendNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var totalPeopleRankedLabel: UILabel!
    @IBOutlet weak var specialButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    let productController = ProductController()
    var isOpen = false
    var images = [String]()
    var id: Int?
    var selectedFeature = [String:[String]]()
    var pro:ProductElement?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBarButtonAttribute(color: .white, name: "")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView.isPagingEnabled = true
        productController.delegate = self
        detailTableView.delegate = productController
        detailTableView.dataSource = productController
    }
    
    func fetch(id:Int) {
        self.startIndicatorAnimate()
        _ = Network<[ProductElement],Empty>.init(path: "api/products/\(id)", ignoreAuth: true).addParameters(params: ["ios":"1"]).get { (res) in
            res.ifSuccess { (data) in
                DispatchQueue.main.async {
                    self.stopIndicatorAnimate()
                }
                if !data.isEmpty {
                    let item = data[0]
                    self.id = item.id
                    self.updateUI(element: item)
                }
            }
        }
    }
    
    private func updateUI(element: ProductElement) {
        self.pro = element
        DispatchQueue.main.async {
            if let images = element.images {
                self.images = images
                self.collectionView.reloadData()
            }
            self.selectedFeature = element.selectableFeatures?.innerArray ?? [String:[String]]()
            self.nameLabel.text = element.title
            self.secendNameLabel.text = element.titleFull
            self.title = element.title
            // available >
            if element.unit! > 0 {
                self.availableLabel.text = "Available"
            } else {
                self.availableLabel.text = "Not Available"
            }
            self.descriptionLabel.text = element.productDescription
            if let state = element.stats, Int(state.ratesSum)! > 0 {
                let rate = Double(Int(state.ratesSum)!/Int(state.ratesCount)!)
                self.rankLabel.text = "\(rate)" + " from 5.0"
                self.totalPeopleRankedLabel.text = "Total " + state.ratesCount + " people"
                self.cosmosView.rating = Double(Int(state.ratesSum)!/Int(state.ratesCount)!)
            } else {
                self.rankLabel.text = "0" + " from 5.0"
                self.totalPeopleRankedLabel.text = "Total " + "0" + " people"
                self.cosmosView.rating = 0.0
            }
            if let otherPrice = element.otherPrices {
                self.productController.data.append(contentsOf: otherPrice)
                self.detailTableView.reloadData()
            }

            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.tableView.reloadRows(at: [IndexPath(item: 0, section: 2)], with: .automatic)
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section,indexPath.item) {
            case (0,0):return 220
            case (1,0): return 44
            case (1,1): return 50
            case (1,2): return 32
            case (1,3): return 50
            case (2,0): return UITableView.automaticDimension
            case (3,0):
                if isOpen {
                    return UITableView.automaticDimension
                } else {
                    return 100
                }
            case (3,1): return 120
            default: return 44
        }
    }
    
    // MARK: Right
    @IBAction func shareButtonTapped(_ sender: Any) {
        //
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        guard Authentication.auth.isLoggedIn else {
            // must be login
            let vc = ProfileTableViewController.create().addToNav()
            self.present(vc, animated: true, completion: nil)
            return
        }
        let liked = "ic_desc_fav_true"
        let unliked = "ic_desc_fav"
        if let id = self.pro?.id {
            _ = Network<Empty,Empty>.init(path: "api/products/\(id)/favorite", ignoreAuth: false).post { (res) in
                res.ifSuccess { (empty) in
                    
                }
            }
        }
    }
    
    @IBAction func alertButtonTapped(_ sender: Any) {
        guard Authentication.auth.isLoggedIn else {
            // must be login
            let vc = ProfileTableViewController.create().addToNav()
            self.present(vc, animated: true, completion: nil)
            return
        }
        let on = "ic_desc_alarm_true"
        let off = "ic_desc_alarm"
        let vc = SpecialOfferViewController.create()
        vc.id = self.pro?.id
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: Bottom
    @IBAction func compareButtonTapped(_ sender: Any) {
        let vc = CompareViewController.create()
        vc.pro = pro
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func informationButtonTapped(_ sender: Any) {
        let vc = ProductInformationViewController.create()
        vc.sub = self.pro?.features?.sub
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func commentButtonTapped(_ sender: Any) {
        guard Authentication.auth.isLoggedIn else {
            // must be login
            let vc = ProfileTableViewController.create().addToNav()
            self.present(vc, animated: true, completion: nil)
            return
        }
        let vc = CommentViewController.create()
        vc.title = pro?.title
        vc.pro = pro
        show(vc, sender: nil)
    }
    
    //
    @IBAction func moreButtonTapped(_ sender: Any) {
        self.isOpen = !isOpen
        if isOpen {
            self.moreButton.setTitle("Less", for: .normal)
        } else {
            self.moreButton.setTitle("More", for: .normal)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func addToBasketButtontapped(_ sender: Any) {
        guard Authentication.auth.isLoggedIn else {
            // must be login
            let vc = ProfileTableViewController.create().addToNav()
            self.present(vc, animated: true, completion: nil)
            return
        }
        if let id = id {
            let vc = AddToBasketViewController.create()
            if let index = self.productController.selectedIndex, let hash = self.productController.data[index].hash {
                vc.otherPricehash = hash
            } else {
                vc.otherPricehash = "0"
            }
            
            vc.id = id
            vc.selectedFeature = selectedFeature
            present(vc, animated: true, completion: nil)
        }
    }
}


extension ProductViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let item = images[indexPath.item]
        cell.imageView1.loadImageUsingCache(withUrl: item, isProduct: false)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension ProductViewController: ProductControllerDelegate {

}
