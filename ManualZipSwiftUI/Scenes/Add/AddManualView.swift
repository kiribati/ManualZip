//
//  AddManualView.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI
import SwiftData

struct AddManualView: View {
    @StateObject private var viewModel = AddManualViewModel()
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhotos: [UIImage] = []
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker: Bool = false
    @State private var isShowingPhotoPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var inputedLink: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Add_Info".localized)) {
                    TextField("Add_ManualName".localized, text: $viewModel.name)
                        .autocorrectionDisabled(true)
                        .textContentType(.name)
                        .textInputAutocapitalization(.never)
                }
                
                imageSelectionSection
                
                linkSection
                
                memoSection
            }
            .navigationTitle("새 매뉴얼 추가".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소".localized) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장".localized) {
                        if viewModel.save(context: modelContext) {
                            dismiss()
                        }
                    }
                }
            }
            .onAppear {
                viewModel.checkClipboard()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                viewModel.checkClipboard()
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
            }
            .onChange(of: selectedImage) { _, newImage in
                if let image = newImage {
                    viewModel.addPhotos([image])
                    selectedImage = nil
                }
            }
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(images: $selectedPhotos)
            }
            .onChange(of: selectedPhotos) { _, newImages in
                viewModel.addPhotos(newImages)
                selectedPhotos.removeAll()
            }
        }
    }
    
    private var imageSelectionSection: some View {
        Section(header: Text("이미지".localized)) {
            VStack (spacing: 8) {
                HStack( spacing: 12) {
                    Button {
                        sourceType = .camera
                        isShowingImagePicker = true
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "camera")
                            Text("카메라".localized)
                        }
                    }
                    .buttonStyle(CardButtonStyle())

                    Button {
                        isShowingPhotoPicker = true
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: "photo")
                            Text("앨범".localized)
                        }
                    }
                    .buttonStyle(CardButtonStyle())
                }

                if viewModel.images.isNotEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.images.indices, id: \.self) { index in
                                let uiImage = viewModel.images[index]
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .background(Color(.black))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var linkSection: some View {
        Section(header: Text("링크".localized)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 4) {
                    TextField("Link".localized, text: $inputedLink)
                        .textContentType(.URL)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                        .padding(8)
                        .textFieldStyle(.roundedBorder)
                    
                    if inputedLink.isNotEmpty == true {
                        Button {
                            guard let url = URL(string: inputedLink) else { return }

                            viewModel.links.append(url)
                            inputedLink = ""
                        } label: {
                            Text("추가하기".localized)
                        }
                    }
                }

                if let link = viewModel.clipboardLink {
                    Button {
                        guard let url = URL(string: link) else { return }

                        viewModel.links.append(url)
                        viewModel.removeClipboard(link)

                    } label: {
                        Text("\(link) \n" + "붙여넣기".localized)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                }

                if viewModel.links.isNotEmpty {
                    ForEach(viewModel.links, id: \.absoluteString) { link in
                        VStack(spacing: 6) {
                            HStack(spacing: 4) {
                                Text(link.absoluteString)
                                    .frame(maxWidth: .infinity)
                                Button {
                                    viewModel.links.removeAll(where: { $0.absoluteString == link.absoluteString })
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var memoSection: some View {
        Section(header: Text("메모".localized)) {
            TextEditor(text: $viewModel.memo)
                .textContentType(.name)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .frame(minHeight: 120)
        }
    }
}

#Preview {
    AddManualView()
        .modelContainer(for: ManualItem.self, inMemory: true)
}

extension AddManualView {
    private struct CardButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(Color(.systemGroupedBackground))
                .foregroundColor(.primary)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
                .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}
