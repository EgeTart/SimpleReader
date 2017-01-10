//
//  Article.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/10.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import Foundation

class ArticleTitle {
    let id: Int!
    let title: String!
    let chineseTitle: String!
    
    init(id: Int!, title: String!, chineseTitle: String!) {
        self.id = id
        self.title = title.trimmingCharacters(in: CharacterSet.init(charactersIn: "\n"))
        self.chineseTitle = chineseTitle.trimmingCharacters(in: CharacterSet.init(charactersIn: "\n"))
    }
    
}



class ArticleContent {
    let content: String!
    let translate: String!
    
    init(content: String!, translate: String!) {
        self.content = content
        self.translate = translate
    }
}
