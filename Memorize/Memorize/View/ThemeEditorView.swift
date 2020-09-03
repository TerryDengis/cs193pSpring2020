//
//  ThemeEditorView.swift
//  Memorize
//
//  Created by Terry Dengis on 9/2/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct ThemeEditorView: View {
    //@EnvironmentObject var themeStore: EmojiThemeStore
    
    @State private var themeName: String = ""
    @State private var emojiToAdd: String = ""
    
    var body: some View {
        VStack {
            Spacer ()
            Text("Theme Editor")
                .font(.headline)
                .padding ()
            Divider()
            Form {
                Section {
                    TextField("Theme Name", text: $themeName, onEditingChanged: { began in
                        
                    })
                }
                Section (header: Text("Add Emoji")) {
                    TextField("Add Emoji", text: $emojiToAdd, onEditingChanged: { began in
                        
                    })
                }
                Section (header: Text("Emojis")) {
                    TextField("Emojis", text: $themeName, onEditingChanged: { began in
                        
                    })

                }
                Section (header: Text("Card Count")) {
                    Stepper("Pairs", onIncrement: {}, onDecrement: {})
                }
                Section (header: Text("Color")) {
                    TextField("Color", text: $themeName, onEditingChanged: { began in
                        
                    })
                }
            }
        }
    }
}

//struct ThemeEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditorView()
//    }
//}
