//
// Created by Dmitry Denisov on 07.02.2022.
//

import Foundation

struct ShortShowInfo : Codable {
    var id: Int?
    var name: String?
    var overview: String?
    var posterPath: String?
    var voteAverage : Float?
    var firstAirDate: String?

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case firstAirDate = "first_air_date"
    }
}
