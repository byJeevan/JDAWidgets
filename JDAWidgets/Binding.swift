//
//  Binding.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 09/06/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation


class Binding<T> {
  var value: T {
    didSet {
      listener?(value)
    }
  }
  private var listener: ((T) -> Void)?
  init(value: T) {
    self.value = value
  }
  func bind(_ closure: @escaping (T) -> Void) {
    closure(value)
    listener = closure
  }
}
