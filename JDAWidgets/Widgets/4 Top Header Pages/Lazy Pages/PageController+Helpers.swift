//
//  PageController+Helpers.swift
//  JDAWidgets
//
//  Created by Jeevan on 06/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit

// Declare a global var to produce a unique address as the assoc object handle
var associatedObjectHandle: UInt8 = 0

extension UIViewController {
  var index: Int? {
    get {
      objc_getAssociatedObject(self, &associatedObjectHandle) as? Int
    }
    set {
      objc_setAssociatedObject(self, &associatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }
}

extension UIView {
  /**
   Adds the subview to the view, adjusting its edges to self

   - parameter subView: The view to be added an pinned
   */
  func addAndPinSubView(subView: UIView) {
    addSubview(subView)

    var viewBindingsDict = [String: AnyObject]()
    viewBindingsDict["subView"] = subView
    addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "H:|[subView]|",
        options: [],
        metrics: nil,
        views: viewBindingsDict
      )
    )

    addConstraints(
      NSLayoutConstraint.constraints(
        withVisualFormat: "V:|[subView]|",
        options: [],
        metrics: nil,
        views: viewBindingsDict
      )
    )
  }
}
