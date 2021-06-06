//
//  FloatingTextField.swift
//  JDAWidgets
//
//  Created by Jeevan on 18/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation
import UIKit

/*
 * Custom Textfield :
 * Active - Underline color
 * starts editing -top place holder
 * Disable style
 * Error message - override option
 */

/* View Structure:
 --<Floating Placeholder Label>--~15h
 --<TextField>--~30h
 --<Separator Line View>--1h
 --<Error Label>--~20h
 */

@IBDesignable
open class FloatingTextField: UITextField {

  // Note : Keep additional bottom space in parent view to render Error text.
  // Constants
  struct Constants {
    struct Font {
      static let font14 = UIFont.systemFont(ofSize: 14)
      static let font12 = UIFont.systemFont(ofSize: 12)
    }

    struct Color {
      static let defaultHighlightColor = UIColor.blue
    }
  }

  // MARK: - Initializers
  override public init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.setup()
  }

  fileprivate final func setup() {
    self.borderStyle = .none
    self.createTitleLabel()
    self.createErrorLabel()
    self.createLineView()
    self.updateColors()
    self.updateTextAligment()
    self.addTarget(self, action: #selector(notify_editingChanged), for: .editingChanged)
    self.appRelatedStyles()
  }

  func appRelatedStyles() {
    self.clearButtonMode = .whileEditing
    self.font = Constants.Font.font14
  }

  @objc open func notify_editingChanged() {
    updateControl(true)
    updateTitleLabel(true)
  }

  // MARK: Views
  open var titleLabel: UILabel! // the label above input text
  open var lineView: UIView! // the line below input text
  open var errorLabel: UILabel! // the error label below input text

  // MARK: Animation
  open var titleFadeInDuration: TimeInterval = 0.2
  open var titleFadeOutDuration: TimeInterval = 0.3

  // MARK: Colors
  override open var textColor: UIColor? {
    didSet {
      self.updateControl(false)
    }
  }

  @IBInspectable  open var enabledTextColor: UIColor = UIColor.darkGray {
    didSet {
      self.updateControl(false)
    }
  }

  @IBInspectable open var disabledTextColor: UIColor = UIColor.gray {
    didSet {
      self.updateControl(false)
    }
  }

  @IBInspectable open var placeholderColor: UIColor = UIColor.lightGray {
    didSet {
      self.updatePlaceholder()
    }
  }

  @IBInspectable open var placeholderFont: UIFont? {
    didSet {
      self.updatePlaceholder()
    }
  }

  @IBInspectable  open var titleColor: UIColor = UIColor.lightGray {
    didSet {
      self.updateTitleColor()
    }
  }

  @IBInspectable open var selectedTitleColor: UIColor = UIColor.gray {
    didSet {
      self.updateTitleColor()
    }
  }

  @IBInspectable open var lineColor: UIColor = UIColor.lightGray {
    didSet {
      self.updateLineView()
    }
  }

  @IBInspectable  open var selectedLineColor: UIColor =  Constants.Color.defaultHighlightColor {
    didSet {
      self.updateLineView()
    }
  }

  @IBInspectable  open var errorColor: UIColor = UIColor.red {
    didSet {
      self.updateColors()
    }
  }

  @IBInspectable open var lineHeight: CGFloat = 1.0 {
    didSet {
      self.updateLineView()
      self.setNeedsDisplay()
    }
  }

  @IBInspectable  open var selectedLineHeight: CGFloat = 1.0 {
    didSet {
      self.updateLineView()
      self.setNeedsDisplay()
    }
  }

  open var restrictTextPaste = false

  // MARK: Properties
  // Identifies whether the text object should hide the text being entered.
  override open var isSecureTextEntry: Bool {
    get {
      return super.isSecureTextEntry
    }
    set {
      super.isSecureTextEntry = newValue
      self.fixCaretPosition()
    }
  }

  // A string for errorLabel
  open var error: String? {
    didSet {
      self.updateControl(true)
    }
  }

  // A Boolean value that determines whether the textfield is being edited or is selected.
  open var editingOrSelected: Bool {
    return super.isEditing || self.isSelected
  }

  // A Boolean value that determines whether the receiver has an error message.
  open var hasError: Bool {
    return self.error != nil && self.error != ""
  }

  override open var isEnabled: Bool {
    didSet {
      self.textColor = isEnabled ? self.enabledTextColor : self.disabledTextColor
    }
  }

  fileprivate var _renderingInInterfaceBuilder: Bool = false

  // The text content of the textfield
  override open var text: String? {
    didSet {
      self.updateControl(false)
    }
  }

  // The String to display when the input field is empty.
  // The placeholder can also appear in the title label when both `title` `selectedTitle` and are `nil`.
  override open var placeholder: String? {
    didSet {
      self.setNeedsDisplay()
      self.updatePlaceholder()
      self.updateTitleLabel()
    }
  }

  // The String to display when the textfield is editing and the input is not empty.
  open var selectedTitle: String? {
    didSet {
      self.updateControl()
    }
  }

  // The String to display when the textfield is not editing and the input is not empty.
  open var title: String? {
    didSet {
      self.updateControl()
    }
  }

  // Determines whether the field is selected. When selected, the title floats above the textbox.
  open override var isSelected: Bool {
    didSet {
      self.updateControl(true)
    }
  }

  // MARK: create components

  fileprivate func createTitleLabel() {
    let label = UILabel()
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    label.font = Constants.Font.font12
    label.alpha = 0.0
    label.textColor = self.titleColor
    label.accessibilityIdentifier = "title-label"
    self.addSubview(label)
    self.titleLabel = label
  }

  fileprivate func createLineView() {
    let view = UIView()
    self.lineView = view
    let onePixel: CGFloat = 1.0 / UIScreen.main.scale
    self.lineHeight = onePixel
    self.selectedLineHeight = onePixel
    view.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    view.isUserInteractionEnabled = false
    view.accessibilityIdentifier = "line-view"
    self.addSubview(view)
  }

  fileprivate func createErrorLabel() {
    let label = UILabel()
    label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    label.font = Constants.Font.font12
    label.alpha = 1.0
    label.numberOfLines = 0
    label.textColor = self.errorColor
    label.accessibilityIdentifier = "error-label"
    self.addSubview(label)
    self.errorLabel = label
  }

  // MARK: Responder handling

  // Attempt the control to become the first responder
  // - returns: True when successfully becoming the first responder
  override open func becomeFirstResponder() -> Bool {
    let result = super.becomeFirstResponder()
    self.updateControl(true)
    return result
  }

  // Attempt the control to resign being the first responder
  // - returns: True when successfully resigning being the first responder
  override open func resignFirstResponder() -> Bool {
    let result =  super.resignFirstResponder()
    self.updateControl(true)
    return result
  }

  // MARK: - View updates

  fileprivate func updateControl(_ animated: Bool = false) {
    self.invalidateIntrinsicContentSize()
    self.updateColors()
    self.updateLineView()
    self.updateTitleLabel(animated)
    self.updateErrorLabel(animated)
  }

  fileprivate func updateLineView() {
    if let lineView = self.lineView {
      lineView.frame = self.lineViewRectForBounds(self.bounds, editing: self.editingOrSelected)
    }
    self.updateLineColor()
  }

  fileprivate func updatePlaceholder() {
    if let placeholder = self.titleOrPlaceholder(), let font = self.placeholderFont ?? self.font {
      let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: placeholderColor, .font: font]
      self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
  }

  // MARK: - Color updates

  // Update the colors for the control. Override to customize colors.
  open func updateColors() {
    self.updateLineColor()
    self.updateTitleColor()
  }

  fileprivate func updateLineColor() {
    if self.hasError {
      self.lineView.backgroundColor = self.errorColor
    } else {
      self.lineView.backgroundColor = self.editingOrSelected ? self.selectedLineColor : self.lineColor
    }
  }

  fileprivate func updateTitleColor() {
    if self.editingOrSelected {
      self.titleLabel.textColor = self.selectedTitleColor
    } else {
      self.titleLabel.textColor = self.titleColor
    }
  }

  // MARK: - Title handling

  fileprivate func updateTitleLabel(_ animated: Bool = false) {
    self.titleLabel.text = self.titleOrPlaceholder()
    self.updateTitleVisibility(animated)
  }

  fileprivate func updateErrorLabel(_ animated: Bool = false) {
    self.errorLabel.text = error
    self.invalidateIntrinsicContentSize()
  }

  fileprivate var _titleVisible = false

  // Set this value to make the title visible
  open func setTitleVisible(_ titleVisible: Bool, animated: Bool = false, animationCompletion: (() -> Void)? = nil) {
    if _titleVisible == titleVisible {
      return
    }
    _titleVisible = titleVisible
    self.updateTitleColor()
    self.updateTitleVisibility(animated, completion: animationCompletion)
  }

  // Returns whether the title is being displayed on the control.
  open func isTitleVisible() -> Bool {
    return self.hasText || _titleVisible
  }

  fileprivate func updateTitleVisibility(_ animated: Bool = false, completion: (() -> Void)? = nil) {
    let alpha: CGFloat = self.isTitleVisible() ? 1.0 : 0.0
    let frame: CGRect = self.titleLabelRectForBounds(self.bounds, editing: self.isTitleVisible())
    let updateBlock = { () -> Void in
      self.titleLabel.alpha = alpha
      self.titleLabel.frame = frame
    }
    if animated {
      let animationOptions: UIView.AnimationOptions = .curveEaseOut
      let duration = self.isTitleVisible() ? titleFadeInDuration : titleFadeOutDuration

      UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: { () -> Void in
        updateBlock()
      }, completion: { _ in
        completion?()
      })
    } else {
      updateBlock()
      completion?()
    }
  }

  // MARK: - UITextField element positioning overrides

  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    let titleHeight = self.titleHeight()
    let lineHeight = self.selectedLineHeight
    let rect = CGRect(x: 0, y: titleHeight, width: bounds.size.width, height: bounds.size.height - titleHeight - lineHeight)
    return rect
  }

  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return textRect(forBounds: bounds)
  }

  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return textRect(forBounds: bounds)
  }

  override open func rightViewRect(forBounds bounds: CGRect) -> CGRect {
    var rect = textRect(forBounds: bounds)
    rect.size.width = 34
    rect.origin.x = bounds.size.width - rect.size.width
    return rect
  }

  override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    return rightViewRect(forBounds: bounds)
  }

  // MARK: - Custom view positioning overrides

  open func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
    let titleHeight = self.titleHeight()
    if editing {
      return CGRect(x: 0, y: 0, width: bounds.size.width, height: titleHeight)
    }
    return CGRect(x: 0, y: titleHeight, width: bounds.size.width, height: titleHeight)
  }

  open func lineViewRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
    let lineHeight: CGFloat = editing ? CGFloat(self.selectedLineHeight) : CGFloat(self.lineHeight)
    return CGRect(x: 0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
  }

  open func errorLabelRectForBounds(_ bounds: CGRect) -> CGRect {
    guard let error = error, !error.isEmpty else { return CGRect.zero }
    let font: UIFont = errorLabel.font ?? UIFont.systemFont(ofSize: 17.0)
    let topPaddingForError: CGFloat = 5.0
    let textAttributes = [NSAttributedString.Key.font: font]
    let size = CGSize(width: bounds.size.width, height: 2000)
    let boundingRect = error.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
    return CGRect(x: 0, y: topPaddingForError + bounds.size.height, width: boundingRect.size.width, height: boundingRect.size.height)
  }

  // Calculate the height of the top title label.
  open func titleHeight() -> CGFloat {
    if let titleLabel = self.titleLabel,
       let font = titleLabel.font {
      return font.lineHeight
    }
    return 15.0
  }

  // Calcualte the height of the textfield.
  open func textHeight() -> CGFloat {
    return (self.font?.lineHeight ?? 15.0) + 7.0
  }

  open func errorHeight() -> CGFloat {
    return self.errorLabelRectForBounds(self.bounds).size.height
  }

  // MARK: - Layout

  // Invoked when the interface builder renders the control
  override open func prepareForInterfaceBuilder() {
    if #available(iOS 8.0, *) {
      super.prepareForInterfaceBuilder()
    }
    self.isSelected = true
    _renderingInInterfaceBuilder = true
    self.updateControl(false)
    self.invalidateIntrinsicContentSize()
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    self.invalidateIntrinsicContentSize()
    self.titleLabel.frame = self.titleLabelRectForBounds(self.bounds, editing: self.isTitleVisible() || _renderingInInterfaceBuilder)
    self.errorLabel.frame = self.errorLabelRectForBounds(self.bounds)
    self.lineView.frame = self.lineViewRectForBounds(self.bounds, editing: self.editingOrSelected || _renderingInInterfaceBuilder)

    // Fix unwanted rightView sliding in animation when it's first shown
    // https://stackoverflow.com/questions/18853972/how-to-stop-the-animation-of-uitextfield-rightview
    rightView?.frame = rightViewRect(forBounds: bounds)
  }

  override open var intrinsicContentSize: CGSize {
    let height = self.titleHeight() + self.textHeight() // + self.errorHeight()
    return CGSize(width: self.bounds.size.width, height: height)
  }

  // MARK: - Helpers
  fileprivate func titleOrPlaceholder() -> String? {
    if let title = self.title ?? self.placeholder {
      return title
    }
    return nil
  }

  // MARK: Left to right support
  var isLeftToRightLanguage = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
    didSet {
      self.updateTextAligment()
    }
  }

  fileprivate func updateTextAligment() {
    if self.isLeftToRightLanguage {
      self.textAlignment = .left
    } else {
      self.textAlignment = .right
    }
  }

  open override var description: String {
    return "[FloatingTextField(\(String(describing: placeholder))) text:\(String(describing: text))]"
  }

}

fileprivate extension UITextField {
  // Moves the caret to the correct position by removing the trailing whitespace
  func fixCaretPosition() {
    // Moving the caret to the correct position by removing the trailing whitespace
    // http://stackoverflow.com/questions/14220187/uitextfield-has-trailing-whitespace-after-securetextentry-toggle
    let beginning = self.beginningOfDocument
    self.selectedTextRange = self.textRange(from: beginning, to: beginning)
    let end = self.endOfDocument
    self.selectedTextRange = self.textRange(from: end, to: end)
  }
}
