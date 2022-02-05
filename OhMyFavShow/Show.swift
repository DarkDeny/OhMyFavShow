//
// Created by Dmitry Denisov on 26.01.2022.
//

import Foundation

class Show : Codable {
    var title: String
    var year: String
    var imdbId: String

    var posterUrl: String?
    var plot: String?
    var loaded: Bool = false

    enum CodingKeys: String, CodingKey {
        case imdbId = "imdbID"
        case plot = "Plot"
        case title = "Title"
        case year = "Year"
        case posterUrl = "Poster"
    }

    var unseenEpisodes: Int = 0

    init(title: String, year: String, imdbId: String) {
        self.title = title
        self.year = year
        self.imdbId = imdbId
    }
}
