//
//  TopNewsPappersTableViewCell.swift
//  NewsApp
//
//  Created by Ideal Cocaj on 25.11.21.
//

import UIKit

class TopNewsPappersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var country: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
