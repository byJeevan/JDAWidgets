//
//  ExpandableTableView.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 09/06/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation
import UIKit

class ExpandableTableViewController: UIViewController {

  // MARK: - Public properties
  private var tableView: UITableView = UITableView.init(frame: .zero, style: .grouped) //any style.

  private var viewModel = ExpandableTableViewModel()

  // MARK: - View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initUIElements()
    self.bindElements()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.tableView.frame = self.view.bounds
  }

  // MARK: - Initialize UI Elements
  private func initUIElements() {
    self.view.addSubview(tableView)
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.tableFooterView = UIView()
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.backgroundColor = UIColor.lightGray
    self.tableView.register(UINib.init(nibName: CollapsibleTableViewHeader.Constant.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: CollapsibleTableViewHeader.Constant.identifier)
    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    self.tableView.sectionHeaderHeight =  UITableView.automaticDimension
    self.tableView.estimatedSectionHeaderHeight = 40.0
  }

  private func bindElements() {
    self.viewModel.sectionMap.bind { [unowned self] _ in
      self.tableView.reloadData()
    }

    self.viewModel.loadData()
  }
}

extension ExpandableTableViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return self.viewModel.sectionCount ?? 0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.numberOfRows(at: section) ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
    if let rowItem = self.viewModel.getRowItem(at: indexPath) {
      cell.textLabel?.text = rowItem
      cell.textLabel?.numberOfLines = 0
    }
    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CollapsibleTableViewHeader.Constant.identifier) as? CollapsibleTableViewHeader {
      header.delegate = self
      header.viewModel = self.viewModel.sectionHeader(at: section)
      return header
    }

    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40.0
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.viewModel.rowHeight(at: indexPath.section)
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return .leastNonzeroMagnitude
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    return nil
  }
}

extension ExpandableTableViewController: CollapsibleTableViewHeaderDelegate {

  func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
    // Toggle collapse
    header.viewModel?.isCollpased.value = !(header.viewModel?.isCollpased.value ?? true)

    // Reload the whole section
    tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
  }

}
