//
//  ThemeEditorView.swift
//  Memorize
//
//  Created by Terry Dengis on 9/2/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct ThemeEditorView: View {
    @EnvironmentObject var emojiThemeStore: EmojiThemeStore
    
    @Binding var chosenThemeId: Int
    
    @State private var themeName: String = ""
    @State private var emojiToAdd: String = ""
    @State private var emojis: [String] = [""]
    @State private var numberOfPairs: Int = 2
    @State private var maxPairs: Int = 2
    @State private var themeColor: UIColor.RGB = colorPalette[0]
    
    var body: some View {
        VStack {
            Text("Theme Editor")
                .font(.headline)
                .padding ()
            Divider()
            Form {
                Section {
                    TextField("Theme Name", text: $themeName, onEditingChanged: { began in
                        if !began {
                            self.emojiThemeStore.setName(self.themeName, forId: self.chosenThemeId)
                        }
                    })
                }
                Section (header: Text("Add Emoji")) {
                    TextField("", text: $emojiToAdd, onEditingChanged: { began in
                        if !began {
                            self.emojis = self.emojiThemeStore.addEmojis(self.emojiToAdd, forId: self.chosenThemeId)
                            self.maxPairs = self.emojis.count
                            self.emojiToAdd = ""
                        }
                        
                    })
                }
                //Section(header: Text("Emojis"), footer: Text("tap emoji to remove")) {
                Section(header: HStack { Text("Emojis"); Spacer (); Text("tap emoji to remove")}) {
                    Grid (emojis.map { String($0) }, id: \.self) { emoji in
                        Text (emoji)
                            .font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                if self.emojis.count > 2 {
                                    self.emojis = self.emojiThemeStore.removeEmoji(emoji, fromTheme: self.chosenThemeId)
                                    if self.numberOfPairs > self.emojis.count {
                                        self.emojiThemeStore.setNumberOfPairs (to: self.emojis.count, in: self.chosenThemeId)
                                        self.numberOfPairs = self.emojis.count
                        
                                    }
                                    self.maxPairs = self.emojis.count
                                }
                            }
                    }
                    .frame(height: self.height)
                }
                Section (header: Text("Card Count")) {
                    Stepper("\(numberOfPairs) Pairs", value: $numberOfPairs, in: 2...maxPairs) { began in
                        if !began {
                            self.emojiThemeStore.setNumberOfPairs (to: self.numberOfPairs, in: self.chosenThemeId)
                        }
                    }
                    
                }
                Section (header: Text("Color")) {

                    Grid(colorPalette, id: \.self) { color in
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color(color))
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.black)
                                .opacity(self.themeColor == color ? 1 : 0)
                        }
                        .onTapGesture {
                            self.emojiThemeStore.setColor(color, forId: self.chosenThemeId)
                            self.themeColor = color
                        }
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.vertical, 5)
                    }
                    .frame(height: self.colorHeight)
                }
            }
        }
        .onAppear {
            if let index = self.emojiThemeStore.indexWith(self.chosenThemeId) {
                let theme = self.emojiThemeStore.themes[index]
                self.themeName = theme.name
                self.numberOfPairs = theme.numberOfPairs
                self.emojis = theme.emojis
                self.maxPairs = theme.emojis.count
                self.themeColor = theme.color
            }
        }
    }
    
    // MARK: - Drawing Constants
    var height: CGFloat {
        CGFloat((emojis.count - 1) / 6 * 50 + 50)
    }
    var colorHeight: CGFloat {
        CGFloat((colorPalette.count - 1) / 6 * 50 + 50)
    }
    var fontSize: CGFloat = 40
}


//struct ThemeEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditorView()
//    }
//}
