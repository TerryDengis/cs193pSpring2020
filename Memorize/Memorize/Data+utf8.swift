//
//  Data+utf8.swift
//  Memorize
//
//  Created by Terry Dengis on 8/29/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import Foundation

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
