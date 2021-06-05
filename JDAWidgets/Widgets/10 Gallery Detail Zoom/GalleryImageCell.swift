//
//  GalleryImageCell.swift
//  JDAWidgets
//
//  Created by Jeevan on 05/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import UIKit

class GalleryImageCell: UICollectionViewCell {
  
  @IBOutlet weak var imageScrollView: ImageScrollView!
  private var galleryImageView: UIImageView?

  // MARK: - Cell Lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    addImageView()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.setupCell(nil, tag: -1) // instead of nil, you can use place holder image
  }

  public func setupCell(_ image:UIImage?, tag:Int) {
    galleryImageView?.tag = tag
    galleryImageView?.image = image
  }
}

private extension GalleryImageCell {
  func addImageView() {
    self.galleryImageView = UIImageView()
    self.galleryImageView?.contentMode = .scaleAspectFit
    self.imageScrollView.delegate = self
    self.imageScrollView.imageView = self.galleryImageView
    self.imageScrollView.maximumZoomScale = 3.0
  }
}

// MARK: - UIScrollViewDelegate

extension GalleryImageCell: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return self.galleryImageView
  }

  func resetZoomScale() {
    self.imageScrollView.setZoomScale(self.imageScrollView.minimumZoomScale, animated: false)
  }
}

