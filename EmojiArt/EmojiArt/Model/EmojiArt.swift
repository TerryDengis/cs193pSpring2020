//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Terry Dengis on 8/24/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import Foundation

struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojis = [Emoji] ()
    
    struct Emoji: Hashable, Identifiable, Codable {
        let text: String
        var x: Int // offset from the center
        var y: Int // offset from the center
        var size: Int
        let id: Int
        
        fileprivate init(text: String, x: Int, y: Int, size: Int, id: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    init() {}
    
    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(text: text, x: x, y: y, size: size, id: uniqueEmojiId))
    }
    
    mutating func remove(_ emoji: Emoji) {
        if let index = emojis.firstIndex(of: emoji) {
            emojis.remove(at: index)
        }
    }
}
