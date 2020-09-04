//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Terry Dengis on 8/29/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct PaletteChooser: View {
    @ObservedObject var document: EmojiArtDocument
    
    @Binding var chosenPalette: String
    @State private var showPaletteEditor: Bool = false
    
    var body: some View {
        HStack {
            Stepper(onIncrement: {self.chosenPalette = self.document.palette(after: self.chosenPalette)}, onDecrement: {self.chosenPalette = self.document.palette(before: self.chosenPalette)}, label: { EmptyView ()})
            Text (self.document.paletteNames[self.chosenPalette] ?? "")
            Image(systemName: "keyboard").imageScale(.large)
                .onTapGesture {
                    self.showPaletteEditor = true
                }
            .popover(isPresented: self.$showPaletteEditor) {
                PaletteEditorView(chosenPalette: self.$chosenPalette)
                    .environmentObject(self.document)
                    .frame(minWidth: 300, minHeight: 500)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChooser(document: EmojiArtDocument(), chosenPalette: Binding.constant(""))
    }
}
