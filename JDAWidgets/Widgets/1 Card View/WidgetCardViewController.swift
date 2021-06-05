//
//  WidgetCardViewController.swift
//  JDAWidgets
//
//  Created by Jeevan on 13/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation
import UIKit

// Simple view controller where its view layed-out as a card.
class WidgetCardViewController: UIViewController {
    
    var containerView = UIView()
    let likeButton = UIButton()
    
    // MARK :- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        containerView.backgroundColor = .white
        self.view.addSubview(containerView)
        edgesForExtendedLayout = [] // To avoid navigation bar cover the Card.
        self.title = "Card Layout"
        
        self.view.addSubview(self.likeButton)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.cornerRadius = 10.0
        containerView.frame = self.view.bounds.insetBy(dx: 10.0, dy: 10.0)
        
        self.likeButton.frame = CGRect.init(x: 20, y: 20, width: 70, height: 70)

        let notLikedImage = UIImage.init(named: "heart")?.withRenderingMode(.alwaysOriginal)
        let likedImage = UIImage.init(named: "heart")?.withRenderingMode(.alwaysTemplate)
        self.likeButton.tintColor = .red
        self.likeButton.setImage(notLikedImage, for: .normal)
        self.likeButton.setImage(likedImage, for: .selected)
        self.likeButton.addTarget(self, action: #selector(updatedButton), for: .touchUpInside)
        self.likeButton.adjustsImageWhenHighlighted = false

    }
    
    @objc func updatedButton() {
        self.likeButton.isSelected = !self.likeButton.isSelected
    }
}

// MARK: - View Extension to create corner radius with shadow
extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
