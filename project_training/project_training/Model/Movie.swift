//
//  Movie.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper

class Movie: BaseModel {
    var adult: Bool?
    var backdropPath: String?
    var genres = [Genres]()
    var genreIds = [Int]()
    var movieId: Int?
    var originalTitle: String?
    var overview: String?
    var releaseDate: String?
    var popularity: Double?
    var video: Bool?
    var posterPath: String?
    var title: String?
    var voteAverage: Double?
    var voteCount: Int?
    var originalLanguage: String?
    var runTime: Int?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        title <- map["title"]
        originalTitle <- map["original_title"]
        overview <- map["overview"]
        movieId <- map["id"]
        posterPath <- map["poster_path"]
        voteAverage <- map["vote_average"]
        genreIds <- map["genre_ids"]
        genres <- map["genres"]
        releaseDate <- map["release_date"]
        backdropPath <- map["backdrop_path"]
        voteCount <- map["vote_count"]
        adult <- map["adult"]
        video <- map["video"]
        popularity <- map["popularity"]
        originalLanguage <- map["original_language"]
        runTime <- map["runtime"]
    }

    func getFullLink() -> String? {
        guard let path = posterPath else { return nil }
        return Urls.imageUrl + "\(path)"
    }
}
