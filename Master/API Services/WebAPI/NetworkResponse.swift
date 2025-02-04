//
//  NetworkResponse.swift
//  Nerkh
//
//  Created by Sina khanjani on 1/9/1399 AP.
//  Copyright © 1399 Sina Khanjani. All rights reserved.
//

import Foundation

public enum NetworkResponse<T> {
    case success (T)
    case error(Error)
}

extension NetworkResponse {
    func ifSuccess(handler : (T) -> Void) {
        switch self {
        case .success(let data):
            handler(data)
        default:
            break
        }
    }
    func ifFailed(handler : (Error) -> Void) {
        switch self {
        case .error(let error):
            handler(error)
        default:
            break
        }
    }
}
