//
//  ManualItem.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import Foundation
import SwiftData

@Model
final class ManualItem {
    // UUID를 사용하여 각 항목을 고유하게 식별합니다.
    @Attribute(.unique) var id: UUID
    var name: String
    var createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}
