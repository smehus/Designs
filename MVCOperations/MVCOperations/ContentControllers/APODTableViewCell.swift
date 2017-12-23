//
//  APODTableViewCell.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class APODTableViewCell: UITableViewCell {

    @IBOutlet private var apodImageView: UIImageView!
    @IBOutlet private var apodTitleLabel: UILabel! {
        didSet {
            apodTitleLabel.text = ""
        }
    }

    func configure(with apod: APOD) {
        apodTitleLabel.text = apod.title
    }
}
