//
//  MovieListByCategoryRequest.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/6/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class MovieListByCategoryRequest: BaseRequest {
    required init(categoryUrl: String, page: Int) {
        let body: [String: Any]  = [:]
        let tmpUrl = Urls.baseApi + categoryUrl + Urls.apiKey + "\(page)"

        super.init(url: tmpUrl, requestType: .get, body: body)
    }
}
