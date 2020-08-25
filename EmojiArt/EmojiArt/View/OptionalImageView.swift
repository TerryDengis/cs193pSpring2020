//
//  OptionalImageView.swift
//  EmojiArt
//
//  Created by Terry Dengis on 8/25/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

struct OptionalImageView: View {
    var uiImage: UIImage?
    
    var body: some View {
        Group {
            if uiImage != nil {
                Image (uiImage: uiImage!)
            }
        }
    }
}
