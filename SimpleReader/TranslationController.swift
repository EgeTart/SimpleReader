//
//  TranslationController.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/10.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import UIKit

class TranslationController: UIViewController {

    @IBOutlet weak var translationTextView: UITextView!
    
    // 文章译文内容
    var translation: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translationTextView.text = translation
        
        NotificationCenter.default.addObserver(self, selector: #selector(ArticleController.preferredContentSizeChanged(notification:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
    }
    
    func preferredContentSizeChanged(notification: Notification) {
        translationTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }
}
