//
//  MovieListByPersonRequest.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/13/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

class MovieListByPersonRequest: BaseRequest {
    required init(personId: Int, page: Int) {
        let body: [String: Any]  = [:]
        let tmpUrl = Urls.baseApi + "person/\(personId)/movie_credits" + Urls.apiKey + "\(page)"

        super.init(url: tmpUrl, requestType: .get, body: body)
    }
}
