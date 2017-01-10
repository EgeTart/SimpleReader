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
    
    var translation: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        translationTextView.text = translation
    }

}
