//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Ideal Cocaj on 24.11.21.
//

import UIKit
import Alamofire


class NewsViewController: UIViewController {
    
    @IBOutlet weak var iCarouselView: iCarousel!
    @IBOutlet weak var tableView: UITableView!
    
    var newsModel = [ArticlesModel]()
    var topHeadlines = [ArticlesModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCarousel()
        setupTableView()
        fetchAPI()
        fetchAPIForTopHeadlines()
        navigationItem.title = "News App 📰"
    }
    
    func setupCarousel(){
        iCarouselView.contentMode = .scaleAspectFill
        iCarouselView.type = .rotary
        iCarouselView.isPagingEnabled = true
        iCarouselView.dataSource = self
        iCarouselView.delegate = self
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    
    func fetchAPIForTopHeadlines(){
        AF.request("https://newsapi.org/v2/top-headlines?country=us&apiKey=9dc1da1f879b4a93848d5825851ee9e9", method: .get, encoding: JSONEncoding.default).responseDecodable(of: NewsModel.self) { response in
            
            self.topHeadlines = response.value?.articles ?? [ArticlesModel]()
            self.tableView.reloadData()
            
            guard response.error == nil else {
                print("Something went wrong on News View Controller")
                return
            }
        }
    }
    
    func fetchAPI(){
        AF.request("https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=9dc1da1f879b4a93848d5825851ee9e9", method: .get, encoding: JSONEncoding.default).responseDecodable(of: NewsModel.self) { response in
            
            self.newsModel = response.value?.articles ?? [ArticlesModel]()
            self.iCarouselView.reloadData()
            
            guard response.error == nil else {
                print("Something went wrong on News View Controller")
                return
            }
        }
    }
}

extension NewsViewController: iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return newsModel.count
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController
        vc.topHeadlinesDetails = newsModel[index]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var imageView: UIImageView!
        
        if view == nil {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 50, height: 200))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 20
        } else {
            imageView = view as? UIImageView
        }
        imageView.setImage(url: URL(string: newsModel[index].urlToImage ?? ""))
        return imageView
    }
}

extension NewsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topHeadlines.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Latest News"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        let date = dateformatter.date(from: topHeadlines[indexPath.row].publishedAt ?? "")
        let time = dateformatter.string(from: date ?? Date())
        
        cell.dateNews.text = time
        cell.imageNews.setImage(url: URL(string: topHeadlines[indexPath.row].urlToImage ?? ""))
        cell.titleNews.text = topHeadlines[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController
        vc.topHeadlinesDetails = topHeadlines[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

