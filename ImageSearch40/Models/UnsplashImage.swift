//
//  UnsplashImage.swift
//  ImageSearch40
//
//  Created by Benjamin Tincher on 8/4/21.
//

import Foundation

struct UnsplashTopLevel: Codable {
    let results : [UnsplashImage]
}

struct UnsplashImage: Codable {
    let width: Int
    let height: Int
    let color: String
    let likes: Int
    let urls: UnsplashImageURLs
    let user: UnsplashUser
}

struct UnsplashImageURLs: Codable {
    let thumbnailURL: URL
    
    enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumb"
    }
}

struct UnsplashUser: Codable {
    let username: String
    let profileImage: UnsplashProfileImages
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case profileImage = "profile_image"
    }
}

struct UnsplashProfileImages: Codable {
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "medium"
    }
}
