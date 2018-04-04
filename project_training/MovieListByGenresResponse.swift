//
//  MovieListByGenresResponse.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/6/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieListByGenresResponse: Mappable {
    var genresId: Int?
    var page: Int?
    var totalPages: Int?
    var movieList = [Movie]()

    required init(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        genresId <- map["id"]
        page <- map["page"]
        totalPages <- map["total_pages"]
        movieList <- map["results"]
    }
}
