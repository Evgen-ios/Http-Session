//
//  URL+Extansion.swift
//  Http Session
//
//  Created by Evgeniy Goncharov on 09.11.2021.
//

import Foundation

// Make URL
extension URL {
    func withQueries(_ queries: [String : String]) -> URL?  {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components?.url
    }
}
