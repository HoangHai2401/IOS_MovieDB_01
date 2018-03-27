//
//  Common.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/27/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
public class Api{
    static let shared: Api = Api()
    static let api_key = "?api_key=5a5ec186a70be41d577196ee58e4ff3d&language=en-US"
    static let base_url = "https://api.themoviedb.org/3/"
    static let genres_url = "genre/movie/list"
    static let popular_url = "movie/popular"
    static let now_playing_url = "movie/now_playing"
    static let top_rated_url = "movie/top_rated"
    static let upcoming_url = "movie/upcoming"
    
    
    init() {
        
    }
    
    class func httpRequest(api: String, completionHandler: @escaping (_ genres: [String: Any]) -> ()) {
        
        let url = URL(string: api)!
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                    if let results: NSArray = json["results"] as? NSArray{
                        completionHandler(json)
//                    }
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
}
