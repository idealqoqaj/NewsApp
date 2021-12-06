//
//  TopNewsPapperModel.swift
//  NewsApp
//
//  Created by Ideal Cocaj on 25.11.21.
//

import Foundation

struct TopNewsPapperModel: Decodable {
    var sources: [Sources]
}

struct Sources: Decodable {
    var name: String?
    var description: String?
    var url: String?
    var category: String?
    var language: String?
    var country: String?
}
