//
// Created by Dmitry Denisov on 26.01.2022.
//

import Foundation
import UIKit

class ShowTableViewCell: UITableViewCell {
    var showTitle = UILabel.init()
    var unseenCount = UILabel.init()

    static var cellId : String { "showCell" }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(showTitle)
        addSubview(unseenCount)

        showTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showTitle.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            showTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
