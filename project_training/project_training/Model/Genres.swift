//
//  Genres.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper

class Genres: BaseModel {
    var genresId: Int?
    var name: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        genresId <- map["id"]
        name <- map["name"]
    }
}
