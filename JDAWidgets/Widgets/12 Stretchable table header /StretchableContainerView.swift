//
//  StretchableContainerView.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 14/10/21.
//  Copyright © 2021 jda. All rights reserved.
//

import UIKit

final class StretchableContainerView: UIView {
  static let maxHeight: CGFloat = 300.0
  static let minHeight: CGFloat = 125.0
  
  func setup() {
    self.clipsToBounds = true
    addImageView()
  }
  
  private func addImageView() {
    var imageView: UIImageView = UIImageView()
    imageView.image = UIImage(named: "sample_3")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
 
}
