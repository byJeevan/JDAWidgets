//
//  AlertUsageViewController.swift
//  JDAWidgets
//
//  Created by Jeevan on 06/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import UIKit

/// View Controller to test Alert View usage.
class AlertUsageViewController: BaseViewController {

  lazy var exampleAlertView = ExampleAlertView.instance

  override func viewDidLoad() {
    super.viewDidLoad()
    self.addTestButton()
  }

  func addTestButton() {
    let testButton = UIButton(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 25, width: 100, height: 50))
    testButton.addTarget(self, action: #selector(testAction), for: .touchUpInside)
    testButton.setTitle("Show Alert", for: .normal)
    self.view.addSubview(testButton)
  }

  @objc func testAction() {
    exampleAlertView.showAlert()
  }
}
