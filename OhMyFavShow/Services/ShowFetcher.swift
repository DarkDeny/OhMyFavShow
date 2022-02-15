//
// Created by Dmitry Denisov on 06.02.2022.
//

import Foundation

class ShowFetcher {
    static func getSeasonData(_ showId: Int, for seasonNumber: Int) async -> SeasonDetails? {
        // TODO: request!
        let decoder = JSONDecoder()
        let stringUrl = "https://api.themoviedb.org/3/tv/\(showId)/season/\(seasonNumber)?api_key=a355d3dfcd7ca5e7eab1aa4a8a11d44b"
        let url = URL(string: stringUrl)
        print("requesting url: \(url)")
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            print("resulting response is:\n\(String(decoding: data, as: UTF8.self))")
            print("== before decoding ==")
            let seasonDetails = try decoder.decode(SeasonDetails.self, from: data)
            return seasonDetails
        }
        catch {
            print(error)
        }
        return nil
    }

    static func fetch(for searchTerm: String) async -> [Show] {
        var foundShows = [Show]()
        let decoder = JSONDecoder()

        let escapedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let stringUrl = "https://api.themoviedb.org/3/search/tv?api_key=a355d3dfcd7ca5e7eab1aa4a8a11d44b&query=\(escapedSearchTerm)"
        let url = URL(string: stringUrl)
        print("requesting url: \(url)")
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let searchResult = try decoder.decode(Search.self, from: data)
            for shortInfo in searchResult.results {
                guard let showId = shortInfo.id else { continue }
                print("requesting details for \(showId)")
                let details = "https://api.themoviedb.org/3/tv/\(showId)?api_key=a355d3dfcd7ca5e7eab1aa4a8a11d44b"
                print("details url is:\n\(details)")
                let detailsUrl = URL.init(string: details)
                let (detailsData, _) = try await URLSession.shared.data(from: detailsUrl!)
                let debugJson = String(data:  detailsData, encoding: .utf8)
                print("response received:\n\(debugJson!)")
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
