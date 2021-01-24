//
//  NetworkUtility.swift
//  TestTask
//
//  Created by Trinh Cuong on 24/01/2021.
//

import Foundation

class ImageUtility {
    
    
    func addNewImage(for searchTerm: String, completion: @escaping (Result<Data,Error>) -> Void) {
        
        guard let addUrl = URL(string:Constants.url) else {
          return
        }
        
        let addUrlRequest = URLRequest(url: addUrl)
        
        URLSession.shared.dataTask(with: addUrlRequest) { (data, urlRespone, error) in
            
            if let error = error {
              DispatchQueue.main.async {
                completion(.failure(error))
              }
              return
            }
            
            guard let data = data else {
                return
            }
            
            completion(.success(data))
            return
        }.resume()
    }
}
