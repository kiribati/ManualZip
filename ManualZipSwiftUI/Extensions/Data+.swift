//
//  Data+.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/21/25.
//

import UIKit
import SwiftUI

extension Data {
    var toImage: Image? {
        guard let uiImage = UIImage(data: self) else { return nil }
        
        return Image(uiImage: uiImage)
    }
}
