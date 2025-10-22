//
//  ImageViewer.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/21/25.
//

import SwiftUI

struct ImageViewer: View {
    @Environment(\.dismiss) var dismiss
    
    private let images: [Image]
    private let datas: [Data]
    @State private var currentIndex: Int

    init(imagesDatas: [Data], startIndex: Int) {
        self.datas = imagesDatas
        self.images = imagesDatas.compactMap{ $0.toImage }
        self._currentIndex = State(initialValue: startIndex)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TabView(selection: $currentIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        if let image = images.safty(index) {
                            ZoomableImage(image: image)
                                .tag(index)
                        } else {
                            Text("이미지 로드 실패".localized).foregroundColor(.white)
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .background(Color.black)
                .edgesIgnoringSafeArea(.horizontal)
                .contentShape(Rectangle())
                
                thumbnailListView
                    .padding(.vertical, 8)
                    .background(Color(UIColor.systemBackground))
            }
            .background(Color.black.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(Color.white)
                    }
                    
                    .foregroundColor(.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        save()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .tint(Color.white)
                    }
                }
            }
        }
    }
    
    private var thumbnailListView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(images.indices, id: \.self) { index in
                        if let image = images.safty(index) {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(currentIndex == index ? Color.blue : Color.gray.opacity(0.5), lineWidth: 2)
                                )
                                .onTapGesture {
                                    currentIndex = index
                                }
                                .id(index)
                        }
                    }
                }
                .padding(.horizontal)
                .onChange(of: currentIndex) { oldIndex, newIndex in
                    withAnimation {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
        }
    }
    
    private func save() {
        guard let currentData = datas.safty(currentIndex), let currentUIImage = UIImage(data: currentData) else { return }
        
        ImageSaver().writeToPhotoAlbum(image: currentUIImage)
    }
}

extension ImageViewer {
    struct ZoomableImage: View {
        let image: Image
        private let minScale: CGFloat = 1.0
        private let maxScale: CGFloat = 3.0
        
        @State private var scale: CGFloat = 1.0
        @State private var lastScale: CGFloat = 1.0
        
        var body: some View {
            ScrollView([.horizontal, .vertical]) {
                image
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal)
                    .containerRelativeFrame(.vertical)
                    .scaleEffect(scale)
            }
            .scrollDisabled(scale == minScale)
            .background(Color.black.ignoresSafeArea())
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let delta = value / lastScale
                        let newScale = min(max(scale * delta, minScale), maxScale)
                        scale = newScale
                        lastScale = value
                    }
                    .onEnded { value in
                        lastScale = 1.0
                        withAnimation(.spring) {
                            scale = min(max(scale, minScale), maxScale)
                        }
                    }
            )
            .onTapGesture(count: 2) {
                withAnimation(.spring) {
                    scale = scale > minScale ? minScale : 2.0
                }
            }
            .onAppear {
                scale = minScale
            }
        }
    }
}
