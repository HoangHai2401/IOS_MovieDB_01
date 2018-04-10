//
//  PersonListByMovieResponse.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/10/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import ObjectMapper

class PersonListByMovieResponse: Mappable {
    var movieId: Int?
    var castList = [Person]()
    var crewList = [Person]()

    required init(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        movieId <- map["id"]
        castList <- map["cast"]
        crewList <- map["crew"]
    }
}
