//
//  faq.swift
//  Master
//
//  Created by Sina khanjani on 1/14/1399 AP.
//  Copyright © 1399 iPersianDeveloper. All rights reserved.
//

import Foundation
// MARK: - FAQElement
struct FAQElement: Codable {
    let question, answer: String
}

typealias FAQS = [FAQElement]
