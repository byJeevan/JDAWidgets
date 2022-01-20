//
//  LeftAlignedFlowLayout.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 20/01/22.
//  Copyright © 2022 jda. All rights reserved.
//

import UIKit

final class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    attributes?.forEach { layoutAttribute in
      
      if layoutAttribute.frame.origin.y >= maxY {
        leftMargin = sectionInset.left
      }
      
      layoutAttribute.frame.origin.x = leftMargin
      
      leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
      maxY = max(layoutAttribute.frame.maxY, maxY)
    }
    
    return attributes
  }
  
}
