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
        print("SearchShowsTableViewCell awakeFromNib")
    }

    static var cellId : String { "searchShowCell" }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(likeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(plotLabel)
        contentView.addSubview(posterImageView)

        titleLabel.numberOfLines = 1

        plotLabel.textAlignment = .justified
        plotLabel.isUserInteractionEnabled = false
        plotLabel.textContainerInset = .zero
        plotLabel.textContainer.lineFragmentPadding = 0.0

        likeButton.setTitle("Like", for: .normal)
        likeButton.setTitleColor(UIColor.label, for: .normal)
        likeButton.addTarget(self, action: #selector(onTouchUpInside), for: .touchUpInside)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            posterImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),

            titleLabel.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),

            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            plotLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 20),
            plotLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            plotLabel.rightAnchor.constraint(equalTo: yearLabel.leftAnchor, constant: -20),

            yearLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            yearLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),

            likeButton.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 20),
            likeButton.centerXAnchor.constraint(equalTo: yearLabel.centerXAnchor),
        ])
    }

    @objc func onTouchUpInside() {
        print("cell touchUpInside")
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var titleLabel = UILabel()
    var yearLabel = UILabel()
    var plotLabel = UITextView()
    var posterImageView = UIImageView()
    var likeButton = UIButton()
}
