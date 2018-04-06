//
//  CustomRequestAdapter.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/6/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import Alamofire

class CustomRequestAdapter: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
}
