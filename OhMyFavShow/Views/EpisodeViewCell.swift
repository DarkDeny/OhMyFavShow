//
// Created by Dmitry Denisov on 19.02.2022.
//

import Foundation
import UIKit

class EpisodeViewCell: UITableViewCell {
    static var cellId: String { "episodeCell" }

    var episodeNameLabel = UILabel()
    var airDate = UILabel()
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(episodeNameLabel)
        addSubview(airDate)

        episodeNameLabel.textColor = UIColor.label
        airDate.textColor = UIColor.label
        episodeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        airDate.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            episodeNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            episodeNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),

            airDate.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            airDate.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
