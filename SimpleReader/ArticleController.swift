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
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleTextView.text = article
        
        articleTextView.delegate = self
        
        toolbarBottomConstraint.constant = -44.0
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
