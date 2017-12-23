//
//  MasterTableViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {

    var dataSource: AnyListDataSource<APOD>? {
        didSet {
            tableView.reloadData()
        }
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

        cell.textLabel?.text = "blah"

        return cell
    }
}
