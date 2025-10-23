//
//  AddManualView.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import SwiftUI
import SwiftData
internal import UniformTypeIdentifiers

struct AddManualView: View {
    @StateObject private var viewModel: AddManualViewModel
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhotos: [UIImage] = []
    @State private var selectedImage: UIImage? = nil
    @State private var isShowingImagePicker: Bool = false
    @State private var isShowingPhotoPicker: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var inputedLink: String = ""
    @State private var isShowingFileImporter: Bool = false
    
    init() {
        self._viewModel = StateObject(wrappedValue: AddManualViewModel())
    }
    
    init(item: ManualItem) {
        self._viewModel = StateObject(wrappedValue: AddManualViewModel(item: item))
    }
    
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
                
                fileImportSection
            }
            .navigationTitle(viewModel.title)
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
                    viewModel.images.append(image)
                    selectedImage = nil
                }
            }
            .sheet(isPresented: $isShowingPhotoPicker) {
                PhotoPicker(images: $selectedPhotos)
            }
            .onChange(of: selectedPhotos) { _, newImages in
                for image in newImages {
                    selectedPhotos.removeAll(where: { $0.hashValue == image.hashValue })
                    viewModel.images.append(image)
                }
            }
            .fileImporter(isPresented: $isShowingFileImporter,
                          allowedContentTypes: [.pdf, .png, .gif, .jpeg],
                          allowsMultipleSelection: true) { result in
                handleFilesPick(result)
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

//  MARK: - Section View
extension AddManualView {
    private var imageSelectionSection: some View {
        Section(header: Text("이미지".localized)) {
            VStack (spacing: 14) {
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
                    Divider()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.images.indices, id: \.self) { index in
                                let uiImage = viewModel.images[index]
                                AddImageCell(uiImage: uiImage, index: index) { deleteIndex in
                                    viewModel.delete(image: deleteIndex)
                                }
                                .frame(height: 120)
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
                    VStack(spacing: 6) {
                        ForEach(viewModel.links, id: \.absoluteString) { link in
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
    
    private var fileImportSection: some View {
        Section(header: Text("파일 추가".localized)) {
            Button {
                isShowingFileImporter = true
            } label: {
                Text("File".localized)
            }
            
            ForEach(viewModel.files) { file in
                Text(file.filename)
                    .frame(maxWidth: .infinity)
            }
            .onDelete(perform: onDeleteFile(offsets:))
        }
    }
}

//  MARK: - Action
extension AddManualView {
    private func onDeleteFile(offsets: IndexSet) {
        for index in offsets {
            if let fileToDelete = viewModel.files.safty(index) {
                modelContext.delete(fileToDelete)
                viewModel.delete(file: index)
            }
        }
    }
    
    private func handleFilesPick(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            // 선택된 모든 URL에 대해 반복
            for url in urls {
                // 파일 데이터 접근 권한 시작
                guard url.startAccessingSecurityScopedResource() else {
                    print("Error: 보안 리소스 접근 실패 - \(url.lastPathComponent)")
                    continue // 다음 파일로 넘어감
                }
                
                do {
                    let fileData = try Data(contentsOf: url)
                    let filename = url.lastPathComponent
                    
                    // 새 FileItem 생성
                    let newFile = ManualItem.FileItem(filename: filename, fileData: fileData)
                    viewModel.files.append(newFile)
                } catch {
                    print("Error: 파일 데이터 읽기 실패 - \(error.localizedDescription)")
                }
                
                // 권한 해제
                url.stopAccessingSecurityScopedResource()
            }
        case .failure(let error):
            print("Error: 파일 선택 실패 - \(error.localizedDescription)")
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
