//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Ideal Cocaj on 24.11.21.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchVC = UISearchController(searchResultsController: nil)
    var topHeadlinesForGB = [ArticlesModel]()
    var searchNews = [ArticlesModel]()
    var searchURLString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar()
        fetchAPIForSearch()
        fetchAPIForTopHeadlinesForGB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
    }
    
    func fetchAPIForTopHeadlinesForGB(){
        AF.request("https://newsapi.org/v2/top-headlines?country=de&category=business&apiKey=9dc1da1f879b4a93848d5825851ee9e9", method: .get, encoding: JSONEncoding.default).responseDecodable(of: NewsModel.self) { response in
            self.topHeadlinesForGB = response.value?.articles ?? [ArticlesModel]()
            self.tableView.reloadData()
            
            guard response.error == nil else {
                print("Something went wrong on fetchAPIForTopHeadlinesForGB in SearchViewController")
                return
            }
        }
    }
    
    func fetchAPIForSearch(){
        AF.request(searchURLString, method: .get, encoding: JSONEncoding.default).responseDecodable(of: NewsModel.self) { response in
            self.searchNews = response.value?.articles ?? [ArticlesModel]()
            self.tableView.reloadData()
            
            guard response.error == nil else {
                print("Something went wrong on fetchAPIForSearch in SearchViewController")
                return
            }
        }
    }
    
    func searchBar(){
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        searchURLString = "https://newsapi.org/v2/everything?q=\(text)&apiKey=9dc1da1f879b4a93848d5825851ee9e9"
        fetchAPIForSearch()
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            searchNews = topHeadlinesForGB
        }
        self.tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        if searchVC.isActive {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd-MM-yyyy"
            if searchNews.count != 0 {
                let date = dateformatter.date(from: searchNews[indexPath.row].publishedAt ?? "")
                let time = dateformatter.string(from: date ?? Date())
                cell.dateNews.text = time
                cell.imageNews.setImage(url: URL(string: searchNews[indexPath.row].urlToImage ?? ""))
                cell.titleNews.text = searchNews[indexPath.row].title
            } else {
                return cell
            }
        } else {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd-MM-yyyy"
            let date = dateformatter.date(from: topHeadlinesForGB[indexPath.row].publishedAt ?? "")
            let time = dateformatter.string(from: date ?? Date())
            
            cell.dateNews.text = time
            cell.imageNews.setImage(url: URL(string: topHeadlinesForGB[indexPath.row].urlToImage ?? ""))
            cell.titleNews.text = topHeadlinesForGB[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchVC.isActive {
            return searchNews.count
        } else {
            return topHeadlinesForGB.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController

        if searchVC.isActive {
            vc.topHeadlinesDetails = searchNews[indexPath.row]
        } else {
            vc.topHeadlinesDetails = topHeadlinesForGB[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
