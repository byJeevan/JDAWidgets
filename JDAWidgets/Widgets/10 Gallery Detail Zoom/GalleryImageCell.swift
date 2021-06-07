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
  
  @IBOutlet weak var imageScrollView: UIScrollView!
  @IBOutlet weak var galleryImageView: UIImageView!

  // MARK: - Cell Lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    addImageView()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    self.setupCell(nil, tag: -1) // instead of nil, you can use place holder image
  }

  public func setupCell(_ image: UIImage?, tag: Int) {
    galleryImageView.tag = tag
    galleryImageView.image = image
  }
}

private extension GalleryImageCell {
  func addImageView() {
    imageScrollView.delegate = self
    imageScrollView.maximumZoomScale = 3.0
    imageScrollView.showsVerticalScrollIndicator = false
    imageScrollView.showsHorizontalScrollIndicator = false

    let tapGuesture = UITapGestureRecognizer.init(target: self, action: #selector(onImageDoubleTap(_ :)))
    tapGuesture.numberOfTapsRequired = 2
    galleryImageView.addGestureRecognizer(tapGuesture)
  }
}

// MARK: - UIScrollViewDelegate

extension GalleryImageCell: UIScrollViewDelegate {

  @objc private func onImageDoubleTap(_ gesture: UITapGestureRecognizer) {
    guard gesture.state == .ended else { return }
    guard let imageView = self.galleryImageView else { return }
    let tapLocation = gesture.location(in: imageView)

    if imageScrollView.zoomScale < imageScrollView.maximumZoomScale {
      // Zoom in when not yet fully zoomed in
      imageScrollView.zoom(to: CGRect(x: tapLocation.x, y: tapLocation.y, width: 1, height: 1), animated: true)
    } else {
      // Zoom out
      imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
    }
  }

  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return galleryImageView
  }

  func resetZoomScale() {
    imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
  }

  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    if scrollView.zoomScale > scrollView.minimumZoomScale {
      if let image = galleryImageView.image {
        let ratioW = galleryImageView.frame.width / image.size.width
        let ratioH = galleryImageView.frame.height / image.size.height
        let ratio = ratioW < ratioH ? ratioW : ratioH
        let newWidth = image.size.width * ratio
        let newHeight = image.size.height * ratio
        let conditionLeft = newWidth*scrollView.zoomScale > galleryImageView.frame.width
        let left = 0.5 * (conditionLeft ? newWidth - galleryImageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
        let conditioTop = newHeight*scrollView.zoomScale > galleryImageView.frame.height
        let top = 0.5 * (conditioTop ? newHeight - galleryImageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
        scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
      }
    } else {
      scrollView.contentInset = .zero
    }
  }
}
