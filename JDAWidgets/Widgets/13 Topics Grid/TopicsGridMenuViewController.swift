//
//  TopicsGridMenuViewController.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 20/01/22.
//  Copyright © 2022 jda. All rights reserved.
//

import Foundation
import UIKit

final class TopicsGridMenuViewController: BaseViewController {
  
  // MARK: - Public properties
  @IBOutlet weak var topicGridContainerView: TopicsGridView!
  @IBOutlet weak var topicTableView: UITableView!

//  private var tableView: UITableView = UITableView() //any style.
 
  // MARK: - View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initUIElements()
  }
  
  // MARK: - Initialize UI Elements
  private func initUIElements() {
    // Adding table view
//    self.tableView.frame = self.view.bounds
//    self.view.addSubview(tableView)
    topicTableView.delegate = self
    topicTableView.dataSource = self
    topicTableView.tableFooterView = UIView()
//    topicTableView.backgroundColor = UIColor.white
    topicTableView.register(UINib.init(nibName: "TopicGridSampleTableViewCell", bundle: .main), forCellReuseIdentifier: "TopicGridSampleTableViewCell")
    topicTableView.estimatedRowHeight = 50
    topicTableView.rowHeight = UITableView.automaticDimension
    
  }
 
  
}

extension TopicsGridMenuViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TopicGridSampleTableViewCell")!
//    cell.setNeedsLayout()
//    cell.layoutIfNeeded() //important // it's wrong 🔥
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
}
