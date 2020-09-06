//
//  Themes.swift
//  Memorize
//
//  Created by Terry Dengis on 9/6/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct Themes: Codable {
    var list: [Theme]
    
    var json: Data? {
        try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newThemes = try? JSONDecoder().decode(Themes.self, from: json!) {
            self = newThemes
        } else {
            return nil
        }
    }
    
    init () {
        list = defaultThemes
    }
    
}
struct Theme: Codable, Identifiable, Hashable  {
    var id: Int
    var name: String
    var emojis: [String]
    var color: UIColor.RGB
    var numberOfPairs: Int
    
    var json: Data?  {
        try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newTheme = try? JSONDecoder().decode(Theme.self, from: json!) {
            self = newTheme
        } else {
            return nil
        }
    }
    
    init(id: Int, name: String, emojis: [String], color: UIColor.RGB, numberOfPairs: Int) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfPairs = numberOfPairs
        self.id = id
    }
    
    var emojiString: String {
        var returnValue: String = ""
        
        for emoji in emojis {
            returnValue += emoji
        }
        return returnValue
    }
}

