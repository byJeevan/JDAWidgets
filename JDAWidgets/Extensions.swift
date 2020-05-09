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
