//
//  MovieListByPersonResponse.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/13/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import ObjectMapper

class MovieListByPersonResponse: Mappable {
    var personId: Int?
    var castList = [Movie]()

    required init(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        personId <- map["id"]
        castList <- map["cast"]
    }
}
