//
//  BaseMVVMTableViewModel.swift
//  JDAWidgets
//
//  Created by Jeevan on 03/10/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation

class BaseMVVMTableViewModel {
  
  var dataSource = Binding<[TableSection]>.init(value: [])
  
  init() {
    // set datasource from webpage/db/local etc.
    self.testDataSource()
  }
  
  // MARK: - Getters
  var numberOfSection: Int {
    return self.dataSource.value.count
  }
  
  func numberOfRows(at section: Int) -> Int? {
    return self.dataSource.value[section].rows?.count
  }
  
  func sectionItem(at section: Int) -> DemoHeaderFooterViewModel? {
    return self.dataSource.value[section].header as? DemoHeaderFooterViewModel
  }
  
  func rowItem(at indexPath: IndexPath) -> DemoTableCellViewModel? {
    return self.dataSource.value[indexPath.section].rows?[indexPath.row] as? DemoTableCellViewModel
  }
  
}

extension BaseMVVMTableViewModel {
  
  // Test data source
  func testDataSource() {
    
    let titles = ["iPhone Models", "Mac Models", "Watch Models"]
    
    let subtitles = [
      ["""
      iPhone 5: Single-camera system (Wide)
      \n Up to 13 hours of video playback1
      \n Water resistant to a depth of 1 metre for up to 30 minutes2", "iPhone X", "iPhone 8", "iPhone 11 Pro : Pro cameras.
      \n Pro display. \n Pro performance
      """],
      ["Macbook Air", "Macbook Pro", "iMac", "iMac Pro"],
      ["Series 1", "Series 2"]
    ]
    
    var tempDataSource = [TableSection]()
    
    for (index, title) in titles.enumerated() {
      var section = TableSection()
      section.header = DemoHeaderFooterViewModel(headerTitle: title)
      
      var tempRows = [DemoTableCellViewModel]()
      
      subtitles[index].forEach { (subtitle) in
        tempRows.append(DemoTableCellViewModel(content: subtitle))
      }
      
      section.rows = tempRows
      
      tempDataSource.append(section)
    }
    
    self.dataSource.value = tempDataSource
  }
}
