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
    @Published var title: String = ""
    private var editedItem: ManualItem?
    
    deinit {
        print("\(Self.self) deinited")
    }
    
    init() {
        title = "새 매뉴얼 추가".localized
    }
    
    init(item: ManualItem) {
        self.editedItem = item
        
        self.name = item.name
        self.images = item.images.compactMap{ UIImage(data: $0) }
        self.links = item.links.compactMap{ URL(string: $0) }
        self.memo = item.memo
        
        title = "EditManual".localized
    }
    
    // 저장 로직을 담당하는 함수
    // View로부터 ModelContext를 받아와서 데이터를 저장합니다.
    // -> 이렇게 하면 ViewModel이 특정 View나 데이터베이스 기술에 덜 종속되어 테스트하기 용이해집니다.
    func save(context: ModelContext) -> Bool {
        if let editedItem {
            return save(edit: editedItem, with: context)
        } else {
            return save(insert: context)
        }
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

extension AddManualViewModel {
    private func save(insert context: ModelContext) -> Bool {
        // 간단한 유효성 검사: 이름이 비어있으면 저장하지 않음
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("신규 저장 실패 - 이름이 없어요")
            return false
        }
        
        let linkList = links.map { $0.absoluteString }
        let imageDataList = images.compactMap { $0.pngData() }
        let newManual = ManualItem(name: name, links: linkList, images: imageDataList, memo: memo)
        
        context.insert(newManual)
        
        print("신규 저장 성공")
        return true
    }
    
    private func save(edit item: ManualItem, with context: ModelContext) -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("수정 저장 실패 - 이름이 없어요")
            return false
        }
        
        do {
            item.name = name
            item.images = images.compactMap { $0.pngData() }
            item.links = links.map { $0.absoluteString }
            item.memo = memo
            
            try context.save()
            print("수정 저장 성공")
            return true
        } catch {
            print("수정 저장 실패")
            return false
        }
    }
}

