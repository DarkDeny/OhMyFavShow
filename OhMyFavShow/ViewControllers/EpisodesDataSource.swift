//
// Created by Dmitry Denisov on 01.03.2022.
//

import Foundation
import UIKit

class EpisodesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    let episodes: [EpisodeShort]
    init(from season: SeasonDetails) {
        episodes = season.episodes.sorted(by: {$0.episodeNumber < $1.episodeNumber})
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { episodes.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var episode = episodes[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeViewCell.cellId) as! EpisodeViewCell
        cell.selectionStyle = .none
        cell.episodeNameLabel.text = episode.numberAndName
        cell.airDate.text = episode.airDate
        return cell
    }
}