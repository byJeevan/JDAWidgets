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
  
  // MARK: - View Controller Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.initUIElements()
  }
  
  // MARK: - Initialize UI Elements
  private func initUIElements() {
    // Adding table view
    topicTableView.delegate = self
    topicTableView.dataSource = self
    topicTableView.tableFooterView = UIView()
    topicTableView.register(UINib.init(nibName: "TopicGridSampleTableViewCell", bundle: .main), forCellReuseIdentifier: "TopicGridSampleTableViewCell")
    topicTableView.estimatedRowHeight = 50
    topicTableView.rowHeight = UITableView.automaticDimension
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    topicTableView.reloadData() // important.
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "TopicGridSampleTableViewCell") as! TopicGridSampleTableViewCell
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  
  
}
