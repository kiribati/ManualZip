//
//  AddManualViewModel.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import Combine
import SwiftData
import UIKit
import SwiftUI

@MainActor
final class AddManualViewModel: ObservableObject {
    @Published var clipboardLink: String?
    @Published var name: String = ""
    @Published var images: [UIImage] = []
    @Published var links: [URL] = []
    @Published var memo: String = ""
    
    deinit {
        print("\(Self.self) deinited")
    }
    
    init() {
        
    }
    
    // 저장 로직을 담당하는 함수
    // View로부터 ModelContext를 받아와서 데이터를 저장합니다.
    // -> 이렇게 하면 ViewModel이 특정 View나 데이터베이스 기술에 덜 종속되어 테스트하기 용이해집니다.
    func save(context: ModelContext) -> Bool {
        // 간단한 유효성 검사: 이름이 비어있으면 저장하지 않음
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        let linkList = links.map { $0.absoluteString }
        let imageDataList = images.compactMap { $0.pngData() }
        let newManual = ManualItem(name: name, links: linkList, images: imageDataList, memo: memo)
        
        context.insert(newManual)
        
        return true
    }
    
    func checkClipboard() {
        guard let currentClipboardLink = UIPasteboard.general.url else { return }
        
        clipboardLink = currentClipboardLink.absoluteString
    }
    
    func removeClipboard(_ target: String) {
        UIPasteboard.general.string = nil
    }
    
    func delete(image index: Int) {
        images.remove(at: index)
    }
}

