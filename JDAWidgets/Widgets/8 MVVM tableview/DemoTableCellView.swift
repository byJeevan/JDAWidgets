//
//  DemoTableCellView.swift
//  JDAWidgets
//
//  Created by Jeevan on 03/10/20.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

class DemoTableCellView: UITableViewCell {

  var cellViewModel: DemoTableCellViewModel? {
    didSet {
      self.textLabel?.text = cellViewModel?.content
      self.textLabel?.numberOfLines = 10
    }
  }
}

struct DemoTableCellViewModel: RowRepresentable {
  var content: String?
}
