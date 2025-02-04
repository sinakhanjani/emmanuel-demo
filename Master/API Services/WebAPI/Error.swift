//
//  Error.swift
//  Nerkh
//
//  Created by Sina khanjani on 1/9/1399 AP.
//  Copyright © 1399 Sina Khanjani. All rights reserved.
//

import Foundation

public enum NetworkErrors : Error {
    case NotFound
    case Unathorized
    case InternalError
    case BadURL
    case BadRequest
    case TimeOuted
    case BadParameters
    case json
}
