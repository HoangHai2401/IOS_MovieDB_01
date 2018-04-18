//
//  Trailer.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/18/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper

class Trailer: BaseModel {
    var trailerId: String?
    var name: String?
    var trailerKey: String?
    var site: String?
    var size: String?
    var type: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        trailerId <- map["id"]
        name <- map["name"]
        trailerKey <- map["key"]
        site <- map["site"]
        size <- map["size"]
        type <- map["type"]
    }
}
