//
//  DetailView.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/21/25.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @State private var selectedImageIndexItem: ImageIndexItem? = nil
    @State private var showEditModal: Bool = false
    
    init(viewModel: DetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Name & Date
                        VStack(alignment: .leading, spacing: 6) {
                            Text(viewModel.item.name)
                                .font(.largeTitle).bold()
                            Text(viewModel.item.createdAt.toString("yyyy.MM.dd"))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Divider()
                        
                        // Images
                        if viewModel.item.images.isNotEmpty {
                            Section(header: Text("이미지".localized).font(.headline)) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        ForEach(viewModel.item.images.indices, id: \.self) { index in
                                            if let data = viewModel.item.images.safty(index), let image = UIImage(data: data) {
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
                        
                        if viewModel.item.links.isNotEmpty {
                            Section(header: Text("링크".localized).font(.headline)) {
                                VStack(alignment: .leading, spacing: 10) {
                                    ForEach(viewModel.item.links, id: \.self) { link in
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
                        
                        if viewModel.item.memo.isNotEmpty {
                            Section(header: Text("메모".localized).font(.headline)) {
                                Text(viewModel.item.memo)
                                    .font(.body)
                                    .foregroundStyle(.primary)
                                    .padding(.top, 2)
                            }
                            Divider()
                        }
                    }
                }
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: "pencil")
                }
            }
        })
        .sheet(item: $selectedImageIndexItem) { item in
            NavigationStack {
                ImageViewer(imagesDatas: viewModel.item.images, startIndex: item.index)
            }
        }
        .sheet(isPresented: $showEditModal) {
            AddManualView()
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
}


#Preview {
    DetailView(viewModel: .init(parameter: .init(item: .init())))
}

