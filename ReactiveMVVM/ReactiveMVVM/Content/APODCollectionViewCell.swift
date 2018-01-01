//
//  APODCollectionViewCell.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/31/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class APODCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet private var title: UILabel! {
        didSet {
            title.text = ""
        }
    }
    
    @IBOutlet private var apodImageView: UIImageView!
    
    func configure(with viewModel: APODCellViewModel) {
        title.reactive.text <~ viewModel.title.signal
//        apodImageView.reactive.image <~ viewModel.image.signal
    }
}
