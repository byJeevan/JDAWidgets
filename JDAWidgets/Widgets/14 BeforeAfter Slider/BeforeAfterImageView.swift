//  BeforeAfterImageView.swift
//  Magnolia-iOS-App
//
//  Created by Jeevan Rao on 17/03/23.
//

import UIKit

protocol ThumbWrapperViewDelegate: AnyObject {
  func shouldIncreaseSlider()
  func shouldReduceSlider()
}

final class ThumbWrapperView: UIView {
  
  weak var delegate: ThumbWrapperViewDelegate?
  
  override func accessibilityIncrement() {
    delegate?.shouldIncreaseSlider()
  }
  
  override func accessibilityDecrement() {
    delegate?.shouldReduceSlider()
  }
}

final class BeforeAfterImageView: UIView {
  
  private var wrapperLeadingConstraint: NSLayoutConstraint!
  private var originRect: CGRect = .zero // saves the image wrapper frame while transitioning.
  
  // MARK: Constants
  private let thumbWidth = 26.0
  private let thumbLineThickness = 2.9
  private var thumbMid: CGFloat {
    return self.thumbWidth / 2.0
  }
  private let thumbTransitLimit = 0.0 // increase if we require gaps on thumb edges.
  private let stepValueForAccessibility = 10.0
  
  lazy var beforeImageView: UIImageView = {
    let imageView2 = UIImageView()
    imageView2.translatesAutoresizingMaskIntoConstraints = false
    imageView2.contentMode = .scaleAspectFill
    imageView2.isAccessibilityElement = true
    imageView2.clipsToBounds = true
    return imageView2
  }()
  
  lazy var afterImageView: UIImageView = {
    let imageView1 = UIImageView()
    imageView1.translatesAutoresizingMaskIntoConstraints = false
    imageView1.contentMode = .scaleAspectFill
    imageView1.clipsToBounds = true
    imageView1.isAccessibilityElement = true
    return imageView1
  }()
  
  private lazy var afterImageViewWrapper: UIView = {
    let image1Wrapper = UIView()
    image1Wrapper.translatesAutoresizingMaskIntoConstraints = false
    image1Wrapper.clipsToBounds = true
    image1Wrapper.isAccessibilityElement = false
    image1Wrapper.shouldGroupAccessibilityChildren = false
    return image1Wrapper
  }()
  
  private lazy var thumbIcon: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "thumbIcon")
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = true
    return view
  }()
  
  lazy var thumbWrapper: ThumbWrapperView = {
    let thumbWrapper = ThumbWrapperView()
    thumbWrapper.translatesAutoresizingMaskIntoConstraints = false
    thumbWrapper.clipsToBounds = true
    thumbWrapper.isAccessibilityElement = true
    return thumbWrapper
  }()
  
  private lazy var thumbWrapperTopLine: UIView = {
    let thumbWrapper = UIView()
    thumbWrapper.translatesAutoresizingMaskIntoConstraints = false
    thumbWrapper.backgroundColor = .white
    return thumbWrapper
  }()
  
  private lazy var thumbWrapperBottomLine: UIView = {
    let thumbWrapper = UIView()
    thumbWrapper.translatesAutoresizingMaskIntoConstraints = false
    thumbWrapper.backgroundColor = .white
    return thumbWrapper
  }()
  
  private lazy var setupLeadingAndOriginRect: Void = {
    self.wrapperLeadingConstraint.constant = self.frame.width / 2
    self.layoutIfNeeded()
    self.originRect = self.afterImageViewWrapper.frame
  }()
  
  // MARK: - Initialisers
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    _ = setupLeadingAndOriginRect
    limitThumbPositionChanges()
  }
  
}

private extension BeforeAfterImageView {
  
  func initialize() {
    
    // remove elements
    afterImageViewWrapper.removeFromSuperview()
    thumbWrapper.removeFromSuperview()
    beforeImageView.removeFromSuperview()
    
    // To half clip the thumb control when extreem edge.
    clipsToBounds = true
    thumbWrapper.delegate = self
    
    // add after and before images and one wrapper for the after image view.
    afterImageViewWrapper.addSubview(afterImageView)
    addSubview(beforeImageView)
    addSubview(afterImageViewWrapper)
    addSubview(thumbWrapper)
    
    // Thumb with line
    thumbWrapper.addSubview(thumbIcon)
    thumbWrapper.addSubview(thumbWrapperTopLine)
    thumbWrapper.addSubview(thumbWrapperBottomLine)
    
    addConstraints()
    addSlideGuestures()
    
    // shadows to lines
    addShadowsToLines(on: thumbWrapperTopLine)
    addShadowsToLines(on: thumbWrapperBottomLine)
    
    // accessibility
    setupAccessibility()
  }
  
