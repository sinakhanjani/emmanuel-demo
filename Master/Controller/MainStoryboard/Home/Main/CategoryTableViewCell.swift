//
//  CategoryTableViewCell.swift
//  Master
//
//  Created by Sina khanjani on 1/18/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import UIKit
protocol CategoryTableViewCellDelegate {
    func buttonTapped(cell: CategoryTableViewCell)
}

class CategoryTableViewCell: UITableViewCell {
    
    var delegate: CategoryTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonTapped() {
        delegate?.buttonTapped(cell: self)
    }
    
}
