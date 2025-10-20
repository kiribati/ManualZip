//
//  AddManualViewModel.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import Combine
import SwiftData
import UIKit

// SwiftUI View와 데이터를 주고받기 위해 ObservableObject를 채택합니다.
@MainActor
class AddManualViewModel: ObservableObject {
    
    @Published var board: String?
    
    // View의 TextField와 바인딩될 변수. @Published를 통해 변경사항이 View에 즉시 반영됩니다.
    @Published var name: String = ""
    
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
        
        // 새로운 Manual 객체 생성
        let newManual = ManualItem(name: name)
        
        // ModelContext에 객체 삽입 (데이터베이스에 추가)
        context.insert(newManual)
        
        return true
    }
    
    func checkClipboard() {
//        guard let board = UIPasteboard.general.string else { return nil }
//        return board
    }
}
