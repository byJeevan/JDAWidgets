//
//  ExtendedLabelVC.swift
//  JDAWidgets
//
//  Created by Jeevan on 09/10/20.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

class ExtendedLabelVC: UIViewController {
  
  // MARK: - Clickable Label
  @IBOutlet private weak var privacyPolicyLabel: InteractiveLinkLabel! {
    
    didSet {
      let plainAttributedString = NSMutableAttributedString(string: "This is a link: ", attributes: nil)
      let string = "A link to Google"
      let attributedLinkString = NSMutableAttributedString(string: string, attributes: [
        NSAttributedString.Key.link: URL(string: "http://www.google.com")!,
        NSAttributedString.Key.underlineColor: UIColor.clear
      ])
      
      let fullAttributedString = NSMutableAttributedString()
      fullAttributedString.append(plainAttributedString)
      fullAttributedString.append(attributedLinkString)
      privacyPolicyLabel.attributedText = fullAttributedString
    }
  }
  
}
