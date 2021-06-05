//
//  PageContainerVC.swift
//  JDAWidgets
//
//  Created by Jeevan on 05/06/21.
//  Copyright © 2021 jda. All rights reserved.
//

import Foundation
import UIKit

/*
 * Consists of Topbar menus and pages
 */
class PageContainerVC : UIViewController {

  @IBOutlet weak var pageContainerView: UIView!
  @IBOutlet weak var collectionContainerView: UIView!

  weak var pageController: PageController? {
    didSet {
      self.setControllersCoupling()
    }
  }

  weak var pageIndex: PageIndexCollectionViewController? {
    didSet {
      self.setControllersCoupling()
    }
  }

  var viewControllersToLoad = [UIViewController]()

  private func setControllersCoupling() {
    pageController?.pageIndexController = self.pageIndex
    pageIndex?.pageController = self.pageController
  }

  var categories = [ "Trending", "Special", "Favorites", "Local", "Most Recent", "Blogs", "Comments" ] // 1. Titles for menu

  var menuCellSize: CGSize = CGSize(width: 80, height: 30) // Enhancement: Auto sizable cell
  var spacingForItem: CGFloat = 10

  override func viewDidLoad(){
    setPageViewControllers()
    addPages()
    addMenus()
  }

  //2. View Controllers created for menu
  private func setPageViewControllers() {
    viewControllersToLoad = []
    for _ in (0..<categories.count) {
      let innerVC = UIViewController() // Create view controllers
      innerVC.view.backgroundColor = UIColor.random.withAlphaComponent(0.3)
      viewControllersToLoad.append(innerVC)
    }
  }
  private func addPages(){
    let vcOfNewsPage:PageController = PageController(nibName: "PageController", bundle: nil)
    vcOfNewsPage.view.frame = self.pageContainerView.bounds
    self.pageContainerView.addSubview(vcOfNewsPage.view)
    self.addChild(vcOfNewsPage)
    vcOfNewsPage.didMove(toParent: self)
    self.pageController = vcOfNewsPage
    self.pageController?.dataSource = self
  }

  private func addMenus(){
    let vcOfNewsMenuPage = PageIndexCollectionViewController(nibName: "PageIndexCollectionViewController", bundle: nil)
    vcOfNewsMenuPage.view.frame = self.collectionContainerView.bounds
    self.collectionContainerView.addSubview(vcOfNewsMenuPage.view)
    self.addChild(vcOfNewsMenuPage)
    vcOfNewsMenuPage.didMove(toParent: self)
    self.pageIndex = vcOfNewsMenuPage
    self.pageIndex?.dataSource = self
    setupMenuCollectionUI()

//    self.collectionContainerView.backgroundColor = UIColor.red
//    vcOfNewsMenuPage.view.backgroundColor =  UIColor.blue
//    vcOfNewsMenuPage.collectionView.backgroundColor =  UIColor.gray
  }

  private func setupMenuCollectionUI(){
    if let menuCollectionView = self.pageIndex?.collectionView {

      menuCollectionView.register(UINib(nibName: "IndexCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IndexCollectionViewCell")

      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      menuCollectionView.contentInset = .zero

      if let layout =  menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
        layout.itemSize = menuCellSize
        layout.minimumInteritemSpacing = spacingForItem
        layout.minimumLineSpacing = spacingForItem
        layout.invalidateLayout()
      }

      menuCollectionView.collectionViewLayout = layout
      menuCollectionView.showsVerticalScrollIndicator = false
      menuCollectionView.showsHorizontalScrollIndicator = false
    }
  }
}

extension PageContainerVC: PageControllerDataSource {

  func viewControllerAtIndex(index: Int) -> UIViewController {
    let viewControllerTag = viewControllersToLoad[index]
    return viewControllerTag
  }

  func numberOfViewControllers() -> Int {
    return viewControllersToLoad.count
  }
}

extension PageContainerVC : PageIndexCollectionViewControllerDataSource {

  func sizeForItem(at indexPath: IndexPath) -> CGSize {
    let titleString = categories[indexPath.row]
    let titleSize = (titleString).size(withAttributes:[.font: UIFont.systemFont(ofSize: 20.0)])
    return CGSize(width: titleSize.width, height: menuCellSize.height)
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndexCollectionViewCell", for: indexPath as IndexPath) as! IndexCollectionViewCell
    cell.indexLabel.text = categories[indexPath.row]
    return cell
  }

}

