//
//  APODTableViewCell.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class APODTableViewCell: UITableViewCell {

    @IBOutlet private var apodImageView: UIImageView! {
        didSet {
            apodImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private var apodTitleLabel: UILabel! {
        didSet {
            apodTitleLabel.textColor = .black
            apodTitleLabel.text = ""
        }
    }
    
    private var apod: APOD? {
        didSet {
            guard let apod = apod else { return }
            apodTitleLabel.text = apod.title
        }
    }

    func configure(with apod: APOD) {
        self.apod = apod
        downloadImage(with: apod.url)
    }
    
    func downloadImage(with url: URL) {
        apodTitleLabel.textColor = .black
        apodImageView.image = nil
        
        let imageOperation = DownloadImageOperation(url: url)
        
        imageOperation.completionBlock = { [weak self] in
            DispatchQueue.main.async {
                self?.apodImageView.image = imageOperation.downloadedImage
            }
        }
        
        OperationQueue.main.addOperation(imageOperation)
    }
}
