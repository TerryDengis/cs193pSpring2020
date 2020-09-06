//
//  EmojiThemeStore.swift
//  Memorize
//
//  Created by Terry Dengis on 9/1/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI
import Combine

class EmojiThemeStore: ObservableObject {
    @EnvironmentObject var emojiThemeStore: EmojiThemeStore
    @Published var themes: Themes
    
    private var autosaveCancellable: AnyCancellable?
    
    init () {
        print (NSHomeDirectory())
        let defaultsKey = "EmojiMemoryStore"
    
        themes = Themes(json: UserDefaults.standard.data (forKey: defaultsKey)) ?? Themes ()
        
        autosaveCancellable = $themes.sink { themes in
            UserDefaults.standard.set (themes.json, forKey: defaultsKey)
        }
    }
    
    func indexWith(_ id: Int) -> Int? {
        for index in 0 ..< themes.list.count {
            if themes.list[index].id == id {
                return index
            }
        }
        return nil
    }

    func removeEmoji( _ emoji: String, fromTheme id: Int) -> [String] {
        if let index = indexWith(id) {
            if let chosenIndex = themes.list[index].emojis.firstIndex(of: emoji) {
                themes.list[index].emojis.remove(at: chosenIndex)
            }
            return themes.list[index].emojis
        }
        return [""]
    }
    
    func setNumberOfPairs(to pairs:Int, in id: Int) {
        if let index = indexWith(id) {
            themes.list[index].numberOfPairs = pairs
        }
    }
    
    func setName(_ name: String, forId id: Int) {
        if let index = indexWith(id) {
            themes.list[index].name = name
        }
        themes.list = themes.list.sorted { $0.name < $1.name }
    }
    func setColor(_ color: UIColor.RGB, forId id: Int) {
        if let index = indexWith(id) {
            themes.list[index].color = color
        }
    }
    func remove(_ index: Int) {
        themes.list.remove(at: index)
    }
    
    func newTheme () {
        themes.list.append(Theme(id: themes.list.newId(), name: "untitled", emojis: ["🙂","😕"], color: colorPalette[0], numberOfPairs: 2))
    }
    
    func addEmojis (_ emojis: String, forId id: Int) -> [String]{
        if let index = indexWith(id) {
            for emoji in emojis {
                if !themes.list[index].emojis.contains("\(emoji)") {
                    themes.list[index].emojis.append("\(emoji)")
                }
            }
            return themes.list[index].emojis
        }
        return [""]
    }
}

let colorPalette: [UIColor.RGB] = [
    UIColor.blue.rgb, UIColor.brown.rgb, UIColor.cyan.rgb, UIColor.gray.rgb, UIColor.green.rgb, UIColor.magenta.rgb, UIColor.orange.rgb, UIColor.systemPink.rgb, UIColor.purple.rgb ,UIColor.red.rgb, UIColor.systemRed.rgb, UIColor.yellow.rgb
    ]

let defaultThemes = [
    (Theme (
        id: 1,
        name: "Gaming",
        emojis: ["🎮","🕹","📀","👾","🤖"],
        color: colorPalette[0],
        numberOfPairs: 4
    )),
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
        id: 6,
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

