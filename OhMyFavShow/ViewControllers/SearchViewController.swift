//
//  SearchViewController.swift
//  OhMyFavShow
//
//  Created by Dmitry Denisov on 26.01.2022.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var parentController: MainViewController?
    var navVc: UINavigationController?

    var knownImages = [String : Data]()
    func displayImage(_ row: Int, cell: SearchShowsTableViewCell) {
        if let fullPosterPath = foundShows[row].fullPosterPath {
            if let index = knownImages.index(forKey: fullPosterPath) {
                print("found in cache: \(fullPosterPath)")
                let data = knownImages[index].value
                let image = UIImage(data: data)
                cell.posterImageView.image = image
                return
            }

            Task {
                print("requesting img: \(fullPosterPath)")
                let url = URL(string: fullPosterPath)
                let (data, _) = try await URLSession.shared.data(from: url!)
                let image = UIImage(data: data)
                self.knownImages[url!.absoluteString] = data
                cell.posterImageView.image = image
            }
        }
    }
    
    var foundShows = [Show]()
    var searchTerms = UITextField()
    var startSearchBtn = UIButton()
    var searchResultsTableView = UITableView()
    var searchActivityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchTerms.placeholder = "Type show name..."
        searchTerms.textColor = UIColor.label
        searchTerms.layer.borderColor = UIColor.black.cgColor

        startSearchBtn.setTitle("Search", for: .normal)
        startSearchBtn.addTarget(self, action: #selector(onSearchTouch), for: .touchUpInside)
        startSearchBtn.setTitleColor(UIColor.label, for: .normal)

        view.addSubview(searchTerms)
        view.addSubview(startSearchBtn)
        view.addSubview(searchActivityIndicator)
        view.addSubview(searchResultsTableView)
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = true

        searchResultsTableView.register(SearchShowsTableViewCell.self, forCellReuseIdentifier: SearchShowsTableViewCell.cellId)
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self

        searchTerms.translatesAutoresizingMaskIntoConstraints = false
        startSearchBtn.translatesAutoresizingMaskIntoConstraints = false
        searchActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTerms.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            searchTerms.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            searchTerms.rightAnchor.constraint(equalTo: startSearchBtn.leftAnchor, constant: -20),

            startSearchBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            startSearchBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),

            searchResultsTableView.topAnchor.constraint(equalTo: searchTerms.bottomAnchor, constant: 20),
            searchResultsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchResultsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            searchActivityIndicator.centerXAnchor.constraint(equalTo: searchResultsTableView.centerXAnchor),
            searchActivityIndicator.centerYAnchor.constraint(equalTo: searchResultsTableView.centerYAnchor),
        ])
    }

    @objc func onSearchTouch(_ sender: AnyObject) {
        print(sender.self)
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

    // MARK: - table delegate and data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { foundShows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchResultsTableView.dequeueReusableCell(withIdentifier: SearchShowsTableViewCell.cellId, for: indexPath) as! SearchShowsTableViewCell

        let currentShow = foundShows[indexPath.item]
        cell.titleLabel.text = currentShow.name
        cell.plotLabel.text = currentShow.overview
        cell.yearLabel.text = String(currentShow.year)
        cell.likeButton.tag = indexPath.item
        print("setting selector \(cell.likeButton.isEnabled)")
         //startSearchBtn.addTarget(self, action: #selector(onSearchTouch), for: .touchUpInside)
        cell.likeButton.addTarget(self, action: #selector(likeTouchUpInside), for: .touchUpInside)
        print("selector is set")
        displayImage(indexPath.item, cell: cell)

        return cell
    }

    @objc func likeTouchUpInside(_ sender: UIButton) {
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}
