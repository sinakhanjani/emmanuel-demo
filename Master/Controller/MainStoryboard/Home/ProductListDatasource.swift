//
//  ProductListDatasource.swift
//  Master
//
//  Created by Sina khanjani on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation

class ProductListDatasource: NSObject, UICollectionViewDataSource {
    internal init(data: [Product]) {
        self.data = data
    }
    
    var data: [Product]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
        let item = data[indexPath.item]
        cell.confirgureCell(interval: item.counter, discountPrice: item.discountPrice, price: item.price, name: item.name, ImageName: item.imageName)
        return cell
    }
}
