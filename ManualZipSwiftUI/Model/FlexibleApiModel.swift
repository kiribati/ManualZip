//
//  FlexibleApiModel.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import Foundation

struct FlexibleApiModel<T: Decodable> {
    let result: Bool
    let data: T?
    let errorMessage: String
}

extension FlexibleApiModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case data
        case result
        case errorMessage
    }
    
    init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<FlexibleApiModel<T>.CodingKeys> = try decoder.container(keyedBy: FlexibleApiModel<T>.CodingKeys.self)
        self.data = try container.decode(T.self, forKey: FlexibleApiModel<T>.CodingKeys.data)
        self.result = (try? container.decode(Bool.self, forKey: .result)) ?? false
        self.errorMessage = (try? container.decode(String.self, forKey: .errorMessage)) ?? ""
    }
}
