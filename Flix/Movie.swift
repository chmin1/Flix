//
//  Movie.swift
//  Flix
//
//  Created by Chavane Minto on 7/3/17.
//  Copyright © 2017 Chavane Minto. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var overview: String
    var releaseDate: String
    var posterURL: URL?
    var backdropPathString: String
    var posterPathString: String
    var baseURLString: String
    var posterPathURL: URL?
    var backdropURL: URL?
    
    
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        overview = dictionary["overview"] as? String ?? "No overview"
        releaseDate = dictionary["release_date"] as? String ?? " "
        // Get backdrop image and poster URLs
        backdropPathString = dictionary["backdrop_path"] as! String
        posterPathString = dictionary["poster_path"] as! String
        baseURLString = "https://image.tmdb.org/t/p/w500"
        
        backdropURL = URL(string: baseURLString + backdropPathString)!
        
        posterPathURL = URL(string: baseURLString + posterPathString)!

    }
    
}
