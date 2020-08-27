//
//  TopHeaderTestVC.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 26/08/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation
import UIKit


class TopHeaderTestVC : UIViewController {
    struct MenuItem1: MenuItemViewCustomizable {}
    struct MenuItem2: MenuItemViewCustomizable {}

    struct MenuOptions: MenuViewCustomizable {
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2()]
        }
    }

    struct PagingMenuOptions: PagingMenuControllerCustomizable {
        var componentType: ComponentType {
            
            let vc1 = UIViewController()
            vc1.view.backgroundColor = .red
            
            let vc2 = UIViewController()
            vc2.view.backgroundColor = .blue
            
            
            return .all(menuOptions: MenuOptions(), pagingControllers: [vc1, vc2])
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        let heightOfMenuRow:CGFloat = 60.0
        //To Add page Headers and Contents
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.view.frame = CGRect.init(x: 0, y: heightOfMenuRow,
                                                      width: self.view.bounds.width,
                                                      height: self.view.bounds.height - heightOfMenuRow)
        addChild(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMove(toParent: self)
        
         
    }
}
