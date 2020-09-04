//
//  ThemeView.swift
//  Memorize
//
//  Created by Terry Dengis on 9/1/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
    @ObservedObject var emojiThemeStore: EmojiThemeStore
    
    @State private var editMode: EditMode = .inactive
    @State private var showEmojiEditor: Bool = false
    @State private var chosenThemeId: Int = 0
    
    var body: some View {
        NavigationView {
            List {
                ForEach (emojiThemeStore.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))){
                        HStack {
                            Image (systemName:"pencil.circle.fill")
                                .opacity(self.editMode.isEditing ? 1 : 0)
                                .animation(.linear(duration: 0.25))
                            .imageScale(.large)
                            .onTapGesture {
                                self.showEmojiEditor = true
                                self.chosenThemeId = theme.id
                            }
                            .sheet (isPresented: self.$showEmojiEditor) {
                                ThemeEditorView (chosenThemeId: self.$chosenThemeId)
                                    .environmentObject(self.emojiThemeStore)
                            }
                            VStack {
                                HStack {
                                    Text (theme.name)
                                        .font(.title)
                                    Spacer()
                                }
                                HStack {
                                    Text (theme.numberOfPairs == theme.emojis.count ? "All of" : "\(theme.numberOfPairs) of")
                                    Text (emojiString(from: theme.emojis))
                                    Spacer ()
                                }
                                .foregroundColor(.primary)
                                .font(.headline)
                            }
                        }
                        .foregroundColor(Color(theme.color))
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach {
                        self.emojiThemeStore.remove($0)
                    }
                }
            }
            .navigationBarTitle("Memorize")
            .navigationBarItems(leading: Button(action: {
                self.emojiThemeStore.newTheme()
                self.editMode = .active
            }, label: {
                Image(systemName: "plus").imageScale(.large)
                    
            }),
                trailing: EditButton()
            )
            .environment(\.editMode, $editMode)
        }
    }
}

private func  emojiString (from emojis: [String]) -> String {
    var returnValue: String = ""
    
    for emoji in emojis {
        returnValue += emoji
    }
    return returnValue
}

//struct ThemeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeView(emojiThemeStore: EmojiThemeStore())
//    }
//}
