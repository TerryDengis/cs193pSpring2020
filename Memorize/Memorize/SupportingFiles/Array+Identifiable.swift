//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Terry Dengis on 8/7/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
    
    func newId () -> Int {
        var id: Int = 0
        
        for index in 0..<self.count {
            if self[index].id as! Int >= id {
                id = self[index].id as! Int
            }
        }
        return id + 1
    }
}
