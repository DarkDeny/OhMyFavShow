//
//  ViewController.swift
//  OhMyFavShow
//
//  Created by Dmitry Denisov on 23.01.2022.
//
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showTable: UITableView!
    @IBOutlet weak var posterImage: UIImageView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { shows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView requested data for row \(indexPath.item)")

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

        loadData()

        showTable.dataSource = self
        showTable.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shows.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            showTable.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
            tableView(showTable, didSelectRowAt: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableView didSelectRowAt \(indexPath)")
        titleLabel.text = shows[indexPath.item].title
        plotLabel.text = shows[indexPath.item].plot

        // TODO: cache image data on adding to favorites step!
        let url: String = (URL(string: shows[indexPath.item].posterUrl!)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error!)
                        return
                    }

                    DispatchQueue.main.async(execute: {
                        let image = UIImage(data: data!)
                        self.posterImage.image = image
                    })
                }).resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearch" {
            if let searchViewController = segue.destination as? SearchViewController {
                searchViewController.parentController = self
            }
        }
    }

    func addShow(_ newShow: Show) {
        shows.append(newShow)
        showTable.beginUpdates()
        showTable.insertRows(at: [IndexPath(row: shows.count-1, section: 0)], with: .automatic)
        showTable.endUpdates()
        saveData()
    }

    func getFileUrl() -> URL {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor:nil,
                create:true)
        let fileURL = documentDirectory.appendingPathComponent("ohMyFavShows").appendingPathExtension("json")
        return fileURL
    }

    func loadData() {
        do {
            let fileUrl = getFileUrl()
            let stringData = try String(contentsOf: fileUrl)
            let decoder = JSONDecoder()
            var bytes = [UInt8](stringData.utf8)
            var data = Data(bytes: bytes, count: bytes.count)
            shows = try! decoder.decode([Show].self, from: data)
            print("successfully loaded data!")
        } catch {
            print(error)
        }

        if shows == nil {
            shows = [Show]()
        }
    }

    func saveData() {
        do {
            let fileURL = getFileUrl()
            let encoder = JSONEncoder()
            let stringData = try encoder.encode(shows)
            try stringData.write(to: fileURL)
            print("updates were successfully saved! \(stringData)")
        } catch {
            print(error)
        }
    }

}
