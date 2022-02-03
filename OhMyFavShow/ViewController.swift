//
//  ViewController.swift
//  OhMyFavShow
//
//  Created by Dmitry Denisov on 23.01.2022.
//
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { shows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("target show at index \(indexPath.item)")

        let cell = tableView.dequeueReusableCell(withIdentifier: "showCell", for: indexPath) as! ShowTableViewCell
        let targetShow = shows[indexPath.item]

        cell.showTitle.text = targetShow.title
        if (targetShow.unseenEpisodes > 0) {
            cell.unseenCount.isHidden = false
            cell.unseenCount.text = String(targetShow.unseenEpisodes)
        } else {
            cell.unseenCount.isHidden = true
        }

        return cell
    }

    var shows = [Show]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let firefly = Show.init(title: "Firefly",
                year: "2003",
                imdbId: "tt0303461")
        firefly.plot = "Five hundred years in the future, a renegade crew aboard a small spacecraft tries to survive as they travel the unknown parts of the galaxy and evade warring factions as well as authority agents out to get them."
        firefly.posterUrl = "https://m.media-amazon.com/images/M/MV5BOTcwNzkwMDItZmM1OC00MmQ2LTgxYjgtOTNiNDgxZDAxMjk0XkEyXkFqcGdeQXVyNDQ0MTYzMDA@._V1_SX300.jpg%22"
        shows.append(firefly)
        // Do any additional setup after loading the view.

        TitleLabel.text = firefly.title
        PlotLabel.text = firefly.plot

        ShowTable.dataSource = self
        ShowTable.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("parent controller: prepare for segue \(segue.identifier)")
        if segue.identifier == "showSearch" {
            if let searchViewController = segue.destination as? SearchViewController {
                searchViewController.parentController = self
            }
        }
    }

    func addShow(_ newShow: Show) {
        // TODO: persist shows collection
        shows.append(newShow)
        ShowTable.beginUpdates()
        ShowTable.insertRows(at: [IndexPath(row: shows.count-1, section: 0)], with: .automatic)
        ShowTable.endUpdates()
    }

    @IBOutlet weak var PlotLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ShowTable: UITableView!
}
