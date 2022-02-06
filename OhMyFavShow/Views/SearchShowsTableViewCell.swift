//
//  SearchShowsTableViewCell.swift
//  OhMyFavShow
//
//  Created by Dmitry Denisov on 26.01.2022.
//

import UIKit

class SearchShowsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var plotLabel: UILabel!
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
}
