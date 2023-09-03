//
//  APIManager.swift
//  krk-iOS
//
//  Created by John Patrick Teruel on 9/1/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    // Add more error cases as needed
}

protocol APIManager {
    var encoder: JSONEncoder { get }
    var decoder: JSONDecoder { get }
    
    func makeRequest<T: Codable>(
        path: APIPath,
        method: APIMethods,
        headers: [String: String]?,
        urlParams: [String: String]?,
        body: Data?
    ) async throws -> T
}

extension APIManager {
    func getRequest<T: Codable>(path: APIPath, urlParams: [String: String]? = nil) async throws -> T {
        return try await makeRequest(
            path: path,
            method: .get,
            headers: nil,
            urlParams: urlParams,
            body: nil
        )
    }
    
    func postRequest<P: Codable, T: Codable>(path: APIPath, body: P?) async throws -> T {
        let body: Data? = try body.map { try encoder.encode($0) }
        return try await makeRequest(
            path: path,
            method: .post,
            headers: nil,
            urlParams: nil,
            body: body
        )
    }
    
    
    
    func makeRequest<T: Codable>(path: APIPath) async throws -> T {
        return try await makeRequest(
            path: path,
            method: .get,
            headers: nil,
            urlParams: nil,
            body: nil
        )
    }
    
    func makeRequest<P: Codable, T: Codable>(path: APIPath, body: P) async throws -> T {
        let body = try encoder.encode(body)
        return try await makeRequest(
            path: path,
            method: .post,
            headers: nil,
            urlParams: nil,
            body: body
        )
    }
}

class DefaultAPIManager: APIManager {
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init(encoder: JSONEncoder, decoder: JSONDecoder) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    private var baseURL: String = "http://localhost:3000"
  
    func setBaseURL(_ url: String) throws {
        guard let _ = URL(string: url) else {
            throw APIError.invalidURL
        }
        baseURL = url
    }
  
    func getBaseURL() throws -> String {
        guard let _ = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        return baseURL
    }
    
    func makeRequest<T: Codable>(
        path: APIPath,
        method: APIMethods,
        headers: [String: String]? = nil,
        urlParams: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> T {
        let baseURL = try getBaseURL()
        guard let url = URL(string: baseURL + "/" + path.rawValue) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let urlParams = urlParams {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
            request.url = components?.url
        }
        
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw APIError.requestFailed(error)
        }
    }
}

enum APIPath: String {
    case songs
    case reserve
}

enum APIMethods: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}
