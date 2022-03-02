//
//  ViewController.swift
//  OhMyFavShow
//
//  Created by Dmitry Denisov on 23.01.2022.
//
//

import UIKit

class MainViewController: UIViewController {
    var shows = [Show]()
    var detailsVc : DetailsController?
    var masterVc : MasterViewController?
    var navVc: UINavigationController?

    // TODO: use DI for services!
    let persister = PersistenceService()

    override func viewDidLoad() {
        super.viewDidLoad()

        shows = persister.loadData()
        detailsVc = DetailsController.init()
        masterVc = MasterViewController.init()
        add(masterVc!)
        add(detailsVc!)

        masterVc!.view.translatesAutoresizingMaskIntoConstraints = false
        detailsVc!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            masterVc!.view.widthAnchor.constraint(equalToConstant: 400),
            masterVc!.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            masterVc!.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            masterVc!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

            detailsVc!.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            detailsVc!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            detailsVc!.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            detailsVc!.view.leftAnchor.constraint(equalTo: masterVc!.view.rightAnchor, constant: 20),
        ])

        masterVc!.typedParent = self
        detailsVc!.typedParent = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shows.count > 0 {
            masterVc!.select(row: 0)
            detailsVc!.didSelected(show: shows[0])
        }
    }

    func onSearchTouch() {
        let searchVc = SearchViewController()
        searchVc.parentController = self
        searchVc.navVc = navVc
        navVc!.pushViewController(searchVc, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearch" {
            if let searchViewController = segue.destination as? SearchViewController {
                searchViewController.parentController = self
            }
        }
    }

    func didSelected(show: Show) {
        detailsVc!.didSelected(show: show)
    }

    func addShow(_ newShow: Show) {
        Task {
            var detailedSeasons: [SeasonDetails]
            detailedSeasons = await ShowFetcher.downloadMultipleSeasonDetails(for: newShow)
            let detailedShow = Show.init(from: newShow, with: detailedSeasons)

            DispatchQueue.main.async {
                self.shows.append(detailedShow)
                self.masterVc!.onShowAppended()
                self.persister.save(data: self.shows)
            }
        }
    }

    func removeAt(index: Int) {
        shows.remove(at: index)
        persister.save(data: shows)
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}