//
//  FileDisplayView.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/23/25.
//

import SwiftUI
import PDFKit

struct FileDisplayView: View {
    let file: ManualItem.FileItem
    var body: some View {
        if let data = file.fileData, file.filename.lowercased().hasSuffix(".pdf") {
            PDFKitView(data: data)
                .navigationTitle(file.filename)
                .navigationBarTitleDisplayMode(.inline)
        } else if let data = file.fileData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .navigationTitle(file.filename)
        } else {
            Text("미리보기를 지원하지 않는 파일입니다.".localized)
                .navigationTitle(file.filename)
        }
    }
}

//#Preview {
//    FileDisplayView(file: <#T##ManualItem.FileItem#>)
//}

struct PDFKitView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document?.dataRepresentation() != data {
            uiView.document = PDFDocument(data: data)
        }
    }
}
