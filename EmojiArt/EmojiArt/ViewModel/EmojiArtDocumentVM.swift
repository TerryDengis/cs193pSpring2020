//
//  EmojiArtDocumentVM.swift
//  EmojiArt
//
//  Created by Terry Dengis on 8/24/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

class EmojiArtDocumentVM: ObservableObject {
    
    static let palette: String = "🌞🌕🌎🪐⭐️🐝🐛🦋🐑🐓🐇🕊"
    
    @Published private var emojiArt: EmojiArt {
        didSet {
            UserDefaults.standard.set(emojiArt.json, forKey:EmojiArtDocumentVM.untitled)
        }
    }
    
    @Published private (set) var backgroundImage: UIImage?
    
    @Published private (set) var selectedEmojis: Set<EmojiArt.Emoji>
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis}
    
    init () {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocumentVM.untitled)) ?? EmojiArt ()
        selectedEmojis = Set()
        fetchBackgroundImageData()
    }
    
    // MARK: - Constants
    private static let untitled = "EmojiArtDocument.untitled"
    
    // MARK: - Intents(s)
    func moveSelection(_ distance: CGSize) {

        selectedEmojis.forEach { emoji in
            moveEmoji(emoji, by: distance)
        }
        deselect()
    }
    
    func resizeSelection(_ scale: CGFloat) {
        selectedEmojis.forEach { emoji in
            resizeEmoji(emoji, by: scale)
        }
        deselect()
    }
    
    func select (_ emoji: EmojiArt.Emoji) {
        if isSelected(emoji) {
            selectedEmojis.remove(emoji)
        } else {
            selectedEmojis.insert(emoji)
        }
    }
    
     func remove () {
        selectedEmojis.forEach { emoji in
            emojiArt.remove(emoji)
        }
        deselect()
    }
    
    func deselect() {
        selectedEmojis.removeAll()
    }
    
    func isSelected(_ emoji: EmojiArt.Emoji) -> Bool {
        selectedEmojis.contains(emoji)
    }
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func resizeEmoji(_ emoji: EmojiArt.Emoji, by scale : CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            let size = CGFloat(emojiArt.emojis[index].size)
            emojiArt.emojis[index].size = Int(size * scale)
        }
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
    var selectionSize: CGFloat { CGFloat(size) + 5.0}
}
