//
//  DemoHeaderFooterView.swift
//  JDAWidgets
//
//  Created by Jeevan on 03/10/20.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

class DemoHeaderFooterView: UITableViewHeaderFooterView {

  var headerViewModel: DemoHeaderFooterViewModel? {
    didSet {
      titleLabel?.text = headerViewModel?.headerTitle
    }
  }

  private var titleLabel: UILabel?

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  func commonInit() {
    self.titleLabel = UILabel()
    self.titleLabel?.textColor = .red
    self.titleLabel?.sizeToFit()
    self.titleLabel?.frame = CGRect.init(x: 20, y: 0, width: 200, height: 30)
    self.addSubview(self.titleLabel!)
  }

}

struct DemoHeaderFooterViewModel: HeaderFooterRepresentable {
    var headerTitle: String?
}
