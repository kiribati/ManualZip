//
//  DetailViewModel.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/21/25.
//

import Combine
import SwiftData
//
//@MainActor
//final class DetailViewModel: ObservableObject {
//    @Published var name: String = ""
//    @Published var item: ManualItem
//    
//    init(parameter: Parameter) {
//        self.item = parameter.item
//    }
//}
//
//extension DetailViewModel {
//    struct Parameter {
//        let item: ManualItem
//    }
//}
//
//final class ViewUpdater: ObservableObject {
//    // 💡 이 Published 속성이 변경될 때마다 이 객체를 참조하는 뷰가 갱신됩니다.
//    @Published var shouldUpdate = false
//
//    // 화면 갱신을 트리거하는 함수
//    func triggerUpdate() {
//        // 속성 값을 토글하여 변경을 알립니다.
//        self.shouldUpdate.toggle()
//    }
//}
