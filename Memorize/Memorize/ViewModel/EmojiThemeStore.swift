//
//  EmojiThemeStore.swift
//  Memorize
//
//  Created by Terry Dengis on 9/1/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

class EmojiThemeStore: ObservableObject {
    @Published var themes: [Theme]
    
    init () {
        if let themesjson = UserDefaults.standard.data (forKey: "EmojiMemoryStore") {
            print ("Themes json : \(themesjson.utf8 ?? "nil")")
            themes = [Theme] ()
        } else {
            themes = defaultThemes.sorted { $0.name < $1.name }
        }
    }
    
    private var sortedThemes: [Theme] {
        themes.sorted { $0.name < $1.name }
    }
    
    func setName(_ name: String, for theme: Theme) {
        if let index = themes.firstIndex(of: theme) {
            themes[index].name = name
            themes = themes.sorted { $0.name < $1.name }
        }
    }
    
    func remove(_ index: Int) {
            themes.remove(at: index)
        
    }
}
