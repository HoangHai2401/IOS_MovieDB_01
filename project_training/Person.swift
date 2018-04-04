//
//  Person.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper

class Person: BaseModel {
    var birthday: String?
    var deathday: String?
    var personId: Int?
    var name: String?
    var alsoKnownAs: [Any]?
    var gender: Int?
    var biography: String?
    var popularity: String?
    var placeOfBirth: String?
    var profilePath: String?
    var adult: Bool?
    var imdbId: String?
    var homepage: String?

    required init?(map: Map) {
        mapping(map: map)
    }

    func mapping(map: Map) {
        birthday <- map["birthday"]
        deathday <- map["deathday"]
        personId <- map["id"]
        name <- map["name"]
        alsoKnownAs <- map["also_known_as"]
        gender <- map["gender"]
        biography <- map["biography"]
        popularity <- map["popularity"]
        placeOfBirth <- map["place_of_birth"]
        profilePath <- map["profile_path"]
        adult <- map["adult"]
        imdbId <- map["imdb_id"]
        homepage <- map["homepage"]
    }
}
