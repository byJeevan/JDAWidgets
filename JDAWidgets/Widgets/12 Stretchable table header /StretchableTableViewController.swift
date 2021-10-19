//
//  StretchableTableViewController.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 14/10/21.
//  Copyright © 2021 jda. All rights reserved.
//

import UIKit

final class StretchableTableViewController: BaseViewController {
  
  // MARK: - Public properties
  private var tableView: UITableView = UITableView() //any style.
  private var stretchableView: StretchableContainerView = StretchableContainerView()
  
  // MARK: - View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initUIElements()
  }
  
  // MARK: - Initialize UI Elements
  private func initUIElements() {
    // Adding table view
    self.tableView.frame = self.view.bounds
    self.view.addSubview(tableView)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.tableFooterView = UIView()
    self.tableView.backgroundColor = UIColor.white // Do add cell background color for better ux
    self.tableView.register(UINib.init(nibName: CollapsibleTableViewHeader.Constant.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.Constant.identifier)
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    tableView.estimatedRowHeight = 50
    tableView.rowHeight = UITableView.automaticDimension
    
    // Step 1/2
    initializeHeaderView()

    if self.tableView.numberOfRows(inSection: 0) > 0 {
      self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false) // Fixes issue - First time table renders without content inset
    }
    
  }
  
  func initializeHeaderView() {
    tableView.contentInset = UIEdgeInsets(top: StretchableContainerView.maxHeight, left: 0, bottom: 0, right: 0)  // Add 'top' inset to tableview
    stretchableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: StretchableContainerView.maxHeight)
    stretchableView.setup()
    self.view.addSubview(stretchableView)
    
    // For Testing
    stretchableView.layer.borderWidth = 2.0
    stretchableView.layer.borderColor = UIColor.systemYellow.cgColor
  }
  
  // Step 2/2
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let y = StretchableContainerView.maxHeight - (scrollView.contentOffset.y + StretchableContainerView.maxHeight)
    let height = min(max(y, StretchableContainerView.minHeight), 400)
    print("y : \(y) - h : \(height)")
    stretchableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
  }
  
}

extension StretchableTableViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 11
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
    cell.textLabel?.text = "\(indexPath.row). Collection of swift components packed 📦 for easy & faster feature integrations. Interstingly, here won't be external dependency library involved. All these widgets stiched from native components with minimal amount of changes.\n "
    cell.textLabel?.numberOfLines = 0
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}
