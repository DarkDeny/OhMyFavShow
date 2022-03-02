//
// Created by Dmitry Denisov on 01.03.2022.
//

import Foundation
import UIKit

class EpisodesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    let season: SeasonDetails
    init(from season: SeasonDetails) {
        self.season = season
        print("data source created for season \(season.seasonNumber)")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("data source for season \(season.seasonNumber), UI requested numberOfRowsInSection \(section) => \(season.episodes.count)")
        return season.episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("creating cell for row \(indexPath.item)")
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeViewCell.cellId) as! EpisodeViewCell
        cell.selectionStyle = .none
        cell.episodeNameLabel.text = season.episodes[indexPath.item].name
        print("created episode row for \(season.episodes[indexPath.item].name)")
        return cell
    }
}