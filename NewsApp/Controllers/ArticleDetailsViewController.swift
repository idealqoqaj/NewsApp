//
//  ArticleDetailsViewController.swift
//  NewsApp
//
//  Created by Ideal Cocaj on 25.11.21.
//

import UIKit

class ArticleDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    var topHeadlinesDetails = ArticlesModel()
    
    @IBOutlet weak var readMore: UIButton!
    @IBOutlet weak var dateNews: UILabel!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var titleNews: UILabel!
    @IBOutlet weak var descriptionView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func GoogleButton(_ sender: Any) {
        if let url = URL(string: topHeadlinesDetails.url ?? "") {
            if #available(iOS 10, *){
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func setupNavigation(){
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationItem.title = "Article Details 📰"
    }
    
    func setupUI() {
        orangeView.layer.cornerRadius = 10
        imageNews.layer.cornerRadius = 20
        readMore.layer.cornerRadius = 20
        descriptionView.isEditable = false
        
        let date = Date().addingTimeInterval(-15000)
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let string = formatter.localizedString(for: date, relativeTo: Date())
        
        dateNews.text = string
        titleNews.text = topHeadlinesDetails.title
        descriptionView.text = topHeadlinesDetails.description
        
        if let imageURL =  topHeadlinesDetails.urlToImage {
            imageNews.setImage(url: URL(string: imageURL))
        }
    }
}
