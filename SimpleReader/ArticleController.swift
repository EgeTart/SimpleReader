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
    @IBOutlet weak var filterButtonItem: UIBarButtonItem!
    
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
    var endLevel = 6
    
    var isFilterRangeViewShowed = false
    
    // 显示进行单词过滤的slider
    lazy var filterRangeView: FilterRangeView = {
        
        let width = UIScreen.main.bounds.width - 20.0
        let height: CGFloat = 100.0
        
        let x: CGFloat = 10.0
        let y = self.toolbar.frame.origin.y - 120.0
        
        let tempFilterRangeView = FilterRangeView(frame: CGRect(x: x, y: y, width: width, height: height))
        
        tempFilterRangeView.sliderView.delegate = self
        
        return tempFilterRangeView
    }()
    
    // 得到UIPageViewController的 scrollView, 以便禁止UIPageViewController的滑动
    lazy var parentScrollView: UIScrollView = {
        var scrollView: UIScrollView!
        
        let parentController = self.parent! as! UIPageViewController
        
        for subview in parentController.view.subviews {
            if subview.isKind(of: UIScrollView.self) {
                scrollView = subview as! UIScrollView
                break
            }
        }
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createArticleTextView()
        
        toolbarBottomConstraint.constant = -44.0
        
        filterButtonItem.isEnabled = false
        
        self.view.bringSubview(toFront: toolbar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ArticleController.preferredContentSizeChanged(notification:)), name: NSNotification.Name.UIContentSizeCategoryDidChange, object: nil)
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
    
    func highlightWords(satrtLevel: Int, endLevel: Int) {
        
        clearHighlight()

        for level in satrtLevel...min(endLevel, wordsToHighlight.count - 1) {
            let words = wordsToHighlight[level]
            
            for word in words {
                let range = (article as NSString).range(of: " \(word) ", options: .regularExpression)
                articleTextView.textStorage.setAttributes(highlightAttributes, range: range)
            }
        }
    }
    
    func clearHighlight() {
        articleTextView.textStorage.setAttributes(normalAttributes, range: NSMakeRange(0, (article as NSString).length))
    }
    
    func preferredContentSizeChanged(notification: Notification) {
        articleTextView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    @IBAction func highlightWords(_ sender: UIBarButtonItem) {
        if isHighlight {
            clearHighlight()
            filterButtonItem.isEnabled = false
        }
        else {
            highlightWords(satrtLevel: startLevel, endLevel: endLevel)
            filterButtonItem.isEnabled = true
        }
        
        isHighlight = !isHighlight
    }
    
    @IBAction func filterWords(_ sender: UIBarButtonItem) {
        if isFilterRangeViewShowed {
            filterRangeView.removeFromSuperview()
            parentScrollView.isScrollEnabled = true
        }
        else {
            self.view.addSubview(filterRangeView)
            parentScrollView.isScrollEnabled = false
        }
        
        isFilterRangeViewShowed = !isFilterRangeViewShowed
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

extension ArticleController: NHRangeSliderViewDelegate {
    
    func sliderValueChanged(slider: NHRangeSlider?) {
        startLevel = Int(slider!.lowerValue)
        endLevel = Int(slider!.upperValue)
        
        highlightWords(satrtLevel: startLevel, endLevel: endLevel)
        
        print(startLevel, endLevel)
    }
}
