//
//  BaseResult.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/6/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper

enum BaseResult<T: Mappable> {
    case success(T?)
    case failure(error: BaseError?)
}
