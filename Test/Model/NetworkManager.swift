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
    
    

    
    func obtainQuestions(path: String, completion: @escaping (JSONResponse?) -> Void ) {
                
//        let baseURL = URL(string: "https://api.stackexchange.com/")
        
        let baseURL = URL(string: "https://api.stackexchange.com/2.3/tags/\(path)/info?order=desc&sort=popular&site=stackoverflow")
        let urlString = "\(baseURL!)"
//        let urlString = "\(baseURL!)\(path)"
        
        guard let url = URL(string: urlString) else { return print("nope") }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            
            guard let strongSelf = self else {
                return
            }
            
            if error == nil {
                guard let data = data else { return }
                
                let tagQuestion = try? strongSelf.decoder.decode(JSONResponse.self, from: data)
                completion(tagQuestion)
                
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
            
        }.resume()
    }
}
