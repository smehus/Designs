//
//  DetailViewController.swift
//  MVCOperations
//
//  Created by scott mehus on 12/23/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var apod: APODCellModel? {
        didSet {
            guard isViewLoaded else { return }
            populate()
        }
    }
    
    @IBOutlet private var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = 1.0
            scrollView.maximumZoomScale = 4.0
        }
    }
    @IBOutlet private var apodImageView: UIImageView! {
        didSet {
            apodImageView.contentMode = .scaleAspectFit
        }
    }
    
    private var token: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token = nil
    }
    
    private func populate() {
        guard let model = apod else { return }
        if let image = model.image {
            apodImageView.image = image
        } else {
            token = model.observe(\.image, changeHandler: { [weak self] (cellModel, change) in
                self?.apodImageView.image = cellModel.image
            })
        }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return apodImageView
    }
}