  func setupAccessibility() {
    afterImageView.isAccessibilityElement = true
    beforeImageView.isAccessibilityElement = true
    afterImageView.accessibilityLabel = "after image"
    beforeImageView.accessibilityLabel = "before image"

    self.shouldGroupAccessibilityChildren = false
    if #available(iOS 13.0, *) {
      thumbWrapper.accessibilityRespondsToUserInteraction = true
    } else {
      // Fallback on earlier versions
    }
    thumbWrapper.accessibilityLabel = "Percent revealed of first image"
    thumbWrapper.accessibilityTraits = [.adjustable, .keyboardKey]
    thumbWrapper.accessibilityValue = "\(UInt(percentageRevealed)) percent"
    thumbWrapper.accessibilityHint = "Swipe up down to change slider"
    self.accessibilityElements = [thumbWrapper, beforeImageView, afterImageView]

  }
  
  func addConstraints() {
    NSLayoutConstraint.activate([
      beforeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      beforeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
      beforeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      beforeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    ])
    
    wrapperLeadingConstraint = afterImageViewWrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    
    NSLayoutConstraint.activate([
      afterImageViewWrapper.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      afterImageViewWrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
      afterImageViewWrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
      wrapperLeadingConstraint
    ])
    
    NSLayoutConstraint.activate([
      afterImageView.topAnchor.constraint(equalTo: afterImageViewWrapper.topAnchor, constant: 0),
      afterImageView.bottomAnchor.constraint(equalTo: afterImageViewWrapper.bottomAnchor, constant: 0),
      afterImageView.trailingAnchor.constraint(equalTo: afterImageViewWrapper.trailingAnchor, constant: 0),
      afterImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1)
    ])
    
    NSLayoutConstraint.activate([
      thumbWrapper.topAnchor.constraint(equalTo: afterImageViewWrapper.topAnchor, constant: 0),
      thumbWrapper.bottomAnchor.constraint(equalTo: afterImageViewWrapper.bottomAnchor, constant: 0),
      thumbWrapper.leadingAnchor.constraint(equalTo: afterImageViewWrapper.leadingAnchor, constant: -thumbMid),
      thumbWrapper.widthAnchor.constraint(equalToConstant: thumbWidth)
    ])
    
    NSLayoutConstraint.activate([
      thumbIcon.centerXAnchor.constraint(equalTo: thumbWrapper.centerXAnchor, constant: 0),
      thumbIcon.centerYAnchor.constraint(equalTo: thumbWrapper.centerYAnchor, constant: 0),
      thumbIcon.widthAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 1),
      thumbIcon.heightAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 1)
    ])
    
    NSLayoutConstraint.activate([
      thumbWrapperTopLine.topAnchor.constraint(equalTo: thumbWrapper.topAnchor, constant: 0),
      thumbWrapperTopLine.bottomAnchor.constraint(equalTo: thumbIcon.topAnchor, constant: 0),
      thumbWrapperTopLine.widthAnchor.constraint(equalToConstant: thumbLineThickness),
      thumbWrapperTopLine.centerXAnchor.constraint(equalTo: thumbWrapper.centerXAnchor, constant: 0)
    ])
    
    NSLayoutConstraint.activate([
      thumbWrapperBottomLine.topAnchor.constraint(equalTo: thumbIcon.bottomAnchor, constant: 0),
      thumbWrapperBottomLine.bottomAnchor.constraint(equalTo: thumbWrapper.bottomAnchor, constant: 0),
      thumbWrapperBottomLine.widthAnchor.constraint(equalToConstant: thumbLineThickness),
      thumbWrapperBottomLine.centerXAnchor.constraint(equalTo: thumbWrapper.centerXAnchor, constant: 0)
    ])
    
    wrapperLeadingConstraint.constant = frame.width / 2.0
  }
  
  var percentageRevealed: CGFloat {
    (wrapperLeadingConstraint.constant / frame.width) * 100.0
  }
  
  func updateSliderValue(_ value: CGFloat) {
    var newLeading = max(value, thumbTransitLimit)
    newLeading = min(frame.width - thumbTransitLimit, newLeading)
    wrapperLeadingConstraint.constant = newLeading
    layoutIfNeeded()
  }
  
  func limitThumbPositionChanges() {
    if self.wrapperLeadingConstraint.constant > self.frame.width || self.wrapperLeadingConstraint.constant < 0 {
      self.updateSliderValue(self.frame.width / 2)
      self.originRect = self.afterImageViewWrapper.frame
    }
  }
  
  func updateAccessibility() {
    self.thumbWrapper.accessibilityValue = "\(UInt(self.percentageRevealed)) percent"
  }
  
  func addSlideGuestures() {
    // Pan guesture for thumb
    let thumbWrapperPan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
    thumbWrapper.isUserInteractionEnabled = true
    thumbWrapper.addGestureRecognizer(thumbWrapperPan)
    
    // Tap guesture for container
    let containerTap = UITapGestureRecognizer(target: self, action: #selector(tapGuesture(sender:)))
    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(containerTap)
  }
  
  func addShadowsToLines(on view: UIView) {
    view.layer.shadowRadius = 4.0
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.25
    view.layer.masksToBounds = false
  }
  
  @objc func panGesture(sender: UIPanGestureRecognizer) {
    let translation = sender.translation(in: self)
    switch sender.state {
    case .began, .changed:
      let deltaX = originRect.origin.x + translation.x
      updateSliderValue(deltaX)
    case .ended, .cancelled:
      originRect = afterImageViewWrapper.frame
      updateAccessibility()
    default:
      break
    }
  }
  
  @objc func tapGuesture(sender: UITapGestureRecognizer) {
    let touchPoint = sender.location(in: self)
    updateSliderValue(touchPoint.x)
    originRect = afterImageViewWrapper.frame
    updateAccessibility()
  }
}

extension BeforeAfterImageView: ThumbWrapperViewDelegate {
  
  func shouldIncreaseSlider() {
    let deltaX = originRect.origin.x + stepValueForAccessibility
    updateSliderValue(deltaX)
    originRect = afterImageViewWrapper.frame
    updateAccessibility()
  }
  
  func shouldReduceSlider() {
    let deltaX = originRect.origin.x - stepValueForAccessibility
    updateSliderValue(deltaX)
    originRect = afterImageViewWrapper.frame
    updateAccessibility()
  }
}

