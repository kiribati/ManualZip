//
//  DetailView.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/21/25.
//

import SwiftUI

struct DetailView: View {
    @State private var selectedImageIndexItem: ImageIndexItem? = nil
    @State private var showEditModal: Bool = false
    @Bindable var item: ManualItem
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Name & Date
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.name)
                                .font(.largeTitle).bold()
                            Text(item.createdAt.toString("yyyy.MM.dd"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Divider()
                        
                        // Images
                        if item.images.isNotEmpty {
                            Section(header: Text("이미지".localized).font(.headline)) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(item.images.indices, id: \.self) { index in
                                            if let data = item.images.safty(index), let image = UIImage(data: data) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 120, height: 120)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                                    )
                                                    .onTapGesture {
                                                        selectedImageIndexItem = ImageIndexItem(index: index)
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                            Divider()
                        }
                        
                        if item.links.isNotEmpty {
                            Section(header: Text("링크".localized).font(.headline)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(item.links, id: \.self) { link in
                                        if let url = URL(string: link) {
                                            Link(destination: url) {
                                                HStack(spacing: 8) {
                                                    Image(systemName: "link")
                                                    Text(link)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            Divider()
                        }
                        
                        if item.memo.isNotEmpty {
                            Section(header: Text("메모".localized).font(.headline)) {
                                Text(item.memo)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .padding(.top, 2)
                            }
                            Divider()
                        }
                        
                        if item.files.isNotEmpty {
                            Section(header: Text("File".localized).font(.headline)) {
                                VStack(alignment: .leading, spacing: 6) {
                                    ForEach(item.files, id: \.self) { file in
                                        NavigationLink(destination: FileDisplayView(file: file)) {
                                            Text(file.filename)
                                                .frame(minHeight: 24)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEditModal = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        })
        .sheet(item: $selectedImageIndexItem) { indexItem in
            NavigationStack {
                ImageViewer(imagesDatas: item.images, startIndex: indexItem.index)
            }
        }
        .sheet(isPresented: $showEditModal) {
            AddManualView(item: item)
        }
    }
}

extension DetailView {
    struct ImageIndexItem: Identifiable {
        let id: Int
        let index: Int
        
        init(index: Int) {
            self.id = index
            self.index = index
        }
    }
    
    private func load(manual id: UUID) {
        
    }
}


#Preview {
    DetailView(item: .init())
}

