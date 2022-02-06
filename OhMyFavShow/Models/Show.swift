//
// Created by Dmitry Denisov on 26.01.2022.
//

import Foundation

struct Search : Codable {
    var results: [ShortShowInfo]

    enum CodingKeys: String, CodingKey {
        case results = "Search"
    }
}

struct ShortShowInfo : Codable {
    var title: String
    var year: String
    var imdbId: String

    init(title: String, year: String, imdbId: String) {
        self.title = title
        self.year = year
        self.imdbId = imdbId
    }

    enum CodingKeys: String, CodingKey {
        case imdbId = "imdbID"
        case title = "Title"
        case year = "Year"
    }
}

class Show : Codable {
    var title: String
    var year: String
    var imdbId: String
    var posterUrl: String
    var plot: String

    enum CodingKeys: String, CodingKey {
        case imdbId = "imdbID"
        case plot = "Plot"
        case title = "Title"
        case year = "Year"
        case posterUrl = "Poster"
    }

    var unseenEpisodes: Int = 0
}
