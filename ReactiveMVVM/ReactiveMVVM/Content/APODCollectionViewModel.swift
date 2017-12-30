//
//  APODCollectionViewModel.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/30/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation
import CoreData

protocol APODCollectionViewModel {
    
    init(coreDataStack: CoreDataStack)
    
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func viewModel(for indexPath: IndexPath) -> APOD?
}

class APODCollectionViewControllerViewModel: NSObject, APODCollectionViewModel {
    
    private let coreDataStack: CoreDataStack
    private let fetchedResultsController: NSFetchedResultsController<APOD>
    
    required init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        fetchedResultsController = NSFetchedResultsController(fetchRequest: APOD.fetchRequest(), managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        makeFetch()
    }
    
    private func makeFetch() {
        fetchedResultsController.managedObjectContext.perform {
            do {
                try self.fetchedResultsController.performFetch()
                if self.fetchedResultsController.fetchedObjects?.isEmpty == false {
                    DispatchQueue.main.async {
                        // perform update
                    }
                }
            } catch let error as NSError {
                print("Error performing fetch \(error.localizedDescription)")
            }
        }
    }
}

extension APODCollectionViewControllerViewModel {
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard
            let allSections = fetchedResultsController.sections,
            allSections.count > section,
            let section = fetchedResultsController.sections?[section]
        else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    func viewModel(for indexPath: IndexPath) -> APOD? {
        guard let allSections = fetchedResultsController.sections else { return nil}
        guard allSections.count > indexPath.section else { return nil }
        guard allSections[indexPath.section].numberOfObjects > indexPath.row else { return nil }
        return fetchedResultsController.object(at: indexPath)
    }
}

/*
@objc
extension NSFetchedResultsController {
    // Can't do this???
    @objc func safeObject(at indexPath: IndexPath) -> ResultType? {
        guard let allSections = sections else { return nil}
        guard allSections.count > indexPath.section else { return nil }
        guard allSections[indexPath.section].numberOfObjects > indexPath.row else { return nil }
        return allSections[indexPath.section].objects?[indexPath.row] as? ResultType
    }
}
*/

extension APODCollectionViewControllerViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("content changed")
    }
}