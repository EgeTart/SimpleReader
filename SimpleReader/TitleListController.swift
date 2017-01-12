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
    
    @IBAction func showSearchBar(_ sender: UIBarButtonItem) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
extension TitleListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedArticleTitle = articlesTitles[indexPath.row]
        
        performSegue(withIdentifier: "ShowArticle", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - 简单文章搜索
extension TitleListController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let searchText = searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        dismiss(animated: true, completion: nil)
        
        if searchText != "" {
            for (index, articleTitle) in articlesTitles.enumerated() {
                if articleTitle.title.lowercased().contains(searchText.lowercased()) || articleTitle.chineseTitle.contains(searchText) {
                    let indexPath = IndexPath(row: index, section: 0)
                    titleTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    break
                }
            }
        }
        
        searchBar.text = nil
    }
}
