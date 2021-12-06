//
//  NewsModel.swift
//  NewsApp
//
//  Created by Ideal Cocaj on 24.11.21.
//

import Foundation

struct NewsModel: Decodable {
    var totalResults: Int?
    var articles: [ArticlesModel]?
}

struct ArticlesModel: Decodable, Hashable{
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
}

