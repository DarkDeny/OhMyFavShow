//
// Created by Dmitry Denisov on 06.02.2022.
//

import Foundation

class ShowFetcher {
    static func fetch(for searchTerm: String) async -> [Show] {
        var foundShows = [Show]()
        let decoder = JSONDecoder()
        let url = URL(string: "https://www.omdbapi.com/?apikey=aceb2294&type=series&s=\(searchTerm)")
        print("requesting url: \(url)")
        do {
            let (data, response) = try await URLSession.shared.data(from: url!)
            let str = String(decoding: data, as: UTF8.self)
            print("resulting response is:\n\(str)")
            print("== before decoding ==")
            let searchResult = try decoder.decode(Search.self, from: data)
            for shortInfo in searchResult.results {
                let detailedInfoUrl = URL.init(string: "https://www.omdbapi.com/?apikey=aceb2294&type=series&i=\(shortInfo.imdbId)")
                print("requesting details for \(shortInfo.imdbId)")
                let (detailsData, _) = try await URLSession.shared.data(from: detailedInfoUrl!)
                print("response received")
                let detailedInfo = try decoder.decode(Show.self, from: detailsData)
                print("json decoded")
                foundShows.append(detailedInfo)
            }
        } catch {
            print(error)
        }

        return foundShows
    }
}
