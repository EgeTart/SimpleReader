//
//  ViewController.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/10.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import UIKit

class TitleListController: UIViewController {

    @IBOutlet weak var titleTableView: UITableView!
    
    let databaseManager = DatabaseManager.sharedManager
    
    var articlesTitles: [ArticleTitle]!
    
    var selectedArticleTitle: ArticleTitle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        articlesTitles = databaseManager.loadArticlesTitles()
        print(articlesTitles.count)
        
        titleTableView.dataSource = self
        titleTableView.delegate = self
        
        titleTableView.rowHeight = UITableViewAutomaticDimension
        titleTableView.estimatedRowHeight = 60.0
        titleTableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowArticle" {
            let articleContainerController = segue.destination as! ArticleContainerController
            articleContainerController.articleTitle = selectedArticleTitle
        }
    }
}


extension TitleListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let titleCell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        
        let articleTitle = articlesTitles[indexPath.row]
        
        titleCell.textLabel?.text = articleTitle.title
        titleCell.detailTextLabel?.text = articleTitle.chineseTitle
        
        return titleCell
    }
}


extension TitleListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedArticleTitle = articlesTitles[indexPath.row]
        
        performSegue(withIdentifier: "ShowArticle", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
