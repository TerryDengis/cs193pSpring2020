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
    @ObservedObject var document: EmojiArtDocument
    
    // Pinch Gesture Zoom

    @GestureState private var gestureZoomScale: CGFloat = 1.0
    private var zoomScale: CGFloat {
        document.steadyStateZoomScale * gestureZoomScale
    }
    
    // Pinch Resize Zoom
    @GestureState private var gestureSizeScale: CGFloat = 1.0

    // Drag Gesture Pan

    @GestureState private var gesturePanOffset: CGSize = .zero
    private var panOffset: CGSize {

         return (document.steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    // Drag Gesture Move
    @GestureState private var gestureMoveOffset: CGSize = .zero
    private var moveOffset: CGSize {
        gestureMoveOffset * zoomScale
    }
    
    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    
    @State private var chosenPalette: String = ""
    
    var body: some View {
        VStack {
            HStack {
                PaletteChooser (document: document, chosenPalette: $chosenPalette)
                ScrollView (.horizontal) {
                    HStack {
                        ForEach (chosenPalette.map {String($0)}, id: \.self) { emoji in
                            Text (emoji)
                                .font(Font.system(size: defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString)}
                        }
                    }
                }
                .onAppear { self.chosenPalette = self.document.defaultPalette }
            }
            
            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImageView(uiImage: self.document.backgroundImage)
                            .scaleEffect(self.zoomScale)
                            .offset(self.panOffset)
                    )
                    .gesture(self.tapCanvas(in: geometry.size))
                    
                    if self.isLoading {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                            .spinning()
                    } else {
                        ForEach (self.document.emojis) { emoji in
                            Text(emoji.text)
                                .background(Rectangle().fill(Color.gray).opacity(self.document.isSelected(emoji) ? 1 : 0))
                                .font(animatableWithSize: self.document.isSelected(emoji) ? emoji.fontSize * self.zoomScale * self.gestureSizeScale : emoji.fontSize * self.zoomScale)
                                .position(self.position(for: emoji, in: geometry.size))
                                
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.5)) {
                                        self.document.select(emoji)
                                    }
                            }
                            .offset(self.document.isSelected(emoji) ? self.moveOffset : CGSize.zero)
                        }
                    }
                } // ZStack
                
                .clipped()
                .gesture(self.draggingGesture())
                .gesture(self.pinchGesture())
                .onLongPressGesture {
                    withAnimation (.linear(duration: 1.0)) {
                        self.document.remove()
                    }
                }
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onReceive(self.document.$backgroundImage) { image in
                    self.zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    // TODO: - the location on drop is not working properly

                    var location = geometry.convert(location, from: .local)
                    print (location)
                    print (geometry.size)
                    // convert from apple coordinates to Cartesian coordinate system
                    location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    location = CGPoint(x: location.x - self.panOffset.width, y: location.y - self.panOffset.height)
                    location = CGPoint(x: location.x / self.zoomScale, y: location.y / self.zoomScale)
                    
                    return self.drop(providers: providers, at: location)
                }
            .navigationBarItems(trailing: Button(action: {
                if let url = UIPasteboard.general.url, url != self.document.backgroundURL {
                    self.confirmBackgroundPaste = true
                } else {
                    self.explainBackgroundPaste = true
                }
            }, label: {
                Image(systemName: "doc.on.clipboard").imageScale(.large)
                    .alert(isPresented: self.$explainBackgroundPaste) {
                        return Alert(
                            title: Text("Paste Background"),
                            message: Text("Copy the URL of an image to the clip board and touch this button to make it the background of the document"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }))
            } // Geometry Reader
            .zIndex(-1)
        } // VStack
            .alert(isPresented: self.$confirmBackgroundPaste) {
                return Alert(
                    title: Text("Paste Background"),
                    message: Text("Replace your background with \(UIPasteboard.general.url?.absoluteString ?? "nothing")?"),
                    primaryButton: .default(Text("OK")) {
                        self.document.backgroundURL = UIPasteboard.general.url
                    },
                    secondaryButton: .cancel()
                )
        }
    }

    @State private var explainBackgroundPaste: Bool = false
    @State private var confirmBackgroundPaste: Bool = false
    
    private func sizeFor(_ emoji: EmojiArt.Emoji) -> CGFloat{
        document.isSelected(emoji) ? emoji.selectionSize * zoomScale  * gestureSizeScale : emoji.selectionSize * zoomScale
    }
    
    private func draggingGesture () -> some Gesture {
        if document.selectedEmojis.count == 0 {
            return
                // Pan Gesture
                DragGesture ()
                    .updating($gesturePanOffset) {
                        latestDragGestureValue, gesturePanOffset, transaction in
                        gesturePanOffset = latestDragGestureValue.translation / self.zoomScale
                }
                .onEnded { finalDragGestureValue in
                    self.document.steadyStatePanOffset = self.document.steadyStatePanOffset + (finalDragGestureValue.translation / self.zoomScale)

            }
        }
        return
            // Move Gesture
            DragGesture ()
            .updating($gestureMoveOffset) { latestDragGestureValue, gestureMoveOffset, transaction in
                gestureMoveOffset = latestDragGestureValue.translation / self.zoomScale
            }
            .onEnded { finalDragGestureValue in
                self.document.moveSelection(finalDragGestureValue.translation / self.zoomScale)
        }
    }
    
    private func pinchGesture () -> some Gesture {
        if document.selectedEmojis.count == 0 {
            // Zoom Gesture
            return
                MagnificationGesture()
                    .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
                        gestureZoomScale = latestGestureScale
                }
                .onEnded { finalGestureScale in
                    self.document.steadyStateZoomScale = finalGestureScale
            }
        }
        
        // Resize Gesture
        return
            MagnificationGesture()
                .updating($gestureSizeScale) { latestGestureScale, gestureSizeScale, transaction in
                    gestureSizeScale = latestGestureScale
            }
            .onEnded { finalGestureScale in
                self.document.resizeSelection(finalGestureScale)
        }
    }
    
    private func tapCanvas(in size: CGSize) -> some Gesture {
        // Bring background image to the right size - by double click
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    self.zoomToFit(self.document.backgroundImage, in: size)
                }
            }
            .exclusively (before:
                // remove all selected emojis by single clicking
                TapGesture(count: 1)
                    .onEnded {
                        
                        withAnimation {
                            self.document.deselect()
                        }
                    }
                )
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.height > 0, size.width > 0 {
            let hzoom = size.width / image.size.width
            let vzoom = size.height / image.size.height
            document.steadyStatePanOffset = .zero
            document.steadyStateZoomScale = min(hzoom, vzoom)
        }
    }
    
    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        // convert from Cartesian coordinate system to apple coordinate system
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint (x: location.x + size.width/2, y: location.y + size.height/2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        
        return location
    }
    
    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadObjects(ofType: URL.self) { url in
            self.document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                self.document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        
        return found
    }
}

struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = EmojiArtDocument()
        return EmojiArtDocumentView (document: vm)
    }
}
