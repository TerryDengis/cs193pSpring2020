//
//  PaletteEditorView.swift
//  EmojiArt
//
//  Created by Terry Dengis on 8/30/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct PaletteEditorView: View {
    @EnvironmentObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    @State private var paletteName: String = ""
    @State private var emojiToAdd: String = ""
    
    var body: some View {
        VStack {
            Text("Palette Editor")
                .font(.headline)
                .padding()
            Divider()
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began {
                            self.document.renamePalette(self.chosenPalette, to: self.paletteName)
                        }
                    })
                    TextField("Add Emoji", text: $emojiToAdd, onEditingChanged: { began in
                        if !began {
                            self.chosenPalette = self.document.addEmoji(self.emojiToAdd, toPalette: self.chosenPalette)
                            self.emojiToAdd = ""
                        }
                    })
                }
                Section (header: Text("Remove Emoji")) {
                    Grid (chosenPalette.map { String($0) }, id: \.self) { emoji in
                        Text (emoji)
                            .font(Font.system(size: self.fontSize))
                            .onTapGesture {
                                self.chosenPalette = self.document.removeEmoji(emoji, fromPalette: self.chosenPalette)
                        }
                    }
                    .frame(height: self.height)
                }
            }
        }
        .onAppear{ self.paletteName =  self.document.paletteNames[self.chosenPalette] ?? "" }
    }
    
    // MARK: - Drawing Constants
    var height: CGFloat {
        CGFloat((chosenPalette.count - 1) / 6 * 70 + 70)
    }
    var fontSize: CGFloat = 40
}

//struct PaletteEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaletteEditorView()
//    }
//}
