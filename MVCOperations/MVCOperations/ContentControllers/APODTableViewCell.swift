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
            apodTitleLabel.textColor = .white
            apodTitleLabel.text = ""
        }
    }
    
    private var downloadImageOperation: DownloadImageOperation?
    private var apod: APOD? {
        didSet {
            guard let apod = apod else { return }
            apodTitleLabel.text = apod.title
        }
    }

    func configure(with apod: APOD, queue: OperationQueue) {
        self.apod = apod
        downloadImage(with: apod.url, queue: queue)
    }
    
    func downloadImage(with url: URL, queue: OperationQueue) {
        downloadImageOperation?.cancel()
        
        let downloadOperation = DownloadImageOperation(url: url) { [weak self] (image, imageURL) in
            guard
                let image = image,
                let imageURL = imageURL,
                imageURL == url
            else {
                DispatchQueue.main.async {
                    self?.apodImageView.image = nil
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.apodImageView.image = image
            }
        }
        
        queue.addOperation(downloadOperation)
        downloadImageOperation = downloadOperation
    }
}
