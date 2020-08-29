//
//  Themes.swift
//  Memorize
//
//  Created by Terry Dengis on 8/10/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct Theme: Codable  {
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
    
    init(name: String, emojis: [String], color: UIColor.RGB, numberOfPairs: Int) {
        self.name = name
        self.emojis = emojis
        self.color = color
        self.numberOfPairs = numberOfPairs
    }
}

let themes: [Theme] = [
    Theme (
        name: "Halloween",
        emojis: ["👻","🎃","🕷","☠️","😱","🦇","💀","👿","👽"], //9
        color: UIColor.orange.rgb,
        numberOfPairs: 9
        
    ),
    Theme (
        name: "Sports",
        emojis: ["⚽️","🏀","🏈","🏐","🎱","⛳️","🏑","🎳","🥌","⛸"], //10
        color: UIColor.blue.rgb,
        numberOfPairs: 10
    ),
    Theme (
        name: "Flags",
        emojis: ["🇩🇿","🇦🇹","🇩🇲","🇬🇷","🇯🇵","🇺🇾","🇺🇸","🇹🇷","🇧🇪","🇨🇦","🇹🇨","🏴󠁧󠁢󠁳󠁣󠁴󠁿","🇧🇷"], //13
        color: UIColor.red.rgb,
        numberOfPairs: 13
    ),
    Theme (
        name: "Animals",
        emojis: ["🐶","🐱","🐭","🦊","🐻","🐮","🐷","🐸","🐧","🙊","🐌"], //11
        color: UIColor.green.rgb,
        numberOfPairs: 11
    ),
    Theme (
        name: "Food",
        emojis: ["🍎","🥨","🍭","🍪","🍕","🍔","🍌","🍆","🧅","🎂","🍦","🥓"], //12
        color: UIColor.magenta.rgb,
        numberOfPairs: 12
    ),
    Theme (
        name: "Places",
        emojis: ["🗽","🗿","🏝","🏔","🕌","🗼","⛩","🏖"], //8
        color: UIColor.purple.rgb,
        numberOfPairs: 8
    ),
    Theme (
        name: "Gaming",
        emojis: ["🎮","🕹","📀","👾","🤖"],
        color: UIColor.brown.rgb,
        numberOfPairs: 5
    ),
    Theme (
        name: "Faces",
        emojis: ["😀","😋","😏","😫","🤯","😥","😬"], //7
        color: UIColor.yellow.rgb,
        numberOfPairs: 7
    ),
    Theme (
        name: "Hearts",
        emojis: ["❤️","🧡","💛","💚","💙", "🖤"], //6
        color: UIColor.gray.rgb,
        numberOfPairs: 6
    )
]
