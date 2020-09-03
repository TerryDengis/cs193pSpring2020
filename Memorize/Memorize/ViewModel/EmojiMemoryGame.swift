//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Terry Dengis on 8/5/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    @Published private var model: MemoryGame<String>
    
    private(set) var theme: Theme
    
    private static func createMemoryGame (_ theme: Theme) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairs: theme.numberOfPairs) { pairIndex in
            return theme.emojis[pairIndex]
        }
    }
    
    init(theme: Theme){
        self.theme = theme
        self.theme.emojis.shuffle()
        model =  EmojiMemoryGame.createMemoryGame(theme)
    }
    
    func newGame () {
        theme.emojis.shuffle()
        model =  EmojiMemoryGame.createMemoryGame(theme)
        //print (theme.json!.utf8!)
    }
    
    // MARK: - Access to the model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}

