//
//  ArticleController.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/10.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import UIKit

class ArticleController: UIViewController {

    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
    var articleTextView: UITextView!
    var textStorage: HighlightTextStorage!
    
    var article: String!
    
    var isDragging = false
    var startOffsetY: CGFloat = 0.0
    
    // 设置是否隐藏toolbar
    var isHideToobar = true {
    
        // 改变toolbar的底部constraint值, 从而隐藏或显示toolbar
        willSet {
            if newValue {
                toolbarBottomConstraint.constant = -44.0
            }
            else {
                toolbarBottomConstraint.constant = 0.0
            }
            
            UIView.animate(withDuration: 0.33, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    let highlightAttributes = [NSForegroundColorAttributeName: UIColor.red, NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
    let normalAttributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
    
    lazy var wordsToHighlight: [[String]] = {
        let databaseManager = DatabaseManager.sharedManager
        return databaseManager.loadWords()
    }()
    
    var isHighlight = false
    var startLevel = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createArticleTextView()
        
        toolbarBottomConstraint.constant = -44.0
        
        self.view.bringSubview(toFront: toolbar)
    }
    
    override func viewDidLayoutSubviews() {
        articleTextView.frame = view.bounds
    }
    
    func createArticleTextView() {

        let attributesString = NSAttributedString(string: article, attributes: normalAttributes)
        textStorage = HighlightTextStorage()
        
        let textViewRect = view.bounds
        
        let layoutManager = NSLayoutManager()
        
        let containerSize = CGSize(width: textViewRect.width, height: CGFloat.greatestFiniteMagnitude)
        let textContainer = NSTextContainer(size: containerSize)
        textContainer.widthTracksTextView = true
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        articleTextView = UITextView(frame: textViewRect, textContainer: textContainer)
        articleTextView.isEditable = false

        articleTextView.textStorage.setAttributedString(attributesString)
        articleTextView.delegate = self
        view.addSubview(articleTextView)
    }
    
    func highlight(satrtLevel: Int) {
        
        articleTextView.textStorage.setAttributes(normalAttributes, range: NSMakeRange(0, (article as NSString).length))

        for level in satrtLevel..<wordsToHighlight.count {
            let words = wordsToHighlight[level]
            
            for word in words {
                let range = (article as NSString).range(of: " \(word) ", options: .regularExpression)
                articleTextView.textStorage.setAttributes(highlightAttributes, range: range)
            }
        }
    }
    
    @IBAction func highlightWords(_ sender: UIBarButtonItem) {
        highlight(satrtLevel: startLevel)
        
        startLevel += 1
    }
    
    @IBAction func filetrWords(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func changeFontSize(_ sender: UIBarButtonItem) {
    }
}


extension ArticleController: UITextViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
        startOffsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 根据向上和向下的拖拽, 决定toolbar的隐藏显示状态
        if isDragging {
            let currentOffsetY = scrollView.contentOffset.y
            
            if currentOffsetY < startOffsetY {
                isHideToobar = false
            }
            else if currentOffsetY > startOffsetY {
                isHideToobar = true
            }
        }
    }
    
}
