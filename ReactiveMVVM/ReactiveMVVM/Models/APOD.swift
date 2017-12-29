//
//  APOD.swift
//  ReactiveMVVM
//
//  Created by scott mehus on 12/26/17.
//  Copyright © 2017 Mehus. All rights reserved.
//

import Foundation

enum MediaType: String {
    case image = "image"
    case video = "video"
}

/// Astronomy Picture of the Day
struct APOD: Codable {
    let copyright: String?
    let date: Date
    let explanation: String
    let hdurl: URL?
    let media_type: String
    let service_version: String
    let title: String
    let url: URL
    
    var mediaType: MediaType? {
        return MediaType(rawValue: media_type)
    }
}
