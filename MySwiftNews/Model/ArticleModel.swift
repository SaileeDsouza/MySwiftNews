//
//  NewsModel.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-21.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation

// MARK: - News
struct News: Codable {
    let kind: String?
    let data: NewsData?
}

// MARK: - NewsData
struct NewsData: Codable {
    let modhash: String?
    let dist: Int?
    let children: [Child]?
    let after: String?
    let before: String?
}

// MARK: - Child
struct Child: Codable {
    let kind: String?
    let data: ChildData?
}

// MARK: - ChildData
struct ChildData: Codable {
    let title: String?
    let thumbnail: String?
    let thumbnail_height: Int?
    let selftext_html: String?
}

// MARK: - ArticleViewModel
struct ArticleModel {
    let title: String
    let thumbnailUrl: String?
    let thumbnail_height: Int
    let articleData: String?
}

// MARK: - ErrorModel
struct ErrorModel: Codable {
    let errorCode:Int
    let message: String
    
    enum codingKeys: String, CodingKey  {
        case message
        case errorCode = "error"
    }
}
