//
// Created by Dmitry Denisov on 26.01.2022.
//

import Foundation

struct Show : Codable {
    var id: Int
    var name: String
    var overview: String
    var posterPath: String?
    var voteAverage : Float
    var firstAirDate: String
    var tagline: String
    var status: String
    var type: String
    var numberOfSeasons: Int
    var numberOfEpisodes: Int

    enum CodingKeys: String, CodingKey {
        case id, name, overview, tagline, type, status
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
    }

    var year: String {
        let lowerBound = String.Index(utf16Offset: 0, in: firstAirDate)
        let upperBound = String.Index(utf16Offset: 3, in: firstAirDate)
        return String(firstAirDate[lowerBound...upperBound])
    }

    var fullPosterPath: String? {
        if let posterPath = self.posterPath {
            return "https://image.tmdb.org/t/p/w500" + posterPath
        }
        return nil
    }

    var unseenEpisodes: Int = 0
}