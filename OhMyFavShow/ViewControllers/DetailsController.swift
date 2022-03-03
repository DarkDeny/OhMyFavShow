//
// Created by Dmitry Denisov on 19.02.2022.
//

import Foundation
import UIKit

class DetailsController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let plotLabel = UITextView()
    let titleLabel = UILabel()
    let posterImage = UIImageView()
    let seasonsTable = UITableView()
    var typedParent : MainViewController?
    let seasonSectionLabel = UILabel()
    var currentShow: Show? = nil
    var seasons = [SeasonDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()

        seasonsTable.register(SeasonViewCell.self, forCellReuseIdentifier: SeasonViewCell.cellId)
        seasonsTable.delegate = self
        seasonsTable.dataSource = self

        plotLabel.textAlignment = .justified
        plotLabel.isUserInteractionEnabled = false
        plotLabel.textContainerInset = .zero
        plotLabel.textContainer.lineFragmentPadding = 0.0

        titleLabel.font = titleLabel.font.withSize(24)
        titleLabel.textColor = UIColor.label

        seasonSectionLabel.text = "Seasons:"

        view.addSubview(titleLabel)
        view.addSubview(plotLabel)
        view.addSubview(posterImage)
        view.addSubview(seasonsTable)
        view.addSubview(seasonSectionLabel)

        posterImage.translatesAutoresizingMaskIntoConstraints = false
        plotLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        seasonsTable.translatesAutoresizingMaskIntoConstraints = false
        seasonSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            posterImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            posterImage.topAnchor.constraint(equalTo: view.topAnchor),
            posterImage.widthAnchor.constraint(equalToConstant: 200),
            posterImage.heightAnchor.constraint(equalToConstant: 300),

            titleLabel.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),

            plotLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            plotLabel.leftAnchor.constraint(equalTo: posterImage.rightAnchor, constant: 20),
            plotLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            plotLabel.bottomAnchor.constraint(equalTo: posterImage.bottomAnchor),

            seasonSectionLabel.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 20),
            seasonSectionLabel.leftAnchor.constraint(equalTo: view.leftAnchor),

            seasonsTable.topAnchor.constraint(equalTo: seasonSectionLabel.bottomAnchor, constant: 20),
            seasonsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            seasonsTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            seasonsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func didSelected(show: Show) {
        currentShow = show
        seasons = currentShow!.seasonsDetailed!.sorted(by: {$0.name < $1.name})
        titleLabel.text = show.name
        plotLabel.text = show.overview
        plotLabel.sizeToFit()
        seasonsTable.reloadData()

        if let fullPosterPath = show.fullPosterPath {
            let url: String = (URL(string: fullPosterPath)?.absoluteString)!
            URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
                        if error != nil {
                            print(error!)
                            return
                        }

                        DispatchQueue.main.async(execute: {
                            let image = UIImage(data: data!)
                            self.posterImage.image = image
                        })
                    })
                    .resume()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { seasons.count }

    var episodeDataSources = [SeasonDetails: EpisodesDataSource]()
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let targetSeason = seasons[indexPath.item]

        let cell = tableView.dequeueReusableCell(withIdentifier: SeasonViewCell.cellId) as! SeasonViewCell
        cell.selectionStyle = .none
        cell.seasonNameLabel.text = targetSeason.name

        if episodeDataSources[targetSeason] == nil {
            episodeDataSources[targetSeason] = EpisodesDataSource.init(from: targetSeason)
        }

        cell.episodesTable.dataSource = episodeDataSources[targetSeason]
        cell.episodesTable.delegate = episodeDataSources[targetSeason]
        cell.episodesTable.reloadData()

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let episodesCount = seasons[indexPath.item].episodes.count
        // 44 is default height, atm UITableView.autodimension returns -1 =(
        return CGFloat(44*episodesCount)
    }
}