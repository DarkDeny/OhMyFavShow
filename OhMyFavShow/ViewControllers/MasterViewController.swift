//
// Created by Dmitry Denisov on 19.02.2022.
//

import Foundation
import UIKit

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var showTable = UITableView()
    var searchBtn = UIButton()
    var typedParent: MainViewController?

    func select(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        showTable.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition(rawValue: 0)!)
        tableView(showTable, didSelectRowAt: indexPath)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBtn.setTitle("Search", for: .normal)
        searchBtn.addTarget(self, action: #selector(onSearchTouch), for: .touchUpInside)
        searchBtn.setTitleColor(UIColor.label, for: .normal)
        showTable = UITableView.init(frame: view.frame, style: .plain)
        showTable.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.cellId)
        showTable.dataSource = self
        showTable.delegate = self

        view.addSubview(showTable)
        view.addSubview(searchBtn)

        showTable.translatesAutoresizingMaskIntoConstraints = false
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showTable.widthAnchor.constraint(equalTo: view.widthAnchor),
            showTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            showTable.topAnchor.constraint(equalTo: view.topAnchor),
            showTable.bottomAnchor.constraint(equalTo: searchBtn.topAnchor, constant: -20),

            searchBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            searchBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func onSearchTouch() {
        typedParent!.onSearchTouch()
    }

    func onShowAppended() {
        showTable.beginUpdates()
        showTable.insertRows(at: [IndexPath(row: typedParent!.shows.count - 1, section: 0)], with: .automatic)
        showTable.endUpdates()
    }

    // MARK - Table delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { typedParent!.shows.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewCell.cellId, for: indexPath) as! ShowTableViewCell
        let targetShow = typedParent!.shows[indexPath.item]

        cell.showTitle.text = targetShow.name
        if (targetShow.unseenEpisodes > 0) {
            cell.unseenCount.isHidden = false
            cell.unseenCount.text = String(targetShow.unseenEpisodes)
        } else {
            cell.unseenCount.isHidden = true
        }

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { _, _, actionPerformed in
            self.typedParent!.removeAt(index: indexPath.item)
            self.showTable.deleteRows(at: [indexPath], with: .fade)
            actionPerformed(true)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        typedParent!.didSelected(show: typedParent!.shows[indexPath.item])
    }
}
