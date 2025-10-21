//
//  Date+.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/21/25.
//

import Foundation

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
