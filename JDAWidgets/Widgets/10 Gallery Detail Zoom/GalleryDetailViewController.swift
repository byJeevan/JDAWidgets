//
//  GalleryDetailViewController.swift
//  JDAWidgets
//
//  Created by Jeevan on 05/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import UIKit

//
// Know Issue: Zoom and Swipe will freeze frame
//
class GalleryDetailViewController: BaseViewController {
  @IBOutlet private weak var galleryCollectionView: UICollectionView!
  @IBOutlet private weak var thumbCollectionView: UICollectionView!

  private var imageDataSource:[UIImage]?

  private var focusedCellIndex: Int? {
    didSet {
      handleSelection()
    }
  }

  // MARK: - Initializations

  init(images: [UIImage], defaultIndex: Int? = 0) {
    super.init(nibName: nil, bundle: nil)
    self.imageDataSource = images
    self.focusedCellIndex = defaultIndex
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK:- ViewController Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCells()
    initCollectionViews()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    thumbCollectionView.collectionViewLayout.invalidateLayout()
    galleryCollectionView.collectionViewLayout.invalidateLayout()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.main.async { [weak self] in
      self?.scrollToCellIndex(self?.focusedCellIndex ?? 0, animated: false)
    }
  }

  // Supporting iPad oriantation change
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { [weak self] _ in
      self?.thumbCollectionView.collectionViewLayout.invalidateLayout()
      self?.galleryCollectionView.collectionViewLayout.invalidateLayout()
      self?.thumbCollectionView.reloadData()
      self?.galleryCollectionView.reloadData()
    }, completion: { [weak self] _ in
      self?.scrollToCellIndex(self?.focusedCellIndex ?? 0, animated: true)
    })
  }

}

// MARK: - Private methods

private extension GalleryDetailViewController {

  private func scrollToCellIndex(_ index: Int, animated: Bool) {
    self.galleryCollectionView.isPagingEnabled = false // When paging enabled, always returns to firt element. iOS 14 issue fix. [https://developer.apple.com/forums/thread/663156]
    self.galleryCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
    self.galleryCollectionView.isPagingEnabled = true
    self.thumbCollectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
  }

  private var sizeOfThumbCell: CGSize {
    CGSize(width: Constants.GalleryDetail.gallerySizeWH, height: Constants.GalleryDetail.gallerySizeWH)
  }

  private var sizeOfGalleryCell: CGSize {
    CGSize(width: self.galleryCollectionView.bounds.width, height: self.galleryCollectionView.bounds.height)
  }

  private func initCollectionViews() {
    galleryCollectionView.isPagingEnabled = true // if paging enabled, scrooToitem not workingl
    thumbCollectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    galleryCollectionView.showsHorizontalScrollIndicator = false
    galleryCollectionView.showsVerticalScrollIndicator = false
    galleryCollectionView.tag = Constants.GalleryDetail.galleryCollectionViewTag
    thumbCollectionView.tag = Constants.GalleryDetail.thumbCollectionViewTag
    thumbCollectionView.collectionViewLayout = prepareHorizontalCollectionView(thumbCollectionView, layoutWith: sizeOfThumbCell)
    galleryCollectionView.collectionViewLayout = prepareHorizontalCollectionView(galleryCollectionView, layoutWith: sizeOfThumbCell)
  }

  private func registerCells() {
    thumbCollectionView.register(UINib.init(nibName: "GalleryThumbImageCell", bundle: nil), forCellWithReuseIdentifier: "GalleryThumbImageCell")
    galleryCollectionView.register(UINib.init(nibName: "GalleryImageCell", bundle: nil), forCellWithReuseIdentifier: "GalleryImageCell")
  }

  private func prepareHorizontalCollectionView(_ collectionView: UICollectionView, layoutWith itemSize: CGSize) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = itemSize
    layout.sectionInset = .zero
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.minimumInteritemSpacing = 0
      layout.minimumLineSpacing = 0
      layout.invalidateLayout()
    }
    return layout
  }

  private func isGalleryCollectionView(_ collectionView: UICollectionView) -> Bool {
    collectionView.tag == Constants.GalleryDetail.galleryCollectionViewTag
  }

  // MARK: - Events and Actions
  private func handleSelection() {
    UIView.animate(withDuration: 0.75, delay: 0.25, options: .curveEaseInOut, animations: { [weak self] in
      self?.scrollToCellIndex(self?.focusedCellIndex ?? 0, animated: true)
    }, completion: nil)
  }

  @IBAction private func closeButtonAction() {
    self.dismiss(animated: true, completion: nil)
  }

}


// MARK: - UICollectionView DataSource

extension GalleryDetailViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageDataSource?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    switch collectionView.tag {
    case Constants.GalleryDetail.galleryCollectionViewTag:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryImageCell", for: indexPath) as! GalleryImageCell
      cell.setupCell(imageDataSource?[indexPath.row], tag: indexPath.row + 100)
      cell.resetZoomScale()

      return cell

    case Constants.GalleryDetail.thumbCollectionViewTag:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryThumbImageCell", for: indexPath) as! GalleryThumbImageCell
      cell.setupCell(imageDataSource?[indexPath.row], tag: indexPath.row + 200)
      cell.isSelectedImage = indexPath.row == focusedCellIndex
      return cell

    default:
      return UICollectionViewCell()
    }
  }
}

// MARK: - UICollectionView Delegate

extension GalleryDetailViewController: UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let focusedCellIndex = focusedCellIndex {
      let previousIndex = IndexPath(row: focusedCellIndex, section: 0)
      let previousCell = collectionView.cellForItem(at: previousIndex) as? GalleryThumbImageCell
      previousCell?.isSelectedImage = false

      // Reset the zoom scale.
      let mainCell = galleryCollectionView?.cellForItem(at: previousIndex) as? GalleryImageCell
      mainCell?.resetZoomScale()
    }
    let currentCell = collectionView.cellForItem(at: indexPath) as? GalleryThumbImageCell
    currentCell?.isSelectedImage = true
    focusedCellIndex = indexPath.row
  }
}

// MARK: - UICollectionView Delegate of FlowLayout

extension GalleryDetailViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return isGalleryCollectionView(collectionView) ? sizeOfGalleryCell : sizeOfThumbCell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

// MARK: - UIScrollView Delegate

extension GalleryDetailViewController: UIScrollViewDelegate {

  // Scrollview.tag will equal to your collection view's tag
  // Use page to update page control or whatever
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let pageWidth = scrollView.frame.size.width
    let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
    if scrollView.tag == Constants.GalleryDetail.galleryCollectionViewTag {
      let indexPath = IndexPath(row: page, section: 0)
      collectionView(thumbCollectionView, didSelectItemAt: indexPath)
    }
  }
}

extension Constants {
  struct GalleryDetail {
    static let galleryCollectionViewTag = 10
    static let thumbCollectionViewTag = 11
    static let gallerySizeWH:CGFloat = 45
  }
}
