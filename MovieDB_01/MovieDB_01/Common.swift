//
//  Common.swift
//  MovieDB_01
//
//  Created by Nguyen Dong Son on 3/27/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation

public class Common{
    static let api_key = "?api_key=5a5ec186a70be41d577196ee58e4ff3d&language=en-US"
    static let base_url = "https://api.themoviedb.org/3/"
    static let genres_url = "genre/movie/list"
    static let popular_url = "movie/popular"
    static let now_playing_url = "movie/now_playing"
    static let top_rated_url = "movie/top_rated"
    static let upcoming_url = "movie/upcoming"
    static let list_category:[String]=["Popular", "Top rated", "Upcoming", "Now playing", "Genres"]
    static let list_genres: [(Int,String)] = [(28,"Action"),(12,"Adventure"),(16,"Animation"),(35,"Comedy"),(80,"Crime"),(99,"Documentary"),(18,"Drama"),(10751,"Family"),(14,"Fantasy"),(36,"History"),(27,"Horror"),(10402,"Music"),(9648,"Mystery"),(10749,"Romance"),(10770,"TV Movie"),(878,"Science Fiction"),(53,"Thriller"),(10752,"War"),(37,"Western")]
    
}
