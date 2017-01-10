//
//  ArticleController.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/10.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import UIKit

class ArticleController: UIViewController {

    @IBOutlet weak var articleTextView: UITextView!
    
    var article: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTextView.text = article
    }

}
