//
//  Externsions.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 20/01/22.
//  Copyright © 2022 jda. All rights reserved.
//

import Foundation
import UIKit

final class TopicsGridView: UIView {
  
  // MARK: - Properties
  var collectionView: AutoSizedCollectionView!
  private var topicsDataSource: [String] = ["All", "Trending", "Upcoming", "Favourites",
                                            "Newest", "Must watch", "Archived"]
 
  // MARK: - View lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpCollectionView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setUpCollectionView()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUpCollectionView()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  func reloadTopics() {
    collectionView.reloadData()
  }
  
  // MARK: - Private methods
  private  func setUpCollectionView() {

    
    let collectionViewFlowLayout = LeftAlignedFlowLayout()
    collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    collectionViewFlowLayout.minimumInteritemSpacing = 5
    collectionViewFlowLayout.minimumLineSpacing = 5
    collectionViewFlowLayout.scrollDirection = .vertical
    
    collectionView = AutoSizedCollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    self.addSubview(collectionView)
    
    // it's frame is wrong 🔥
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
    NSLayoutConstraint.activate(attributes.map {
      NSLayoutConstraint(item: collectionView!, attribute: $0, relatedBy: .equal, toItem: collectionView.superview, attribute: $0, multiplier: 1, constant: 0)
    })

    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .yellow
    collectionView.isScrollEnabled = false
    
    collectionView.register(UINib.init(nibName: "TopicsGridCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "TopicsGridCollectionViewCell")

  }
}

extension TopicsGridView: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return topicsDataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: TopicsGridCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: "TopicsGridCollectionViewCell", for: indexPath) as! TopicsGridCollectionViewCell
    cell.setUpViewWithOption(topicsDataSource[indexPath.row])
    cell.setUpFilterBackgroundView()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Selected \(topicsDataSource[indexPath.row])")
    if let cell = collectionView.cellForItem(at: indexPath) as? TopicsGridCollectionViewCell {
      cell.highlight.toggle()
    }
  }
}
