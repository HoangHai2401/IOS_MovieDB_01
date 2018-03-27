//
//  Movie.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/27/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
struct Movie{
    var adult: Bool?
    var backdrop_path: String?
    var genre_ids: [Int]?
    var id: String?
    var original_title: String?
    var overview: String?
    var release_date: String?
    var popularity: String?
    var video: Bool?
    var poster_path: String?
    var title: String?
    var vote_average: Double?
    var vote_count: Int?
    
    init() {}

}
