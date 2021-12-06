//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Ideal Cocaj on 24.11.21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateNews: UILabel!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageNews.layer.cornerRadius = 20
    }
}
