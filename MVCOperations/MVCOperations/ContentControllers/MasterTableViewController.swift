//
//  MasterTableViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

protocol MasterDelegate: class {
    func didSelect(apod: APOD)
}

class MasterTableViewController: UITableViewController {
    
    weak var delegate: MasterDelegate?

    var dataSource: AnyListDataSource<APOD>? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Week"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(for: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdent", for: indexPath)
        if let apod = dataSource?.item(at: indexPath) {
            cell.textLabel?.text = apod.title
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let apod = dataSource?.item(at: indexPath) else { return }
        delegate?.didSelect(apod: apod)
    }
}
