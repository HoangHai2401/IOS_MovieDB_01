//
//  HandlingMovieDatabase.swift
//  project_training
//
//  Created by Nguyen Dong Son on 4/16/18.
//  Copyright © 2018 Nguyen Dong Son. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HandlingMovieDatabase {
    private class func getManagerContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }

    class func insertMovie(movie: Movie) -> Bool {
        if checkData(movie: movie) == nil {
            do {
                if let managedContext = getManagerContext() {
                    if let movieEntity = NSEntityDescription.entity(forEntityName: Common.movieDatabase,
                                                                    in: managedContext) {
                        let movieObject = NSManagedObject(entity: movieEntity, insertInto: getManagerContext())
                        movieObject.setValue(movie.title, forKey: "title")
                        movieObject.setValue(movie.overview, forKey: "overview")
                        movieObject.setValue(movie.movieId, forKey: "movieId")
                        movieObject.setValue(movie.posterPath, forKey: "posterPath")
                        try managedContext.save()
                        return true
                    } else {
                        return false
                    }
                }
            } catch {
                return false
            }
        }
        return false
    }

    class func fetchMovie() -> [Movie] {
        let managedContext = getManagerContext()
        var tmpMovies = [Movie]()
        let request = NSFetchRequest<NSManagedObject>(entityName: Common.movieDatabase)
        var tmpFetch = [NSManagedObject]()
        if let tmpManagedContext = managedContext {
            do {
                tmpFetch = try tmpManagedContext.fetch(request)
                for index in tmpFetch {
                    let tmpTitleMovie = index.value(forKey: "title") as? String ?? ""
                    let tmpPosterPathMovie = index.value(forKey: "posterPath") as? String ?? ""
                    let tmpOverviewMovie = index.value(forKey: "overview") as? String ?? ""
                    let tmpIdMovie = index.value(forKey: "movieId") as? Int ?? 0
                    let tmpMovieData = Movie(title: tmpTitleMovie, movieId: tmpIdMovie,
                                             posterPath: tmpPosterPathMovie, overview: tmpOverviewMovie)
                    tmpMovies.append(tmpMovieData)
                }
            } catch {
            }
        }
        return tmpMovies
    }

    class func cleanAllCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Common.movieDatabase)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        if let managedContext = getManagerContext() {
            do {
                try managedContext.execute(deleteRequest)
            } catch {
            }
        }
    }

    class func deleteMovie(movie: Movie) -> Bool {
        if let tmpData = checkData(movie: movie),
            let managedContext = getManagerContext() {
            do {
                managedContext.delete(tmpData)
                try managedContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }

    class func checkData(movie: Movie) -> NSManagedObject? {
        let managedContext = getManagerContext()
        if let tmpMovieID = movie.movieId,
            let tmpManagedContext = managedContext {
            let request = NSFetchRequest<NSManagedObject>(entityName: Common.movieDatabase)
            var tmpFetch = [NSManagedObject]()
            do {
                tmpFetch = try tmpManagedContext.fetch(request)
                for index in tmpFetch {
                    let tmpMovieIdFetch = index.value(forKey: "movieId") as? Int ?? 0
                    if tmpMovieIdFetch == tmpMovieID {
                        return index
                    }
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}
