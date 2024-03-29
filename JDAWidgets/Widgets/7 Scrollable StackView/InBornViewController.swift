//
//  InBornViewController.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 30/08/20.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

// A elegant StackView - Top aligned + scrollable when frame overflows.
class InBornViewController: UIViewController {

  @IBOutlet weak var mainStack: UIStackView!

  @IBAction func addAction(_ sender: Any) {
    // Add any view at run time
    let sampleText = UILabel()
    sampleText.text = "Inserted on \(Date()) "
    sampleText.backgroundColor = UIColor.random.withAlphaComponent(0.5)
    let heightConstraint = NSLayoutConstraint(item: sampleText, attribute: NSLayoutConstraint.Attribute.height,
                                              relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
    sampleText.addConstraints([heightConstraint])
    mainStack.addArrangedSubview(sampleText)
  }

  @IBAction func removeAction(_ sender: Any) {
    // Remove view at run time
    if let view = mainStack.arrangedSubviews.last, mainStack.arrangedSubviews.count > 3 {
      mainStack.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
  }
}
