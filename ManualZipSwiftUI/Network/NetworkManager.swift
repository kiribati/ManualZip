//
//  NetworkManager.swift
//  ManualZipSwiftUI
//
//  Created by hongdae on 9/28/25.
//

import Foundation


// 1. 네트워크 에러 정의
enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

// 2. 네트워크 모듈 싱글턴
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    /// GET 요청 + 제네릭 디코딩
    @discardableResult
    func get<T: Decodable>(_ urlString: String, parameters: [String: Any]?) async throws -> T {
        guard var url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        let queries = parameters?.map { URLQueryItem(name: $0.key, value: $0.value as? String)} ?? []
        url = url.appending(queryItems: queries)

        defer {
            print("=============================================")
        }
        do {
            print("================ URL Request ================")
            print("url = \(url)")
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("NetworkError.invalidResponse url = \(url)")
                throw NetworkError.invalidResponse
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                print("decodingFailed url = \(url)")
                throw NetworkError.decodingFailed(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }

    /// POST 요청 (body: Encodable)
    @discardableResult
    func post<T: Decodable, U: Encodable>(
        _ urlString: String,
        body: U,
        headers: [String: String] = [:]
    ) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        defer {
            print("=============================================")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = try JSONEncoder().encode(body)

        do {
            print("================ URL Request ================")
            print("url = \(url)")
            print("body = \(body)")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("NetworkError.invalidResponse url = \(url)")
                print("response = \(response)")
                throw NetworkError.invalidResponse
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                print("decodingFailed url = \(url)")
                throw NetworkError.decodingFailed(error)
            }
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

