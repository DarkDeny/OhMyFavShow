//
// Created by Dmitry Denisov on 07.02.2022.
//

import Foundation

struct Search : Codable {
    var results: [ShortShowInfo]
    var page: Int
    var totalPages: Int
    var totalResults: Int

    enum CodingKeys : String, CodingKey {
        case results, page
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
