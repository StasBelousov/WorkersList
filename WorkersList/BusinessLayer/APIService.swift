//
//  APIService.swift
//  WorkersList
//
//  Created by Станислав Белоусов on 31.10.2021.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    var urlSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func fetchCharacters(completion: @escaping (Result<UsersData, Error>) -> Void) {
        
        dataTask?.cancel()
        
        if let currentURL = URL(string: "https://stoplight.io/mocks/kode-education/trainee-test/25143926/users") {
            dataTask = urlSession.dataTask(with: currentURL) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                if let error = error {
                    completion(.failure(error))
                } else if let data = data,
                          let response = response as? HTTPURLResponse,
                          response.statusCode == 200 {
                    do {
                        let json = try JSONDecoder().decode(UsersData.self, from: data)
                        completion(.success(json))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
}
