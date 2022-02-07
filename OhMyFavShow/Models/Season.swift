//
// Created by Dmitry Denisov on 07.02.2022.
//

import Foundation

struct Season : Codable {
    var id: Int
    var name: String
    var seasonNumber: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case seasonNumber = "season_number"
    }
}