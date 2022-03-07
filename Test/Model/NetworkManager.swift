//
//  NetworkManager.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import Foundation

enum ObtainResult {
    case success(users: [User])
    case failure(errors: Error)
}

class NetworkManager {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    func obtainQuestions(completion: @escaping (ObtainResult) -> Void ) {
        
        let baseURL = URL(string: "https://api.stackexchange.com/2.3/users/55/tags?order=desc&sort=popular&site=stackoverflow")
        let urlString = "\(baseURL!)"
        
        guard let url = URL(string: urlString) else { return print("nope") }
        
        session.dataTask(with: url) { [weak self] data, response, error in

            var result: ObtainResult

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }

            guard let strongSelf = self else {
                result = .success(users: [])
                return
            }
            
            if error == nil, let data = data {
                
                guard let tagQuestion = try? strongSelf.decoder.decode([User].self, from: data) else {
                    result = .success(users: [])
                    return
                }

                result = .success(users: tagQuestion)
            } else {
                result = .failure(errors: error!)
            }
            
        }.resume()
    }
}
