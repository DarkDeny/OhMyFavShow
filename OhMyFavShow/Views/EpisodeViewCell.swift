//
// Created by Dmitry Denisov on 19.02.2022.
//

import Foundation
import UIKit

class EpisodeViewCell: UITableViewCell {
    static var cellId: String { "episodeCell" }

    var episodeNameLabel = UILabel()
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(episodeNameLabel)
        episodeNameLabel.textColor = UIColor.label
        episodeNameLabel.textColor = UIColor.systemMint
        episodeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            episodeNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            episodeNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
