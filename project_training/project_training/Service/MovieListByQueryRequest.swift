//
//  MovieListByQueryRequest.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/6/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class MovieListByQueryRequest: BaseRequest {
    required init(query: String, page: Int) {
        let body: [String: Any]  = [:]
        let formatQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let tmpUrl = Urls.baseApi + Urls.searchUrl + Urls.apiKey + "\(page)"+"&query=\(formatQuery!)"

        super.init(url: tmpUrl, requestType: .get, body: body)
    }
}
