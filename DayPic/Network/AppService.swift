//
//  AppService.swift
//  DayPic
//
//  Created by Лилия Феодотова on 07.02.2024.
//

import Foundation

final class AppService {
    private let networkService = NetworkService()
    private let requestService = RequestService()
    
    func fetchDayPic(completion: @escaping (Result<DayPictureModel, NetworkError>) -> Void) {
        guard let request = requestService.getDayPic() else { completion(.failure(.badRequest))
            return }
        networkService.fetch(request: request, completion: completion)
    }
    
    func fetchArchPics(completion: @escaping (Result<[DayPictureModel], NetworkError>) -> Void) {
        guard let request = requestService.getArchPics() else { completion(.failure(.badRequest))
            return }
        networkService.fetch(request: request, completion: completion)
    }
    
    func fetchSearchPics(req: String, completion: @escaping (Result<SearchModel, NetworkError>) -> Void) {
        guard let request = requestService.getSearchReq(req: req) else { completion(.failure(.badRequest))
            return }
        networkService.fetch(request: request, completion: completion)
    }
}
