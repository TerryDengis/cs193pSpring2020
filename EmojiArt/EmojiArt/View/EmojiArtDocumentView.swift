//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Terry Dengis on 8/24/20.
//  Copyright © 2020 Terry Dengis. All rights reserved.
//

import SwiftUI

// MARK: - UI Constansts
private let defaultEmojiSize: CGFloat = 40

struct EmojiArtDocumentView: View {
    @ObservedObject var documentVM: EmojiArtDocumentVM
    
    // Pinch Gesture Zoom
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    // Pinch Resize Zoom
    @GestureState private var gestureSizeScale: CGFloat = 1.0

    // Drag Gesture Pan
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    // Drag Gesture Move
    @GestureState private var gestureMoveOffset: CGSize = .zero
    private var moveOffset: CGSize {
        gestureMoveOffset * zoomScale
    }
    
    var body: some View {
        VStack {
            ScrollView (.horizontal) {
                HStack {
                    ForEach (EmojiArtDocumentVM.palette.map {String($0)}, id: \.self) { emoji in
                        Text (emoji)
                            .font(Font.system(size: defaultEmojiSize))
                            .onDrag { NSItemProvider(object: emoji as NSString)}
                    }
                }
            }
            .padding(.horizontal)
            
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImageView(uiImage: self.documentVM.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                    .gesture(self.tapCanvas(in: geometry.size))
                    
                    ForEach (self.documentVM.emojis) { emoji in
                        ZStack {
                            Circle ()
                                .fill(Color.red)
                                .frame(
                                    width: self.sizeFor(emoji),
                                    height: self.sizeFor(emoji),
                                    alignment: .center)
                                .position(self.position(for: emoji, in: geometry.size))
                                .opacity(self.documentVM.isSelected(emoji) ? 1 : 0)
                            Text(emoji.text)
                                .font(animatableWithSize: self.documentVM.isSelected(emoji) ? emoji.fontSize * self.zoomScale * self.gestureSizeScale : emoji.fontSize * self.zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.5)) {
                                        self.documentVM.select(emoji)
                                    }
                            }
                        }
                        .offset(self.documentVM.isSelected(emoji) ? self.moveOffset : CGSize.zero)
                    }
                }
                .clipped()
                .gesture(self.draggingGesture())
                .gesture(self.pinchGesture())
                .onLongPressGesture {
                    withAnimation (.linear(duration: 3.0)) {
                        self.documentVM.remove()
                    }
                }
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = geometry.convert(location, from: .global)
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }

    private func sizeFor(_ emoji: EmojiArt.Emoji) -> CGFloat{
        documentVM.isSelected(emoji) ? emoji.selectionSize * zoomScale  * gestureSizeScale : emoji.selectionSize * zoomScale
    }
    
    private func draggingGesture () -> some Gesture {
        if documentVM.selectedEmojis.count == 0 {
            return
                // Pan Gesture
                DragGesture ()
                    .updating($gesturePanOffset) {
                        latestDragGestureValue, gesturePanOffset, transaction in
                        gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
                }
                .onEnded { finalDragGestureValue in
                    self.steadyStatePanOffset = self.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)
            }
        }
        return
            // Move Gesture
            DragGesture ()
            .updating($gestureMoveOffset) { latestDragGestureValue, gestureMoveOffset, transaction in
                gestureMoveOffset = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded { finalDragGestureValue in
                self.documentVM.moveSelection(finalDragGestureValue.translation / self.zoomScale)
        }
    }
    
    private func pinchGesture () -> some Gesture {
        if documentVM.selectedEmojis.count == 0 {
            // Zoom Gesture
            return
                MagnificationGesture()
                    .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                        gestureZoomScale = latestGestureScale
                }
                .onEnded { finalGestureScale in
                    self.steadyStateZoomScale = finalGestureScale
            }
        }
        
        // Resize Gesture
        return
            MagnificationGesture()
                .updating($gestureSizeScale) { latestGestureScale, gestureSizeScale, transaction in
                    gestureSizeScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                self.documentVM.resizeSelection(finalGestureScale)
        }
    }
    
    private func tapCanvas(in size: CGSize) -> some Gesture {
        // Bring background image to the right size - by double click
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.documentVM.backgroundImage, in: size)
                }
            }
            .exclusively (before:
                // remove all selected emojis by single clicking
                TapGesture(count: 1)
                    .onEnded {
                        
                        withAnimation {
                            self.documentVM.deselect()
                        }
                    }
                )
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hzoom = size.width / image.size.width
            let vzoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hzoom, vzoom)
        }
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint (x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)

        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            self.documentVM.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.documentVM.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        
        return found
    }
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = EmojiArtDocumentVM()
        return EmojiArtDocumentView (documentVM: vm)
    }
}
