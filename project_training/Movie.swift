//
//  Movie.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import SwiftyJSON

class Movie {
    var adult: Bool?
    var backdropPath: String?
    var genreIds: [Any]?
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

    init(json: JSON) {
        self.title = json["title"].stringValue
        self.originalTitle = json["original_title"].stringValue
        self.overview = json["overview"].stringValue
        self.movieId = json["id"].intValue
        self.posterPath = json["poster_path"].stringValue
        self.voteAverage = json["vote_average"].doubleValue
        self.genreIds = json["genre_ids"].arrayValue
        self.releaseDate = json["release_date"].stringValue
        self.backdropPath = json["backdrop_path"].stringValue
        self.voteCount = json["vote_count"].intValue
        self.adult = json["adult"].boolValue
        self.video = json["video"].boolValue
        self.popularity = json["popularity"].doubleValue
    }
}
