//
//  FloatingTextFieldTestVC.swift
//  JDAWidgets
//
//  Created by Jeevan on 19/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

/*
 * ViewController to test FloatingTextField widgets
 */
class FloatingTextFieldTestVC: UIViewController {

  lazy var floatingTextField = FloatingTextField(frame: .zero)

  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.setupTextField()

  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    floatingTextField.frame = CGRect.init(x: 10, y: 100, width: self.view.bounds.width - 20, height: 60) // 60.0 is idle height
  }

  private func setupTextField() {
    floatingTextField.placeholder = "Enter your email"
    self.view.addSubview(floatingTextField)
    floatingTextField.delegate = self
  }
}

extension FloatingTextFieldTestVC: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    floatingTextField.error = ""
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    /*Test error message */
    if textField.text?.count ?? 0 > 10 {
      floatingTextField.error = "Error: Exceeded character limit (10)"
    }

  }
}
