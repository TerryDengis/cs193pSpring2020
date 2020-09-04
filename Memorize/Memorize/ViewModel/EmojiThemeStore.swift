//
//  EmojiThemeStore.swift
//  Memorize
//
//  Created by Terry Dengis on 9/1/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

class EmojiThemeStore: ObservableObject {
    @EnvironmentObject var emojiThemeStore: EmojiThemeStore
    @Published var themes: [Theme]
    
    init () {
        if let themesjson = UserDefaults.standard.data (forKey: "EmojiMemoryStore") {
            print ("Themes json : \(themesjson.utf8 ?? "nil")")
            themes = [Theme] ()
        } else {
            themes = defaultThemes.sorted { $0.name < $1.name }
        }
    }
    
    func indexWith(_ id: Int) -> Int? {
        for index in 0 ..< themes.count {
            if themes[index].id == id {
                return index
            }
        }
        return nil
    }

    func removeEmoji( _ emoji: String, fromTheme id: Int) -> [String] {
        if let index = indexWith(id) {
            if let chosenIndex = themes[index].emojis.firstIndex(of: emoji) {
                themes[index].emojis.remove(at: chosenIndex)
            }
            return themes[index].emojis
        }
        return [""]
    }
    
    func setNumberOfPairs(to pairs:Int, in id: Int) {
        if let index = indexWith(id) {
            themes[index].numberOfPairs = pairs
        }
    }
    
    func setName(_ name: String, forId id: Int) {
        if let index = indexWith(id) {
            themes[index].name = name
        }
        themes = themes.sorted { $0.name < $1.name }
    }
    func setColor(_ color: UIColor.RGB, forId id: Int) {
        if let index = indexWith(id) {
            themes[index].color = color
        }
    }
    func remove(_ index: Int) {
        themes.remove(at: index)
    }
    
    func newTheme () {
        themes.append(Theme(id: themes.newId(), name: "untitled", emojis: ["🙂","😕"], color: colorPalette[0], numberOfPairs: 2))
    }
    
    func addEmojis (_ emojis: String, forId id: Int) -> [String]{
        if let index = indexWith(id) {
            for emoji in emojis {
                if !themes[index].emojis.contains("\(emoji)") {
                    themes[index].emojis.append("\(emoji)")
                }
            }
            return themes[index].emojis
        }
        return [""]
    }
}

let colorPalette: [UIColor.RGB] = [
    UIColor.blue.rgb, UIColor.brown.rgb, UIColor.cyan.rgb, UIColor.gray.rgb, UIColor.green.rgb, UIColor.magenta.rgb, UIColor.orange.rgb, UIColor.systemPink.rgb, UIColor.purple.rgb ,UIColor.red.rgb, UIColor.systemRed.rgb, UIColor.yellow.rgb
    ]

let defaultThemes = [
    Theme (
        id: 1,
        name: "Gaming",
        emojis: ["🎮","🕹","📀","👾","🤖"],
        color: colorPalette[0],
        numberOfPairs: 4
    ),
    Theme (
        id: 2,
        name: "Hearts",
        emojis: ["❤️","🧡","💛","💚","💙", "🖤"], //6
        color: colorPalette[1],
        numberOfPairs: 5
    ),
    Theme (
        id: 3,
        name: "Faces",
        emojis: ["😀","😋","😏","😫","🤯","😥","😬"], //7
        color: colorPalette[4],
        numberOfPairs: 6
    ),
    Theme (
        id: 4,
        name: "Places",
        emojis: ["🗽","🗿","🏝","🏔","🕌","🗼","⛩","🏖"], //8
        color: colorPalette[3],
        numberOfPairs: 7
    ),
    Theme (
        id: 5,
        name: "Halloween",
        emojis: ["👻","🎃","🕷","☠️","😱","🦇","💀","👿","👽"], //9
        color: colorPalette[6],
        numberOfPairs: 8
    ),
    Theme (
        id: 9,
        name: "Sports",
        emojis: ["⚽️","🏀","🏈","🏐","🎱","⛳️","🏑","🎳","🥌","⛸"], //10
        color: colorPalette[7],
        numberOfPairs: 9
    ),
    Theme (
        id: 7,
        name: "Animals",
        emojis: ["🐶","🐱","🐭","🦊","🐻","🐮","🐷","🐸","🐧","🙊","🐌"], //11
        color: colorPalette[8],
        numberOfPairs: 11
    ),
    Theme (
        id: 8,
        name: "Food",
        emojis: ["🍎","🥨","🍭","🍪","🍕","🍔","🍌","🍆","🧅","🎂","🥓","🥜","🥐","🍉","🍦","🧀"], //12
        color: colorPalette[9],
        numberOfPairs: 11
    )
]
