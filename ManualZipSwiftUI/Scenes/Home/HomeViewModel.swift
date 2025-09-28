//
//  HomeViewModel.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var items: [HomeItem] = []
    init() {
        loadDatas()
    }
}

extension HomeViewModel {
    private func loadDatas() {
        
    }
}

struct HomeItem {
    
}
