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
    var links: [String]
    var images: [Data]
    var memo: String
    
    init() {
        self.id = UUID()
        self.name = ""
        self.createdAt = Date()
        self.links = []
        self.images = []
        self.memo = ""
    }
    
    init(name: String, links: [String], images: [Data], memo: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
        self.links = links
        self.images = images
        self.memo = memo
    }
}
