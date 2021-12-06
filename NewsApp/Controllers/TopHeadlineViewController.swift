//
//  TopHeadlineViewController.swift
//  NewsApp
//
//  Created by Ideal Cocaj on 25.11.21.
//

import UIKit
import Alamofire

class TopHeadlineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var topNewsPappers = [Sources]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchAPIForTopHeadlines()
        navigationItem.title = "Top News Papper 📰"
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TopNewsPappersTableViewCell", bundle: nil), forCellReuseIdentifier: "TopNewsPappersTableViewCell")
    }
    
    func fetchAPIForTopHeadlines(){
        AF.request("https://newsapi.org/v2/top-headlines/sources?apiKey=9dc1da1f879b4a93848d5825851ee9e9", method: .get, encoding: JSONEncoding.default).responseDecodable(of: TopNewsPapperModel.self) { response in
            self.topNewsPappers = response.value?.sources ?? [Sources]()
            self.tableView.reloadData()
            
            guard response.error == nil else {
                print("Something went wrong on News View Controller")
                return
            }
        }
    }
}

extension TopHeadlineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopNewsPappersTableViewCell", for: indexPath) as! TopNewsPappersTableViewCell
        
        cell.titleLabel.text = topNewsPappers[indexPath.row].name
        cell.country.text = (topNewsPappers[indexPath.row].country)?.uppercased()
        cell.language.text = (topNewsPappers[indexPath.row].language)?.uppercased()
        cell.descriptionLbl.text = topNewsPappers[indexPath.row].description
        cell.category.text = topNewsPappers[indexPath.row].category
        cell.shadowLayer.layer.cornerRadius = 20
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topNewsPappers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: topNewsPappers[indexPath.row].url ?? "") {
            if #available(iOS 10, *){
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
}



