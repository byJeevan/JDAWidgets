//
//  HorizontalHeaderTabsCell.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 30/04/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation
import UIKit

final class HorizontalHeaderTabsCell : UICollectionViewCell {
    
    struct Constant {
        static let identifier = "HeaderLabelCell"
        static let cellHeight:CGFloat = 50.0
    }
    
    var title : String! {
        didSet{
            self.tabButton.setTitle(self.title, for: .normal)
            self.tabButton.titleLabel?.numberOfLines = 3
            self.tabButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.tabButton.titleLabel?.minimumScaleFactor = 0.1
            self.tabButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            self.tabButton.setNeedsDisplay()
            
        }
    }
    
    var paintColor:UIColor! {
        didSet {
            self.tabButton.setTitleColor(self.paintColor, for: .normal)
            self.tabButton.tintColor = self.paintColor
            self.tabButton.setNeedsDisplay()
        }
    }
    
    var icon:UIImage? {
        didSet {
            let image = self.icon?.withRenderingMode(.alwaysTemplate)
            self.tabButton.setImage(image, for: .normal)
            
            if(icon != nil ) {
                self.tabButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 5)
            }
        }
    }
    
    var tabButton:UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.contentEdgeInsets = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)

        return button
    }()
    
    //MARK:- Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.tabButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tabButton.frame = self.contentView.bounds
    }
}

