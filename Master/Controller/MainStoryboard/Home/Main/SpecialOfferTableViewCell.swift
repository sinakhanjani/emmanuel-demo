//
//  SpecialOfferTableViewCell.swift
//  Master
//
//  Created by Sina khanjani on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

protocol SpecialOfferTableViewCellDelegate {
    func productSelectedAt(productId: Int)
}

class SpecialOfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var collectionView: UICollectionView!
    
    var delegate: SpecialOfferTableViewCellDelegate?
    var productDatasource: ProductListDatasource!
    
    var dataType: DataType!
    var data = [Product]() {
        willSet {
            self.productDatasource.data = newValue
            self.collectionView.reloadData()
        }
    }

    static let collectionHeigh: CGFloat = 230
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCollectionView() {
        self.productDatasource = ProductListDatasource(data: data)
        self.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let cgRect = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: SpecialOfferTableViewCell.collectionHeigh)
        self.collectionView = UICollectionView(frame: cgRect, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = productDatasource
        self.collectionView.register(UINib(nibName: "ProductCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collectionView.backgroundColor = .clear
        self.collectionView.showsHorizontalScrollIndicator = false
        self.addSubview(collectionView)
    }
}

extension SpecialOfferTableViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = productDatasource.data[indexPath.item]
        delegate?.productSelectedAt(productId: selectedItem.id)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns: CGFloat = 2
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 2
        }
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimention = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBetweenCells) / numberOfColumns

        return CGSize.init(width: 155, height: SpecialOfferTableViewCell.collectionHeigh-16)
    }
}
