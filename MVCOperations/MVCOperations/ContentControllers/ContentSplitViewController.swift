//
//  ContentSplitViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/21/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class ContentSplitViewController: UISplitViewController {
    
    private enum Segues: String {
        case apodDetailSegue = "apodDetailSegue"
    }

    var dataSource: AnyListDataSource<APODCellModel>? {
        didSet {
            guard
                let source = dataSource,
                let master = masterViewController
            else { return }
            
            master.dataSource = source
        }
    }
    
    private var masterViewController: MasterTableViewController? {
        return (viewControllers.first as? UINavigationController)?.viewControllers.first as? MasterTableViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        masterViewController?.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let identifier = segue.identifier,
            let seg = Segues(rawValue: identifier)
        else { return }
        
        switch seg {
        case .apodDetailSegue:
            guard let apod = sender as? APODCellModel else { return }
            prepareDetail(segue: segue, apod: apod)
        }
    }
    
    private func prepareDetail(segue: UIStoryboardSegue, apod: APODCellModel) {
        guard let detail = segue.destination as? DetailViewController else { return }
        detail.apod = apod
    }
}

extension ContentSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

extension ContentSplitViewController: MasterDelegate {
    func didSelect(apod: APODCellModel) {
        performSegue(withIdentifier: Segues.apodDetailSegue.rawValue, sender: apod)
    }
}

extension ContentSplitViewController: StoryboardInstantiable {
    static func instantiateFromStoryboard() -> ContentSplitViewController {
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        return storyboard.instantiateInitialViewController() as! ContentSplitViewController
    }
}
