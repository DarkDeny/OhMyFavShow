//
//  SearchViewController.swift
//  OhMyFavShow
//
//  Created by Dmitry Denisov on 26.01.2022.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var parentController: MainViewController?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { foundShows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "searchShowCell", for: indexPath) as! SearchShowsTableViewCell

        let currentShow = foundShows[indexPath.item]
        cell.titleLabel.text = currentShow.name
        cell.plotLabel.text = currentShow.overview
        cell.yearLabel.text = String(currentShow.year)
        cell.likeButton.tag = indexPath.item
        displayImage(indexPath.item, cell: cell)

        return cell
    }

    var knownImages = [String : Data]()
    func displayImage(_ row: Int, cell: SearchShowsTableViewCell) {
        if let fullPosterPath = foundShows[row].fullPosterPath {
            if let index = knownImages.index(forKey: fullPosterPath) {
                print("found in cache: \(fullPosterPath)")
                var data = knownImages[index].value
                let image = UIImage(data: data)
                cell.posterImageView?.image = image
                return
            }

            do {
                Task {
                    print("requesting img: \(fullPosterPath)")
                    let url = URL(string: fullPosterPath)
                    let (data, _) = try await URLSession.shared.data(from: url!)
                    let image = UIImage(data: data)
                    self.knownImages[url!.absoluteString] = data
                    cell.posterImageView?.image = image
                }
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }

    @IBOutlet var searchResultsTableView: UITableView!
    @IBOutlet var searchTerms: UITextField!
    @IBOutlet var searchActivityIndicator: UIActivityIndicatorView!

    @IBAction func likeTouchUpInside(_ sender: UIButton){
        let index = Int(sender.tag)
        let targetShow = foundShows[index]

        if let parentController = parentController {
            parentController.addShow(targetShow)
            let alert = UIAlertController.init(title: nil, message: "Added!", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)

            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }

    var foundShows = [Show]()
    
    @IBAction func startSearch(withSender: UIButton) {
        let searchTerm = searchTerms.text!
        if searchTerm.count > 2 {
            foundShows.removeAll()
            searchResultsTableView.reloadData()
            searchActivityIndicator.startAnimating()
            Task {
                foundShows = await ShowFetcher.fetch(for: searchTerm)
                print("found \(foundShows.count) show(s), stopping animation, reloading table data source")
                self.searchResultsTableView.reloadData()
                self.searchActivityIndicator.stopAnimating()
            }
        } else {
            // TODO: alert about not enough characters!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self

        // Auto layout
        let horizontalConstraint = searchActivityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = searchActivityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
