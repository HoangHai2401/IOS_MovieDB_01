//
//  MovieRepository.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/6/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import ObjectMapper

protocol MovieRepository {
    func getMovieByCategory(categoryUrl: String, page: Int,
                            completion: @escaping (BaseResult<MovieListByCategoryResponse>) -> Void)

    func getMovieByGenres(genresId: Int, page: Int,
                          completion: @escaping (BaseResult<MovieListByGenresResponse>) -> Void)
}

class MovieRepositoryImpl: MovieRepository {
    private var api: ApiService?

    required init(api: ApiService) {
        self.api = api
    }

    func getMovieByCategory(categoryUrl: String, page: Int,
                            completion: @escaping (BaseResult<MovieListByCategoryResponse>) -> Void) {
        let input = MovieListByCategoryRequest(categoryUrl: categoryUrl, page: page)

        api?.request(input: input) { (object: MovieListByCategoryResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }

    func getMovieByGenres(genresId: Int, page: Int,
                          completion: @escaping (BaseResult<MovieListByGenresResponse>) -> Void) {
        let input = MovieListByGenresRequest(genresId: genresId, page: page)
        api?.request(input: input) { (object: MovieListByGenresResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
