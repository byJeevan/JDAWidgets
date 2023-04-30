//
//  BeforeAfterSliderExampleViewController.swift
//  JDAWidgets
//
//  Created by Jeevan Rao on 09/04/23.
//  Copyright © 2023 jda. All rights reserved.
//

import UIKit

final class BeforeAfterSliderExampleViewController: UIViewController {
  
  var beforeAfterImageView: BeforeAfterImageView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    beforeAfterImageView = BeforeAfterImageView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width - 10, height: self.view.frame.width - 10))
    beforeAfterImageView?.afterImageView.image = UIImage(named: "sample_2")
    beforeAfterImageView?.beforeImageView.image = UIImage(named: "sample_3")
    self.view.addSubview(beforeAfterImageView!)
  }
}
