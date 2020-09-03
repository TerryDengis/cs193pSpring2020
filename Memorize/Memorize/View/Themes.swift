//
//  Themes.swift
//  Memorize
//
//  Created by Terry Dengis on 8/10/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

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
}

let defaultThemes = [
    Theme (
        id: 1,
        name: "Gaming",
        emojis: ["🎮","🕹","📀","👾","🤖"],
        color: UIColor.brown.rgb,
        numberOfPairs: 4
    ),
    Theme (
        id: 2,
        name: "Hearts",
        emojis: ["❤️","🧡","💛","💚","💙", "🖤"], //6
        color: UIColor.gray.rgb,
        numberOfPairs: 5
    ),
    Theme (
        id: 3,
        name: "Faces",
        emojis: ["😀","😋","😏","😫","🤯","😥","😬"], //7
        color: UIColor.yellow.rgb,
        numberOfPairs: 6
    ),
    Theme (
        id: 4,
        name: "Places",
        emojis: ["🗽","🗿","🏝","🏔","🕌","🗼","⛩","🏖"], //8
        color: UIColor.purple.rgb,
        numberOfPairs: 7
    ),
    Theme (
        id: 5,
        name: "Halloween",
        emojis: ["👻","🎃","🕷","☠️","😱","🦇","💀","👿","👽"], //9
        color: UIColor.orange.rgb,
        numberOfPairs: 8
    ),
    Theme (
        id: 9,
        name: "Sports",
        emojis: ["⚽️","🏀","🏈","🏐","🎱","⛳️","🏑","🎳","🥌","⛸"], //10
        color: UIColor.blue.rgb,
        numberOfPairs: 9
    ),
    Theme (
        id: 7,
        name: "Animals",
        emojis: ["🐶","🐱","🐭","🦊","🐻","🐮","🐷","🐸","🐧","🙊","🐌"], //11
        color: UIColor.green.rgb,
        numberOfPairs: 11
    ),
    Theme (
        id: 8,
        name: "Food",
        emojis: ["🍎","🥨","🍭","🍪","🍕","🍔","🍌","🍆","🧅","🎂","🍦","🥓","🥜","🥐","🍉","🍦","🧀"], //12
        color: UIColor.magenta.rgb,
        numberOfPairs: 11
    )
]
