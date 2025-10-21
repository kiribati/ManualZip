//
//  Array+.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/20/25.
//

import Foundation

extension Array {
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
    func safty(_ index: Int) -> Element? {
        if index < self.count, index >= 0 {
            return self[index]
        }
        return nil
    }
}
