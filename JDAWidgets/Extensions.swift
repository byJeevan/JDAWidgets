//
//  Extensions.swift
//  JDAWidgets
//
//  Created by Jeevan on 19/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit


extension UIViewController {
    
    static func instantiate<TController: UIViewController>(_ storyboardName: String) -> TController {
        return instantiateFromStoryboardHelper(storyboardName)
    }
    
    static func instantiate<TController: UIViewController>(_ storyboardName: String, identifier: String) -> TController {
        return instantiateFromStoryboardHelper(storyboardName, identifier: identifier)
    }
    
    fileprivate static func instantiateFromStoryboardHelper<T: UIViewController>(_ name: String, identifier: String? = nil) -> T {
        let storyboard = UIStoryboard(name: name, bundle: Bundle(for: self))
        return storyboard.instantiateViewController(withIdentifier: identifier ?? String(describing: self)) as! T
    }
    
    static func instantiate<TController: UIViewController>(xibName: String? = nil) -> TController {
        return TController(nibName: xibName ?? String(describing: self), bundle: Bundle(for: self))
    }
    
}

 extension UIViewController {
     func add(_ child: UIViewController) {
        addChild(child)
         view.addSubview(child.view)
        child.didMove(toParent: self)
     }
     
     func remove() {
         // Just to be safe, we check that this view controller
         // is actually added to a parent before removing it.
         guard parent != nil else {
             return
         }
         
        willMove(toParent: nil)
         view.removeFromSuperview()
        removeFromParent()
     }
 }

extension UIView {
    
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,
                              width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }
}
