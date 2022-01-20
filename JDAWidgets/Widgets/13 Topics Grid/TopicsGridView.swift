//
//  Externsions.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 20/01/22.
//  Copyright © 2022 jda. All rights reserved.
//

import Foundation
import UIKit


final class AutoSizedCollectionView: UICollectionView {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize)
        && self.intrinsicContentSize.height > frame.size.height {
      self.invalidateIntrinsicContentSize()
    }
  }
  
  override func reloadData() {
    super.reloadData()
    self.layoutSubviews()
  }
  
  override var intrinsicContentSize: CGSize {
    return self.collectionViewLayout.collectionViewContentSize
  }
  
}


final class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    let attributes = super.layoutAttributesForElements(in: rect)
    
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    attributes?.forEach { layoutAttribute in
      
      if layoutAttribute.frame.origin.y >= maxY {
        leftMargin = sectionInset.left
      }
      
      layoutAttribute.frame.origin.x = leftMargin
      
      leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
      maxY = max(layoutAttribute.frame.maxY, maxY)
    }
    
    return attributes
  }
  
}


final class TopicsGridCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet private weak var filterBackgroundView: UIView!
  @IBOutlet private weak var filterTitleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setUpFilterBackgroundView()
  }
  
  var highlight = false {
    didSet {
      filterBackgroundView.backgroundColor = highlight ? .gray : .white
      filterTitleLabel.textColor = .black
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    self.highlight = false
  }
  
  func setUpViewWithOption(_ option: String?) {
    filterTitleLabel.text = option?.uppercased()
  }
  
  func setUpFilterBackgroundView() {
    filterBackgroundView.layer.borderWidth = 1.0
    filterBackgroundView.layer.borderColor = UIColor.red.cgColor
  }
}



final class TopicsGridView: UIView {
  
  // MARK: - Properties
  private var collectionView: AutoSizedCollectionView!
  private var topicsDataSource: [String] = ["All", "Trending", "Upcoming", "Favourites", "Newest", "Must watch"]
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
  
  // MARK: - Private methods
  private  func setUpCollectionView() {

    
    let collectionViewFlowLayout = LeftAlignedFlowLayout()
    collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    collectionViewFlowLayout.minimumInteritemSpacing = 5
    collectionViewFlowLayout.minimumLineSpacing = 5
    collectionViewFlowLayout.scrollDirection = .vertical
    
    // MARK: - fixit
//    collectionView = AutoSizedCollectionView(frame: self.bounds.insetBy(dx: 30, dy: 20), collectionViewLayout: collectionViewFlowLayout)
    collectionView = AutoSizedCollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
    
    self.addSubview(collectionView)
    // it's frame is wrong 🔥
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .right, .left]
    NSLayoutConstraint.activate(attributes.map {
      NSLayoutConstraint(item: collectionView!, attribute: $0, relatedBy: .equal, toItem: collectionView.superview, attribute: $0, multiplier: 1, constant: 0)
    })
//    collectionView.setContentHuggingPriority(UILayoutPriority.init(rawValue: 999), for: .vertical)
//    collectionView.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 99), for: .vertical)
//
//    self.setContentHuggingPriority(UILayoutPriority.init(rawValue: 999), for: .vertical)
//    self.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 99), for: .vertical)
//
 
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .yellow
    
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
}
