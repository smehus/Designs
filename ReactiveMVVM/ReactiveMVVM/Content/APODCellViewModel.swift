//
//  APODCellViewModel.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/31/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit
import ReactiveSwift
import Result

protocol APODCellViewModel: class {
    var image: MutableProperty<UIImage?> { get set }
    var title: MutableProperty<String?> { get set }
    init(apod: APOD, imageDownloader: ImageDownloader)
}

class APODCollectionViewCellViewModel: APODCellViewModel {
    
    var image = MutableProperty<UIImage?>(nil)
    var title = MutableProperty<String?>("")
    
    var apod: APOD {
        didSet {
            title.value = apod.title
        }
    }
    
    private let imageDownloader: ImageDownloader
    
    required init(apod: APOD, imageDownloader: ImageDownloader) {
        self.apod = apod
        title.value = apod.title
        self.imageDownloader = imageDownloader
        fetchImage()
    }
    
    private func fetchImage() {
        imageDownloader.downloadImage(with: NasaRequest.image(urlString: apod.url)).startWithResult { [weak self] (result) in
            guard case let Result.success(image) = result else { return }
            self?.image.value = image
        }
    }
}
