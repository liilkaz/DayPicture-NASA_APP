//
//  NetworkService.swift
//  DayPic
//
//  Created by Лилия Феодотова on 06.02.2024.
//

import Foundation

enum NetworkError: Int, Error {
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case serverError = 500
    case decodeError = 1000
    case noData = 1500
    case unowned = 2000
}

final class NetworkService {
    
    func fetch<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(.unowned))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let value = try decoder.decode(T.self, from: data)
                        completion(.success(value))
                    } catch {
                        completion(.failure(.decodeError))
                    }
                case 404:
                    completion(.failure(.notFound))
                case 500:
                    completion(.failure(.serverError))
                default:
                    assertionFailure()
                    completion(.failure(.unowned))
                }
            }
        }
        dataTask.resume()
    }
}
