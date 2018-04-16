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
    func getPersonDetail(personId: Int, page: Int,
                         completion: @escaping (BaseResult<Person>) -> Void)
}

class PersonRepositoryImpl: PersonRepository {
    internal func getPersonDetail(personId: Int, page: Int, completion: @escaping (BaseResult<Person>) -> Void) {
        let input = PersonDetailRequest(personId: personId, page: page)

        api?.request(input: input) { (object: Person?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            }
        }
    }

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
