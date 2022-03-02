//
// Created by Dmitry Denisov on 19.02.2022.
//

import Foundation
import UIKit

class SeasonViewCell: UITableViewCell {
    var seasonNameLabel = UILabel()
    var episodesTable = UITableView()

    static var cellId : String { "seasonCell" }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(seasonNameLabel)
        addSubview(episodesTable)
        episodesTable.register(EpisodeViewCell.self, forCellReuseIdentifier: EpisodeViewCell.cellId)

        seasonNameLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seasonNameLabel.topAnchor.constraint(equalTo: topAnchor),
            seasonNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            seasonNameLabel.rightAnchor.constraint(equalTo: rightAnchor),

            episodesTable.topAnchor.constraint(equalTo: seasonNameLabel.bottomAnchor, constant: 10),
            episodesTable.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            episodesTable.rightAnchor.constraint(equalTo: rightAnchor, constant: 20),
            episodesTable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])

        episodesTable.backgroundColor = UIColor.systemMint
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
