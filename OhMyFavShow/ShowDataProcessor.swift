//
// Created by Dmitry Denisov on 26.01.2022.
//

import Foundation

class ShowDataProcessor {
    static func mapJson(object: [String: AnyObject], dataKey: String) -> [Show] {
        var processedShows = [Show]()
        let testShows = object[dataKey]
        if let testShows = testShows {
            guard let shows = testShows as? [[String: AnyObject]] else {return processedShows}
            for show in shows {
                guard let title = show["Title"] as? String,
                      let year = show["Year"] as? String,
                      let imdbId = show["imdbID"] as? String
                        else { continue }

                let foundShow = Show.init(title: title, year: year, imdbId: imdbId)
                if let plot = show["Plot"] as? String { foundShow.plot = plot }

                processedShows.append(foundShow)
            }
        }

        return processedShows
    }
}
