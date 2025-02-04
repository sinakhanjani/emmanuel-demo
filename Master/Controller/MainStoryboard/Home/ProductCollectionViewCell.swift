//
//  ProductCollectionViewCell.swift
//  Master
//
//  Created by Sina khanjani on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var offerView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var timer: Timer?
    var elapsedTimeInSecond: Int = 0
    var interval: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        // Initialization code
        countDownTimer()
    }
    
    func confirgureCell(interval: Int?,discountPrice: Int?, price: Double, name: String, ImageName:String) {// price: Int CHANGE
        self.interval = interval
        if let discountPrice = discountPrice {
            self.discountLabel.text = discountPrice.seperateByCama + " £"
        }
        self.priceLabel.text = String(price) + " £" // CHANGE price.seperateByCama
        self.nameLabel.text = name
        self.imageView.loadImageUsingCache(withUrl: ImageName, isProduct: true)
    }
}

extension ProductCollectionViewCell {
        func countDownTimer() {
            guard let interval = interval else {
                self.offerView.alpha = 0.0
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar.init(identifier: .persian)
            dateFormatter.locale = Locale.init(identifier: "fa_IR")
            dateFormatter.dateFormat = "yyyy/MM/dd"
            if interval > 0 {
                self.elapsedTimeInSecond = interval
                self.offerView.alpha = 1.0
            } else {
                self.offerView.alpha = 0.0
            }
            self.timer?.invalidate()
            if interval > 0 {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                    let seconds: Int = self.elapsedTimeInSecond % 60
                    let minutes: Int = (self.elapsedTimeInSecond / 60) % 60
                    let hour: Int = ((self.elapsedTimeInSecond / 60)/60) % 60
                    let day = (((self.elapsedTimeInSecond / 60)/60)/24)// % 24
                    let _ = String(format: "%03d",day).inserting(separator: "    ", every: 1)
                    let hourStr = String(format: "%02d",hour).inserting(separator: "", every: 1)
                    let minutesStr = String(format: "%02d",minutes).inserting(separator: "", every: 1)
                    let secendsStr = String(format: "%02d",seconds).inserting(separator: "", every: 1)
                    let text = hourStr + "     " + minutesStr + "     " + secendsStr
                    self.countLabel.text = text
                    let printable = String(format: "%02d : %02d : %02d : %02d",day,hour,minutes,seconds)
                    print(printable)
                    self.elapsedTimeInSecond -= 1
                    if self.elapsedTimeInSecond == 0 {
                        self.timer?.invalidate()
                    }
                })
            }

        }
}

extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.dropFirst().reversed()
            where distance(to: index).isMultiple(of: n) {
            insert(contentsOf: separator, at: index)
        }
    }
    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: n)
        return string
    }
}
extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

extension Collection {
    var pairs: [SubSequence] {
        var startIndex = self.startIndex
        let count = self.count
        let n = count/2 + count % 2
        return (0..<n).map { _ in
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return self[startIndex..<endIndex]
        }
    }
}
