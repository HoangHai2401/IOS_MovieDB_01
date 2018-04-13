//
//  MovieDetailRequest.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/13/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class MovieDetailRequest: BaseRequest {
    required init(movieId: Int, page: Int) {
        let body: [String: Any]  = [:]
        let tmpUrl = Urls.baseApi + "movie/\(movieId)" + Urls.apiKey + "\(page)"

        super.init(url: tmpUrl, requestType: .get, body: body)
    }
}
