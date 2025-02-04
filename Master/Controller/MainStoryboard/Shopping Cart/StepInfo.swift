//
//  StepInfo.swift
//  Master
//
//  Created by Sina khanjani on 2/11/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation

class StepInfo {
    static let instance = StepInfo()
    
    var address: AddressElement?
    var Baskets = [BasketElement]()
    var addIndex: Int!
    var totalPriceServer: Double!
}
