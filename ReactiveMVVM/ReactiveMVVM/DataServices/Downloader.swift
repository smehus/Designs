//
//  Downloader.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/31/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import UIKit
import ReactiveCocoa

enum DownloadError: Error {
    
}

class Downloader {
    static let shared = Downloader()

    let session = SessionManager.sharedSession
    
    var documentsDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func downloadImage(with url: URL) {

    }
}
