//
//  NetworkRequest.swift
//  BBJobTestTask
//
//  Created by Maksym Sabadyshyn on 7/16/20.
//  Copyright © 2020 Maksym Sabadyshyn. All rights reserved.
//

import Foundation

struct NetworkRequest {
    static func getData(from url: String, completion: @escaping (Data?, NetworkError?) -> Void) {

        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { data, response, _ in
                if let data = data {
                    do {
                        completion(data, nil)
                    }
                } else {
                    completion(nil, .receivedInvalidData)
                }
            }.resume()
        } else{
            completion(nil, .invalidURL)
        }
    }
}

enum NetworkError: Error {
    case receivedInvalidData
    case invalidURL
}
