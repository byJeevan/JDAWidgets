//
//  AlertConfigurations.swift
//  JDAWidgets
//
//  Created by Jeevan on 06/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import UIKit

enum AlertPresentingStyle {
  case popover
  case topDown
  case bottomUp
}

enum AlertShadowStyle {
  case dark
  case light

  var shadowColor: UIColor? {
    self == .light ? UIColor.white.withAlphaComponent(0.5) : UIColor.black.withAlphaComponent(0.5)
  }
}

protocol AlertPresentable {
  var alertPresentingStyle: AlertPresentingStyle? { get }
  var parentViewController: UIViewController? { get }
  var alertShadowStyle: AlertShadowStyle? { get }
  func didDismissed()
}

extension AlertPresentable {

  func showAlert() {

    guard let alertView = self as? UIView,
          let topViewController = self.parentViewController else { return } // Make sure the alert view of type UIView

    // Wrapping AlertView inside a view controller and Presenting as Modelly.
    let parentAlertViewController = UIViewController()
    let parentAlertView = parentAlertViewController.view!
    parentAlertView.frame = topViewController.view.bounds
    parentAlertView.backgroundColor = self.alertShadowStyle?.shadowColor
    parentAlertView.addSubview(alertView)
    parentAlertView.tag = 2_605
    alertView.isHidden = false

    switch alertPresentingStyle {

    case .popover :
      parentAlertViewController.modalPresentationStyle = .overCurrentContext
      parentAlertViewController.modalTransitionStyle = .crossDissolve
      setAlertViewContraints(targetView: alertView, parentView: parentAlertViewController.view)
      presentAsPopup(topViewController, parentAlertViewController)

    case .topDown:
      parentAlertViewController.modalPresentationStyle = .overCurrentContext
      parentAlertViewController.modalTransitionStyle = .coverVertical
      setSlideFromTopViewContraints(targetView: alertView, parentView: parentAlertView)
      presentAsTopdown(alertView, topViewController, parentAlertViewController)

    default:
      break
    }
  }

  func hideAlert() {
    guard let alertView = self as? UIView,
          let topViewController = self.parentViewController else { return } // Make sure the alert view of type UIView
    switch alertPresentingStyle {
    case .popover:
      dismissAsPopup(topViewController, animated: true)
    case .topDown:
      dismissAsBottomToTop(alertView, topViewController)
    default:
      break
    }
  }

}

private extension AlertPresentable {

  func setAlertViewContraints(targetView: UIView, parentView: UIView) {
    let alertWidthMultiplier: CGFloat = 0.75
    targetView.translatesAutoresizingMaskIntoConstraints = false
    targetView.widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: alertWidthMultiplier).isActive = true
    targetView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
    targetView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
  }

  func setSlideFromTopViewContraints(targetView: UIView, parentView: UIView) {
    targetView.translatesAutoresizingMaskIntoConstraints = false
    targetView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
    targetView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
  }

  func presentAsPopup(_ topViewController: UIViewController, _ parentAlertViewController: UIViewController) {
    topViewController.present(parentAlertViewController, animated: true, completion: nil)
  }

  func presentAsTopdown(_ alertView: UIView, _ topViewController: UIViewController, _ parentAlertViewController: UIViewController) {
    alertView.alpha = 0
    topViewController.present(parentAlertViewController, animated: false) { () -> Void in
      alertView.frame = CGRect(x: 0, y: -alertView.frame.height, width: alertView.frame.width, height: alertView.frame.height)
      alertView.alpha = 1
      UIView.animate(withDuration: 0.2, animations: { () -> Void in
        alertView.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height)
      },
      completion: nil)
    }
  }

  func dismissAsBottomToTop(_ alertView: UIView, _ topViewController: UIViewController) {
    UIView.animate(withDuration: 0.2, animations: { () -> Void in
      alertView.frame = CGRect(x: 0, y: -alertView.frame.height, width: alertView.frame.width, height: alertView.frame.height)
    },
    completion: { complete -> Void in
      alertView.isHidden = true
      if complete {
        dismissAsPopup(topViewController, animated: false)
      }
    })
  }

  func dismissAsPopup(_ topViewController: UIViewController, animated: Bool) {
    if topViewController.view.tag == 2_605 { // Make sure dismissing right controller
      topViewController.dismiss(animated: animated, completion: {
        didDismissed()
      })
    }
  }
}

extension UIApplication {
  func topViewController() -> UIViewController? {
    var topViewController: UIViewController?
    if #available(iOS 13, *) {
      for scene in connectedScenes {
        if let windowScene = scene as? UIWindowScene {
          for window in windowScene.windows where window.isKeyWindow {
            topViewController = window.rootViewController
          }
        }
      }
    } else {
      topViewController = keyWindow?.rootViewController
    }
    while true {
      if let presented = topViewController?.presentedViewController {
        topViewController = presented
      } else if let navController = topViewController as? UINavigationController {
        topViewController = navController.topViewController
      } else if let tabBarController = topViewController as? UITabBarController {
        topViewController = tabBarController.selectedViewController
      } else {
        // Handle any other third party container in `else if` if required
        break
      }
    }
    return topViewController
  }
}
