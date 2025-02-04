//
//  Generic.swift
//  Nerkh
//
//  Created by Sina khanjani on 1/9/1399 AP.
//  Copyright © 1399 Sina Khanjani. All rights reserved.
//

import Foundation

public struct Generic<T : Codable>: Codable {
    var error : Bool
    var reason : String
    var data : T?
}

struct Empty: Codable {
    
}
