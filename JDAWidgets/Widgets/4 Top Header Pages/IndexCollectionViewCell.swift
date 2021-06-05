//
//  IndexCollectionViewCell.swift
//  JDAWidgets
//
//  Created by Jeevan on 05/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import UIKit

final class IndexCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var indexLabel: UILabel!

  override var isSelected: Bool {
    didSet {
      if isSelected {
        indexLabel.textColor = UIColor.black
      } else {
        indexLabel.textColor = UIColor.gray
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
//    self.contentView.layer.borderWidth = 1.5
//    self.contentView.layer.borderColor = UIColor.red.cgColor
  }
}
