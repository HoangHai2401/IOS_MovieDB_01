//
//  PersonRepository.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/10/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper

protocol PersonRepository {
    func getPersonByMovie(movieId: Int, page: Int,
                          completion: @escaping (BaseResult<PersonListByMovieResponse>) -> Void)
}

class PersonRepositoryImpl: PersonRepository {
    private var api: ApiService?

    required init(api: ApiService) {
        self.api = api
    }

    func getPersonByMovie(movieId: Int, page: Int,
                          completion: @escaping (BaseResult<PersonListByMovieResponse>) -> Void) {
        let input = PersonListByMovieRequest(movieId: movieId, page: page)

        api?.request(input: input) { (object: PersonListByMovieResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            }
        }
    }
}
