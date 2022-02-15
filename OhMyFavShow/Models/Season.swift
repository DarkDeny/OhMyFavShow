//
// Created by Dmitry Denisov on 07.02.2022.
//

import Foundation

struct SeasonShort : Codable {
    var id: Int
    var name: String
    var seasonNumber: Int
    var episodeCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case seasonNumber = "season_number"
        case episodeCount = "episode_count"
    }
}

struct SeasonDetails : Codable {
    var id: Int
    var name: String
    var overview: String
    var posterPath: String
    var seasonNumber: Int
    var episodes: [EpisodeShort]

    enum CodingKeys: String, CodingKey {
        case id, name, overview, episodes
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}