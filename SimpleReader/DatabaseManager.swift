//
//  DatabaseManager.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/10.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import Foundation
import FMDB

class DatabaseManager {
    
    static let sharedManager = DatabaseManager()
    
    private var database: FMDatabase!
    
    private init() {
        
        guard let path = Bundle.main.path(forResource: "nce_articles", ofType: "sqlite3") else { return }
        
        database = FMDatabase(path: path)
        database.open()
    }
    
    func loadArticlesTitles() -> [ArticleTitle] {
        let queryAllArticlesTitles = "SELECT id, title, chinese_title FROM articles"
        
        var allArticlesTitles = [ArticleTitle]()
        
        do {
            let titleRecords = try database.executeQuery(queryAllArticlesTitles, values: nil)
            
            while titleRecords.next() {
                let id = Int(titleRecords.int(forColumn: "id"))
                let title = titleRecords.string(forColumn: "title")
                let chineseTitle = titleRecords.string(forColumn: "chinese_title")
                
                let articleTitle = ArticleTitle(id: id, title: title, chineseTitle: chineseTitle)
                
                allArticlesTitles.append(articleTitle)
            }
        }
        catch {
            print(error)
        }
        
        return allArticlesTitles
    }
    
    func loadArticleContent(articleID id: Int) -> ArticleContent! {
        let queryArticleContent = "SELECT article, translate FROM articles WHERE id = ?"
        
        var articleContent: ArticleContent!
        
        do {
            let contentRecord = try database.executeQuery(queryArticleContent, values: [id])
            
            if contentRecord.next() {
                let content = contentRecord.string(forColumn: "article")
                let translate = contentRecord.string(forColumn: "translate")
                
                articleContent = ArticleContent(content: content, translate: translate)
                
            }
        }
        catch {
            print(error)
        }
        
        return articleContent
    }
    
    deinit {
        database.close()
    }
}
