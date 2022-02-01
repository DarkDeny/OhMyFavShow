//
// Created by Dmitry Denisov on 26.01.2022.
//

import Foundation

class Show {
    var title: String
    var year: String
    var imdbId: String

    var posterUrl: String?
    var plot: String?
    var loaded: Bool = false

    var unseenEpisodes: Int = 0

    init(title: String, year: String, imdbId: String){
        self.title = title
        self.year = year
        self.imdbId = imdbId
    }

    var myViewController: SearchViewController?
    func requestDetails(controller: SearchViewController) {
        myViewController = controller
        // TODO: make a request for details using show ID
        let url = "https://www.omdbapi.com/?apikey=aceb2294&type=series&i=\(imdbId)"
        print("Requesting details for: \(imdbId)")
        HTTPHandler.getJson(urlString: url, completionHandler: parseDetailsData)
    }

    func parseDetailsData(data: Data?) {
        if let data = data {
            let object = JSONParser.parse(data: data)
            if let object = object {
                guard let details = object as? [String: AnyObject] else { return }
                if let plot = details["Plot"] as? String {
                    self.plot = plot
                }
                if let posterUrl = details["Poster"] as? String {
                    print("poster url received for \(imdbId)")
                    self.posterUrl = posterUrl
                    self.loaded = true
                    if let myController = myViewController {
                        print("calling parent controller")
                        myController.onShowImageLoaded()
                    }
                }
            }
        }
    }
}
