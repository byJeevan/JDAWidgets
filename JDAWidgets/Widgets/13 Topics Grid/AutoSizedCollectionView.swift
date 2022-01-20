//
//  AutoSizedCollectionView.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 20/01/22.
//  Copyright © 2022 jda. All rights reserved.
//

import UIKit

final class AutoSizedCollectionView: UICollectionView {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize)
        && self.intrinsicContentSize.height > frame.size.height {
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override func reloadData() {
    super.reloadData()
    self.layoutSubviews()
  }
  
  override var intrinsicContentSize: CGSize {
    return self.collectionViewLayout.collectionViewContentSize
  }
}
