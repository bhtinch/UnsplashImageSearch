//
//  UnsplashController.swift
//  ImageSearch40
//
//  Created by Benjamin Tincher on 8/4/21.
//

import Foundation
import UIKit

enum UnsplashConstants {
    static let baseURL = URL(string: "https://api.unsplash.com")
    static let photoSearchEndpoint = "search/photos"
    static let clientIDKey = "client_id"
    static let queryKey = "query"
}

struct UnsplashController {
    
    private static let accessKey = "Qrbk21eQnxBNYPrRBVlYcbzbecpRcvA3jvT_NYasvUA"
    
    static func fetchImages(with searchTerm: String, completion: @escaping(Result<[UnsplashImage], NetworkError>) -> Void ) {
        guard let baseURL = UnsplashConstants.baseURL else { return }
        
        let photoSearchEndpointURL = baseURL.appendingPathComponent(UnsplashConstants.photoSearchEndpoint)
            
        var components = URLComponents(url: photoSearchEndpointURL, resolvingAgainstBaseURL: true)
        
        let accessQuery = URLQueryItem(name: UnsplashConstants.clientIDKey, value: accessKey)
        let searchTermQuery = URLQueryItem(name: UnsplashConstants.queryKey, value: searchTerm)
        
        components?.queryItems = [accessQuery, searchTermQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        
        print(finalURL)
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(.serverError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let unsplashImagesTL = try JSONDecoder().decode(UnsplashTopLevel.self, from: data)
                completion(.success(unsplashImagesTL.results))
            } catch {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                completion(.failure(.thrownError(error)))
            }
        }
        
        task.resume()
    }
    
    static func fetchImage(with url: URL, completion: @escaping(Result<UIImage, NetworkError>) -> Void ) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("***Error*** in Function: \(#function)\n\nError: \(error)\n\nDescription: \(error.localizedDescription)")
                return completion(.failure(.serverError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.noImage)) }
            completion(.success(image))
        }
        
        task.resume()
    }
}
