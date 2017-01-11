//
//  FilterRangeView.swift
//  SimpleReader
//
//  Created by min-mac on 17/1/11.
//  Copyright © 2017年 EgeTart. All rights reserved.
//

import UIKit

class FilterRangeView: UIView {
    
    var sliderView: NHRangeSliderView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
        
        let frame = CGRect(x: 16.0, y: 16.0, width: self.frame.width - 32.0, height: 80.0)
        createSliderView(frame: frame)
        
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.6

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createSliderView(frame: CGRect) {
        
        sliderView = NHRangeSliderView(frame: frame)
        sliderView.trackHighlightTintColor = UIColor.black
        sliderView.minimumValue = 0
        sliderView.maximumValue = 6
        sliderView.lowerValue = 0
        sliderView.upperValue = 6
        sliderView.stepValue = 1
        sliderView.gapBetweenThumbs = 0
        
        sliderView.titleLabel?.text = "选择单词过滤级别"
        sliderView.titleLabel?.textAlignment = .center
        
        sliderView.sizeToFit()
        
        sliderView.thumbLabelStyle = .FOLLOW
        
        self.addSubview(sliderView)
    }
}

