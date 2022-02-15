//
// Created by Dmitry Denisov on 15.02.2022.
//

import Foundation

struct EpisodeShort: Codable {
    var id: Int
    var name: String
    var overview: String
    var voteAverage: Float
    var episodeNumber: Int

    enum CodingKeys: String, CodingKey{
        case id, name, overview
        case voteAverage = "vote_average"
        case episodeNumber = "episode_number"
    }
}
