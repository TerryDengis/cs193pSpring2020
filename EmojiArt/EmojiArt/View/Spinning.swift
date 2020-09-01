//
//  Spinning.swift
//  EmojiArt
//
//  Created by Terry Dengis on 8/29/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State var isVisible: Bool = false
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear { self.isVisible = true }
    }
}

extension View {
    func spinning() -> some View {
        self.modifier(Spinning())
    }
}
