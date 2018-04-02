//
//  Common.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation

public struct Common {
    static let listCategory = [("Popular", Urls.popularUrl ),
                               ("Upcoming", Urls.upcomingUrl ), ("Top rated", Urls.topRatedUrl ),
                               ("Genres", ""), ("Now playing", Urls.nowPlayingUrl )]
    static let listGenres = [(28, "Action"), (12, "Adventure"), (16, "Animation"), (35, "Comedy"), (80, "Crime"),
                             (99, "Documentary"), (18, "Drama"), (10751, "Family"),
                             (14, "Fantasy"), (36, "History"), (27, "Horror"), (10402, "Music"),
                             (9648, "Mystery"), (10749, "Romance"),
                             (10770, "TV Movie"), (878, "Science Fiction"), (53, "Thriller"), (10752, "War"),
                             (37, "Western")]
}
