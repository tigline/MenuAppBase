//
//  URL+QueryItem.swift
//  SmartWe
//
//  Created by Aaron Hou on 2024/02/06.
//

import Foundation

extension URL {

    func appendingPathComponent(_ value: Int) -> Self {
        appendingPathComponent(String(value))
    }

    func appendingQueryItem(name: String, value: CustomStringConvertible) -> Self {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value.description))
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }

}

extension URL {
    
    private enum QueryItemName {
        static let apiKey = "api_key"
        static let language = "language"
        static let imageLanguage = "include_image_language"
        static let videoLanguage = "include_video_language"
        static let page = "page"
        static let year = "year"
        static let firstAirDateYear = "first_air_date_year"
        static let withPeople = "with_people"
        static let withGenre = "with_genres"
        static let includeAdult = "include_adult"
    }
    
    func appendingAPIKey(_ apiKey: String) -> Self {
        appendingQueryItem(name: QueryItemName.apiKey, value: apiKey)
    }
    
    func appendingLanguage(locale: Locale = .current) -> Self {
        guard let languageCode = locale.language.languageCode?.identifier else {
            return self
        }
        
        return appendingQueryItem(name: QueryItemName.language, value: languageCode)
    }
}
