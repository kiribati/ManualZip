//
//  DetailViewModel.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/21/25.
//

import Combine
import SwiftData

@MainActor
final class DetailViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var item: ManualItem
    
    init(parameter: Parameter) {
        self.item = parameter.item
    }
}

extension DetailViewModel {
    struct Parameter {
        let item: ManualItem
    }
}
