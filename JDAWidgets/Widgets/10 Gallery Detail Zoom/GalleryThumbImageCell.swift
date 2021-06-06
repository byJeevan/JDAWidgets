//
//  GalleryThumbImageCell.swift
//  JDAWidgets
//
//  Created by Jeevan on 05/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import UIKit

class GalleryThumbImageCell: UICollectionViewCell {

  @IBOutlet weak var thumbImageView: UIImageView!

  var isSelectedImage: Bool = false {
    didSet {
      createBorder()
    }
  }

  // MARK: - Cell Lifecycle
  override func prepareForReuse() {
    super.prepareForReuse()
    self.setupCell(nil, tag: -1) // instead of nil, you can use place holder image
  }

  func setupCell(_ image: UIImage?, tag: Int) {
    thumbImageView.tag = tag
    thumbImageView.image = image
  }
}

private extension GalleryThumbImageCell {
  func createBorder() {
    self.layer.borderColor = isSelectedImage ? UIColor.black.cgColor : UIColor.clear.cgColor
    self.layer.borderWidth = 1.5
  }
}
