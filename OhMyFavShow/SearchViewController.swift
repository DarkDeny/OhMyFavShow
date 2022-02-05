//
//  SearchViewController.swift
//  OhMyFavShow
//
//  Created by Dmitry Denisov on 26.01.2022.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var parentController: ViewController?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { foundShows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: "searchShowCell", for: indexPath) as! SearchShowsTableViewCell

        let currentShow = foundShows[indexPath.item]
        cell.titleLabel.text = currentShow.title
        cell.plotLabel.text = currentShow.plot
        cell.yearLabel.text = String(currentShow.year)
        cell.likeButton.tag = indexPath.item
        displayImage(indexPath.item, cell: cell)

        return cell
    }

    var knownImages = [String : Data]()
    func displayImage(_ row: Int, cell: SearchShowsTableViewCell) {
        if let index = knownImages.index(forKey: foundShows[row].posterUrl!) {
            print("found in cache: \(foundShows[row].posterUrl!)")
            var data = knownImages[index].value
            let image = UIImage(data: data)
            cell.posterImageView?.image = image
            return
        }

        let url: String = (URL(string: foundShows[row].posterUrl!)?.absoluteString)!
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error!)
                        return
                    }

                    DispatchQueue.main.async(execute: {
                        let image = UIImage(data: data!)
                        self.knownImages[url] = data!
                        cell.posterImageView?.image = image
                    })
                })
                .resume()
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
    
    @IBAction func startSearch(withSender: UIButton){
        let searchTerm = searchTerms.text!
        if searchTerm.count > 2 {
            foundShows.removeAll()
            searchResultsTableView.reloadData()
            searchActivityIndicator.startAnimating()
            let url = "https://www.omdbapi.com/?apikey=aceb2294&type=series&s=\(searchTerm)"
            HTTPHandler.getJson(urlString: url, completionHandler: parseShowsData)
        }
    }

    func parseShowsData(showData: Data?) {
        if let showData = showData {
            let object = JSONParser.parse(data: showData)
            if let object = object {
                foundShows = ShowDataProcessor.mapJson(object: object, dataKey: "Search")
                for show in foundShows {
                    print("Requesting details for: \(show.imdbId)")
                    // TODO: remove API key!
                    let url = URL.init(string: "https://www.omdbapi.com/?apikey=aceb2294&type=series&i=\(show.imdbId)")
                    URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
                        guard let data = data, error == nil else { return }

                        let decoder = JSONDecoder()
                        do {
                            let detailsObject = try! decoder.decode(Show.self, from: data)
                            show.plot = detailsObject.plot
                            show.posterUrl = detailsObject.posterUrl
                            print("success for \(detailsObject.title)")
                            show.loaded = true
                            self.onShowImageLoaded()
                        }
                        catch {
                            print(error)
                        }
                    }).resume()
                }
            }
        }
    }

    func onShowImageLoaded() {
        var allLoaded = true
        for show in foundShows {
            if !show.loaded {
                allLoaded = false
                break
            }
        }

        if allLoaded {
            DispatchQueue.main.async() {
                self.searchResultsTableView.reloadData()
                self.searchActivityIndicator.stopAnimating()
            }
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
