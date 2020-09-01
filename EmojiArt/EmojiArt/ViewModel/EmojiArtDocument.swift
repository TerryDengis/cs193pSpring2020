//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Terry Dengis on 8/24/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable {
    var id: UUID
    
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash (into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @Published private var emojiArt: EmojiArt
    @Published private (set) var backgroundImage: UIImage?
    @Published private (set) var selectedEmojis: Set<EmojiArt.Emoji>
    @Published var steadyStateZoomScale: CGFloat = 1.0
    @Published var steadyStatePanOffset: CGSize = .zero
    
    private var autosaveCancellable: AnyCancellable?
    private var fetchImageCancellable: AnyCancellable?
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis}
    
    init (id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultKey)) ?? EmojiArt ()
        selectedEmojis = Set()
        
        autosaveCancellable = $emojiArt.sink { emojiArt in
            UserDefaults.standard.set(emojiArt.json, forKey:defaultKey)
        }
        fetchBackgroundImageData()
    }
    
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
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = self.emojiArt.backgroundURL {
            fetchImageCancellable?.cancel() // just in case there is already a fetch happening
//            let session = URLSession.shared
//            let publisher = session
//                .dataTaskPublisher(for: url)
//                .map { data, urlResponse in UIImage(data: data)}
//                .receive(on: DispatchQueue.main)
//                .replaceError(with: nil)
//            fetchImageCancellable = publisher.assign(to: \.backgroundImage, on: self)
            fetchImageCancellable = URLSession.shared
                .dataTaskPublisher(for: url)
                .map { data, urlResponse in UIImage(data: data)}
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .assign(to: \.backgroundImage, on: self)
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
    var selectionSize: CGFloat { CGFloat(size) + 5.0}
}
