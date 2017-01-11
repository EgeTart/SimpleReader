//
//  CustomTextStorage.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/10.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import UIKit
import Foundation

class HighlightTextStorage: NSTextStorage {
    
    var mutableAttributedString = NSMutableAttributedString()
    
    override var string: String {
        get {
            return mutableAttributedString.string
        }
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        return mutableAttributedString.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        mutableAttributedString.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.characters.count - range.length)
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        mutableAttributedString.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
    
    override func processEditing() {
        super.processEditing()
    }
}
