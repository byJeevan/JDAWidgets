//
//  InnetTabPageViewController.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 30/04/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation
import UIKit

class InnerTabPageViewController: UIPageViewController {
    
    private var index = 0
    public var viewcontroller = [UIViewController]()
    public var pageDelegate:CustomPageDelegate?
    var isTransitioned = true
    
    var selectedIndex = 0 {
        didSet{
            self.openSelectedPage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white // SCConstant.Color.appLightGray
        self.delegate = self
        self.dataSource = self
        
        if let firstViewController = self.viewcontroller.first {
            self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    fileprivate func openSelectedPage()
    {
        if self.viewcontroller.count > 0
        {
            let viewController = self.viewcontroller[selectedIndex]
            let isForward = self.selectedIndex > self.index ? true : false
            self.index = self.selectedIndex
            print(">> %@", self.selectedIndex)
            self.setViewControllers([viewController], direction: isForward ? .forward : .reverse, animated: true, completion: nil)
        }
    }
}


extension InnerTabPageViewController :  UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.index == 0 {
            return nil
        }
        if !self.isTransitioned { return nil }
        self.index = self.index-1;
        return self.viewcontroller[self.index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.index == self.viewcontroller.count-1 {
            return nil
        }
        
        if !self.isTransitioned { return nil }
        
        self.index = self.index+1;
        return self.viewcontroller[self.index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        
        self.isTransitioned = completed
        
        if (completed) {
            if let firstViewController = viewControllers!.first,
                    let indexFirst = self.viewcontroller.firstIndex(of: firstViewController)
                {
                    self.selectedIndex = indexFirst
                    pageDelegate?.changePageSelection(index: indexFirst)
                }
        }
    
    }
    
}
