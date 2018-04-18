//
//  MovieTrailerResponse.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/18/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import ObjectMapper

class MovieTrailerResponse: Mappable {
    var movieId: Int?
    var trailerList = [Trailer]()

    required init(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        movieId <- map["id"]
        trailerList <- map["results"]
    }
}
