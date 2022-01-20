//
//  TopicsGridCollectionViewCell.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 20/01/22.
//  Copyright © 2022 jda. All rights reserved.
//

import UIKit

final class TopicsGridCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var filterBackgroundView: UIView!
  @IBOutlet private weak var filterTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUpFilterBackgroundView()
  }
  
  var highlight = false {
    didSet {
      filterBackgroundView.backgroundColor = highlight ? .gray : .white
      filterTitleLabel.textColor = .black
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.highlight = false
  }
  
  func setUpViewWithOption(_ option: String?) {
    filterTitleLabel.text = option?.uppercased()
  }
  
  func setUpFilterBackgroundView() {
    filterBackgroundView.layer.borderWidth = 1.0
    filterBackgroundView.layer.cornerRadius = 5.0
    filterBackgroundView.layer.borderColor = UIColor.black.cgColor
  }
}

