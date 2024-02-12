//
//  RequestService.swift
//  DayPic
//
//  Created by Лилия Феодотова on 07.02.2024.
//

import Foundation

final class RequestService {
    private enum BaseUrls {
        static let baseUrl = "https://api.nasa.gov"
        static let searchUrl = "https://images-api.nasa.gov"
        //https://images-api.nasa.gov/search?q=moon
    }
    
    private enum Path {
        static let planetary = "/planetary"
        static let apod = "/apod"
        static let search = "/search"
        static let apiKey = "?api_key=DEMO_KEY"
    }
    
    private enum QueryParameters {
        static let apiKey = "?api_key=Ip7lWUQOx0q1762j2ZGpauUNW7fy51RCNkwO3DmK"
        static let count = "&count="
        static let freeText = "?q="
    }
    
    func getDayPic() -> URLRequest? {
        guard let url = URL(string: BaseUrls.baseUrl + Path.planetary + Path.apod + QueryParameters.apiKey) else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    func getArchPics() -> URLRequest? {
        guard let url = URL(string: BaseUrls.baseUrl + Path.planetary + Path.apod + QueryParameters.apiKey + QueryParameters.count + "20") else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    func getSearchReq(req: String) -> URLRequest? {
        guard let url = URL(string: BaseUrls.searchUrl + Path.search + QueryParameters.freeText + req) else { return nil }
        let request = URLRequest(url: url)
        return request
    }
}
