//
//  ApiService.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiService {
    class var apiService: ApiService {
        struct Static {
            static let instance = ApiService()
        }
        return Static.instance
    }

    func apiRequest(api: String, page: Int, completionHandler: @escaping (_ object: JSON) -> Void) {
        let pathAPI = Urls.baseApi + "\(api)" + Urls.apiKey + "\(page)"
        Alamofire.request(pathAPI, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        print("success")
                        let json = JSON(value)
                        completionHandler(json)
                    default:
                        print("error with response status: \(status)")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func genresApiRequest(genresId: Int, page: Int, completionHandler: @escaping (_ object: JSON) -> Void) {
        let pathAPI = Urls.baseApi + "genre/\(genresId)/movies" + Urls.apiKey + "\(page)"
        Alamofire.request(pathAPI, method: .get, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                if let status = response.response?.statusCode {
                    switch status {
                    case 200:
                        print("success")
                        let json = JSON(value)
                        completionHandler(json)
                    default:
                        print("error with response status: \(status)")
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
