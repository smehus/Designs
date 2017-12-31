//
//  APODCellViewModel.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/31/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol APODCellViewModel {
    var image: MutableProperty<UIImage?> { get set }
    var title: MutableProperty<String?> { get set }
    init(apod: APOD, imageDownloader: ImageDownloader)
}

struct APODCollectionViewCellViewModel: APODCellViewModel {
    
    var image = MutableProperty<UIImage?>(nil)
    var title = MutableProperty<String?>("")
    
    var apod: APOD? {
        didSet {
            guard let apod = apod else { return }
            title.value = apod.title
        }
    }
    
    private let imageDownloader: ImageDownloader
    
    init(apod: APOD, imageDownloader: ImageDownloader) {
        self.apod = apod
        self.imageDownloader = imageDownloader
    }
    
    private func fetchImage() {
        
    }
}
