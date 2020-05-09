//
//  HorizontalTabsViewController.swift
//  JDAWidgets
//
//  Created by Jeevan on 19/02/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

protocol CustomPageDelegate:class {
    func changePageSelection(index:Int)
}

struct TabHeaderStyles {
    var backgroundColor:UIColor?
    var selectionTint:UIColor?
    var unselectedTint:UIColor?
    
    init(backgroundColor:UIColor? = .white, selectionTint:UIColor? = .black, unselectedTint:UIColor? = .white) {
        self.backgroundColor = backgroundColor
        self.selectionTint = selectionTint
        self.unselectedTint = unselectedTint
    }
}

typealias TabHeaderData = (icon:UIImage?, title:String?)

class PageViewWithTab : UIViewController {
    
    var headers = [TabHeaderData]()
    var innerViews = [UIViewController]()
    
    struct Constant {
        static let maxItemInRow = 4
        static let tabbarHeight:CGFloat = 50.0
    }
    
    var style = TabHeaderStyles.init(backgroundColor: .white, selectionTint: .black, unselectedTint: .gray)//default style
    
    //MARK:- Widgets
    private let collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let cVC = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cVC.showsHorizontalScrollIndicator = false
        cVC.isScrollEnabled = true
        return cVC
    }()
    
    private let pageVc : InnerTabPageViewController = {
        let pg = InnerTabPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        return pg
    }()
    
    //MARK:- VC Lifecycle
    override func viewDidLoad() {
        self.pageVc.viewcontroller = self.innerViews
        self.pageVc.pageDelegate = self
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.pageVc.view)
        
        //todo-remove the dependency.
        self.collectionView.register(HorizontalHeaderTabsCell.self, forCellWithReuseIdentifier: HorizontalHeaderTabsCell.Constant.identifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.addBottomBorderWithColor(color: .lightGray, width: 1.0)
        self.addCollectionViewConstraints()
        self.addPageViewConstraints()
    }
    
    func addCollectionViewConstraints(){
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.collectionView.heightAnchor.constraint(equalToConstant: Constant.tabbarHeight).isActive = true
    }
    
    func addPageViewConstraints(){
        self.pageVc.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.pageVc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.pageVc.view.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor).isActive = true
        self.pageVc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.pageVc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func forceTabSelection(_ indexItem:Int){
        self.pageVc.selectedIndex = indexItem
        NotificationCenter.default.post(name: Notification.Name("PageViewChanged"), object: nil, userInfo: ["selectedIndex": indexItem])
        self.collectionView.reloadData()
    }
    
}

extension PageViewWithTab : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.innerViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalHeaderTabsCell.Constant.identifier, for: indexPath) as! HorizontalHeaderTabsCell
        cell.title = self.headers[indexPath.item].title ?? ""
        let isButtonTapped = self.pageVc.selectedIndex == indexPath.item ?  true : false
        
        cell.paintColor = isButtonTapped ? style.selectionTint : style.unselectedTint
        cell.icon = self.headers[indexPath.item].icon
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = self.innerViews.count < PageViewWithTab.Constant.maxItemInRow ? (collectionView.frame.size.width/CGFloat(self.innerViews.count)) : (collectionView.frame.size.width/CGFloat(PageViewWithTab.Constant.maxItemInRow))
        return CGSize(width: width, height: HorizontalHeaderTabsCell.Constant.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.forceTabSelection(indexPath.item)
    }
}

extension PageViewWithTab : CustomPageDelegate {
    
    func changePageSelection(index: Int) {
        let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems
        let indexPath = IndexPath(item: index, section: 0)
        
        if !visibleIndexPaths.contains(indexPath) {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
                self?.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .top)
            }
            
        }else{
            
            self.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .top)
            self.collectionView.reloadData()
        }
        
        NotificationCenter.default.post(name: Notification.Name("PageViewChanged"), object: nil, userInfo: ["selectedIndex": index])
    }
}
