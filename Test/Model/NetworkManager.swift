//
//  NetworkManager.swift
//  Test
//
//  Created by Семен Беляков on 06.03.2022.
//

import Foundation

class NetworkManager {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let baseURL = URL(string: "https://api.stackexchange.com/")

    func obtainQuestions(path: String, completion: @escaping (Response) -> Void ) {
        
        let urlString = "\(baseURL!)\(path)"
        
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            
            guard let strongSelf = self else { return }
            
            if error == nil, let data = data {
                guard let question = try? strongSelf.decoder.decode(Response.self, from: data) else { return }
                completion(question)
            }
        }
    }
}
