//
//  ExpandableTableViewModel.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 09/06/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation
import UIKit

class ExpandableTableViewModel {

  let dataSectionSample = [
    "iPhone Model",
    "Macbook Model",
    "iMac Model",
    "Watch Model"
  ]

  let dataRowSample = [
    [ "iPhone SE : Single-camera system (Wide)\n Up to 13 hours of video playback1 \n Water resistant to a depth of 1 metre for up to 30 minutes2", "iPhone X", "iPhone 8",
      "iPhone 11 Pro : Pro cameras. \n Pro display. \n Pro performance"],
    [ "Pro 2019", "Air 2019"],
    [ "Full HD", "Normal HD", "Ultra HD 4k"],
    ["iWatch with Strap"]
  ]

  var sectionMap = Binding<[CollapsibleHeaderViewModel]>.init(value: [])

  func loadData() {
    var sectionVMs = [CollapsibleHeaderViewModel]()
    for (index, headerTitle) in dataSectionSample.enumerated() {
      sectionVMs.append(CollapsibleHeaderViewModel.init(headerTitle: headerTitle, isCollpased: true, sectionId: index))
    }
    self.sectionMap.value = sectionVMs

  }

  var sectionCount: Int? {
    return sectionMap.value.count
  }

  func numberOfRows(at section: Int) -> Int? {
    return dataRowSample[section].count
  }

  func getRowItem(at index: IndexPath) -> String? {
    return dataRowSample[index.section][index.row]
  }

  func sectionHeader(at section: Int) -> CollapsibleHeaderViewModel {
    return sectionMap.value[section]
  }

  func rowHeight(at section: Int) -> CGFloat {
    return self.isSectionCollapsed(section) ? 0.0 : UITableView.automaticDimension
  }

  func isSectionCollapsed(_ section: Int) -> Bool {
    let header = sectionHeader(at: section)
    return header.isCollpased.value
  }

}
