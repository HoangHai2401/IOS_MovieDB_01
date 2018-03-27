//
//  Common.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/27/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation

public class Api{
    
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
                    
                    completionHandler(json)
                    
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
}
