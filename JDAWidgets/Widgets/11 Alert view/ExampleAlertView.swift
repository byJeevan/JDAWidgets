//
//  ExampleAlertView.swift
//  JDAWidgets
//
//  Created by Jeevan on 06/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import UIKit

class ExampleAlertView: UIView {

  static var instance: ExampleAlertView {
    guard let view = Bundle.main.loadNibNamed("ExampleAlertView", owner: nil, options: nil)?.first as? ExampleAlertView else {
      return ExampleAlertView()
    }
    return view
  }

  @IBAction private func closeAction(_ sender: Any) {
    self.hideAlert()
  }
}

// MARK: - Alert Presentable Protocols
extension ExampleAlertView: AlertPresentable {

  var alertShadowStyle: AlertShadowStyle? {
    .dark
  }

  var alertPresentingStyle: AlertPresentingStyle? {
    .topDown
  }

  var parentViewController: UIViewController? {
    UIApplication.shared.topViewController()
  }
}
