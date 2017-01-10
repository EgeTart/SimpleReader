//
//  ArticleController.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/10.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import UIKit

class ArticleContainerController: UIViewController {

    var pageViewController: UIPageViewController!
    
    var articleController: ArticleController!
    var translationController: TranslationController!
    
    let databaseManager = DatabaseManager.sharedManager
    
    var articleTitle: ArticleTitle!
    var articleContent: ArticleContent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleContent = databaseManager.loadArticleContent(articleID: articleTitle.id)
        
        pageViewController = self.childViewControllers[0] as! UIPageViewController
        
        articleController = storyboard?.instantiateViewController(withIdentifier: "ArticleControllerID") as! ArticleController
        articleController.article = articleContent.content
        
        translationController = storyboard?.instantiateViewController(withIdentifier: "TranslationControllerID") as! TranslationController
        translationController.translation = articleContent.translate
        
        pageViewController.setViewControllers([articleController], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
    }

    
    /// 点击按钮切换文章的类型(原文或者译文)
    ///
    /// - Parameter sender: 文章上方的原文或译文按钮
    @IBAction func switchArticleType(_ sender: UIButton) {
        if sender.tag == 101 {
            pageViewController.setViewControllers([articleController], direction: .reverse, animated: true, completion: nil)
        }
        else {
            pageViewController.setViewControllers([translationController], direction: .forward, animated: true, completion: nil)
        }
    }
    
}


extension ArticleContainerController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: TranslationController.self) {
            return articleController
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: ArticleController.self) {
            return translationController
        }
        
        return nil
    }
}
