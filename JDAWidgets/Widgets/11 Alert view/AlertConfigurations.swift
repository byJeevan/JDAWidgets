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
  case popIn
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

protocol AlertPresentable: class {
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
    parentAlertView.tag = alertIdentifier
    alertView.isHidden = false
    parentAlertViewController.modalPresentationStyle = .overCurrentContext

    switch alertPresentingStyle {

    case .popIn :
      parentAlertViewController.modalTransitionStyle = .crossDissolve
      setAlertViewContraints(targetView: alertView, parentView: parentAlertViewController.view)
      presentAsPopup(topViewController, parentAlertViewController)

    case .topDown:
      parentAlertViewController.modalTransitionStyle = .coverVertical
      setSlideFromTopORBottomViewContraints(targetView: alertView, parentView: parentAlertView)
      presentAsTopdown(alertView, topViewController, parentAlertViewController)

    case .bottomUp:
      parentAlertViewController.modalTransitionStyle = .coverVertical
      setSlideFromTopORBottomViewContraints(targetView: alertView, parentView: parentAlertView)
      presentAsBottomUp(alertView, topViewController, parentAlertViewController)

    default:
      break
    }
  }

  func hideAlert() {
    guard let alertView = self as? UIView,
          let topViewController = self.parentViewController else { return } // Make sure the alert view of type UIView
    switch alertPresentingStyle {
    case .popIn:
      dismissAsPopup(topViewController, animated: true)
    case .topDown:
      dismissAsBottomToTop(alertView, topViewController)
    case .bottomUp:
      dismissAsTopToBottom(alertView, topViewController)
    default:
      break
    }
  }

}

private extension AlertPresentable {

  var alertIdentifier: Int {
    return 2_6056
  }

  func setAlertViewContraints(targetView: UIView, parentView: UIView) {
    targetView.translatesAutoresizingMaskIntoConstraints = false
    targetView.widthAnchor.constraint(equalToConstant: dialogWidthCalculated).isActive = true
    targetView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
    targetView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
  }

  func setSlideFromTopORBottomViewContraints(targetView: UIView, parentView: UIView) {
    targetView.translatesAutoresizingMaskIntoConstraints = false
    targetView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
    targetView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
  }

  var dialogWidthCalculated: CGFloat {
    let multiplier: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0.75
    let screenMinBound: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    return multiplier * screenMinBound
  }

  // MARK: - Presenters
  func presentAsPopup(_ topViewController: UIViewController, _ parentAlertViewController: UIViewController) {
    topViewController.present(parentAlertViewController, animated: true, completion: nil)
  }

  func presentAsTopdown(_ alertView: UIView, _ topViewController: UIViewController, _ parentAlertViewController: UIViewController) {
    alertView.alpha = 0
    topViewController.present(parentAlertViewController, animated: false) { () -> Void in
      alertView.frame = CGRect(x: 0, y: -alertView.frame.height, width: alertView.frame.width, height: alertView.frame.height)
      alertView.alpha = 1
      UIView.animate(withDuration: 0.25, animations: { () -> Void in
        alertView.frame = CGRect(x: 0, y: 0, width: alertView.frame.width, height: alertView.frame.height)
      },
      completion: nil)
    }
  }

  func presentAsBottomUp(_ alertView: UIView, _ topViewController: UIViewController, _ parentAlertViewController: UIViewController) {
    alertView.alpha = 0
    topViewController.present(parentAlertViewController, animated: false) { () -> Void in
      alertView.frame = CGRect(x: 0, y: topViewController.view.bounds.height,
                               width: alertView.frame.width, height: alertView.frame.height)
      alertView.alpha = 1
      UIView.animate(withDuration: 0.25, animations: { () -> Void in
        alertView.frame = CGRect(x: 0, y: topViewController.view.bounds.height - alertView.frame.height,
                                 width: alertView.frame.width, height: alertView.frame.height)
      },
      completion: nil)
    }
  }

  // MARK: - Dismissers
  func dismissAsPopup(_ topViewController: UIViewController, animated: Bool) {
    if topViewController.view.tag == alertIdentifier { // Make sure dismissing right controller
      topViewController.dismiss(animated: animated, completion: { [weak self] in
        self?.didDismissed()
      })
    }
  }

  func dismissAsBottomToTop(_ alertView: UIView, _ topViewController: UIViewController) {
    UIView.animate(withDuration: 0.2, animations: { () -> Void in
      alertView.frame = CGRect(x: 0, y: -alertView.frame.height, width: alertView.frame.width, height: alertView.frame.height)
    },
    completion: { [weak self] complete -> Void in
      alertView.isHidden = true
      if complete {
        self?.dismissAsPopup(topViewController, animated: false)
      }
    })
  }

  func dismissAsTopToBottom(_ alertView: UIView, _ topViewController: UIViewController) {
    UIView.animate(withDuration: 0.2, animations: { () -> Void in
      alertView.frame = CGRect(x: 0, y: topViewController.view.bounds.height, width: alertView.frame.width, height: alertView.frame.height)
    },
    completion: { [weak self] complete -> Void in
      alertView.isHidden = true
      if complete {
        self?.dismissAsPopup(topViewController, animated: false)
      }
    })
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
