//
//  APODTableViewCell.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class APODCellModel: NSObject {
    let apod: APOD
    @objc dynamic var image: UIImage?
    
    init(apod: APOD) {
        self.apod = apod
        super.init()
        downloadImage(with: apod.url)
    }
    
    
    func downloadImage(with url: URL) {
        
        let imageOperation = DownloadImageOperation(url: url)
        
        imageOperation.completionBlock = { [weak self] in
            DispatchQueue.main.async {
                self?.image = imageOperation.downloadedImage
            }
        }
        
        OperationQueue.main.addOperation(imageOperation)
    }
}

class APODTableViewCell: UITableViewCell {
    
    @IBOutlet private var blurView: UIVisualEffectView! {
        didSet {
            blurView.alpha = 0.75
        }
    }
    
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
    
    @IBOutlet private var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = .white
            dateLabel.text = ""
        }
    }
    
    private var observer: NSKeyValueObservation?
    
    private var model: APODCellModel? {
        didSet {
            guard let model = model else { return }
            
            apodTitleLabel.text = model.apod.title
            dateLabel.text = DateFormatter.apodDateFormatter.string(from: model.apod.date)
            
            if model.image == nil {
                observer = model.observe(\.image, changeHandler: { [weak self] (updatedModel, change) in
                    self?.apodImageView.image = updatedModel.image
                    self?.apodTitleLabel.textColor = .white
                })
            } else {
                apodImageView.image = model.image
                apodTitleLabel.textColor = .white
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        observer = nil
    }

    func configure(with model: APODCellModel) {
        self.model = model
        
    }
    
    func offsetImage(with offset: CGFloat) {
        CATransaction.begin()
        let contentCenter = (contentView.bounds.size.height / 2)
        apodImageView.layer.position.y = contentCenter * offset
        CATransaction.commit()
    }
}
