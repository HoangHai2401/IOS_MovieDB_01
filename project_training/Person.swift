//
//  Person.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/2/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import SwiftyJSON

class Person {
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

    init(json: JSON) {
        self.birthday = json["birthday"].stringValue
        self.deathday = json["deathday"].stringValue
        self.personId = json["id"].intValue
        self.name = json["name"].stringValue
        self.alsoKnownAs = json["also_known_as"].arrayValue
        self.gender = json["gender"].intValue
        self.biography = json["biography"].stringValue
        self.popularity = json["popularity"].stringValue
        self.placeOfBirth = json["place_of_birth"].stringValue
        self.profilePath = json["profile_path"].stringValue
        self.adult = json["adult"].boolValue
        self.imdbId = json["imdb_id"].stringValue
        self.homepage = json["homepage"].stringValue
    }
}
