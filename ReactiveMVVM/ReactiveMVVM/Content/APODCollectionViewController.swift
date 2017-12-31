//
//  APODCollectionViewController.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/30/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class APODCollectionViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    var viewModel: APODCollectionViewModel! {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(viewModel != nil)
    }
}

extension APODCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! APODCollectionViewCell
        if let model = viewModel.viewModel(for: indexPath) {
            cell.configure(with: model)
        }
        
        return cell
    }
}

extension APODCollectionViewController: UICollectionViewDelegate {
    
}
