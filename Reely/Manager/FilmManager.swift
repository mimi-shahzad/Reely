//
//  FilmManager.swift
//  Reely
//
//  Created by Mimi Shahzad on 8/22/20.
//  Copyright © 2020 Mimi Shahzad. All rights reserved.
//


import Foundation
import CoreData
public typealias JSON = [String: Any]

@available(iOS 13.0, *)
class FilmManager {
    
    enum FilmErrors: Error {
        case errorWithRequest(String)
        case errorWithData(String)
    }
    
    static let shared = FilmManager()
    static let API_KEY = "2696829a81b1b5827d515ff121700838"
    static let image = "https://image.tmdb.org/t/p/w92"
    private init() {}
    
    
    
    func getFilmData(query: String, page: String = "1", completion:
        @escaping(Result<[Film], FilmErrors>) -> Void ){
        let retrieveUrl = "https://api.themoviedb.org/3/search/movie?api_key=\(FilmManager.API_KEY)&query=\(query)&page=\(page)"
        
        guard let url = URL(string: retrieveUrl) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let _ = response, let responseData = data else {
                completion(.failure(.errorWithData(error?.localizedDescription ?? "")))
                return
            }
            
            var responseError = error
            var results: [JSON]?
            var jsonData = data
            
            do {
                
                let decoder = JSONDecoder()
                let filmResponse = try decoder.decode(Response.self, from: jsonData!)
                var filmResults = filmResponse.results
                if filmResponse.results.isEmpty {
                    DispatchQueue.main.async{
                        completion(.failure(.errorWithData("error with data")))
                    }
                } else {
                    self.getPoster(results: &filmResults)
                    DispatchQueue.main.async {
                        completion(.success((filmResults)))
                    }
                    print(results ?? [])
                }
            } catch let error {
                responseError = error
            }
        }
        
        dataTask.resume()
    }
    
    
    
    
    func getPoster(results: inout[Film]) {
        for (index, _) in results.enumerated(){
            guard let posterPath = results[index].poster_path else { break }
            results[index].poster_path  = "\(FilmManager.image)\(posterPath)"
        }
        }
    }
    
    
