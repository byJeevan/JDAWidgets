//
//  CollapsibleHeaderViewModel.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 09/06/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation


class CollapsibleHeaderViewModel {
     var headerTitle = Binding<String>.init(value: "")
     var isCollpased = Binding<Bool>.init(value:true) //Important
     var sectionId:Int? //Important

     init(headerTitle:String?, isCollpased:Bool?, sectionId:Int?) {
         self.headerTitle.value = headerTitle ?? ""
         self.isCollpased.value = isCollpased ?? true
         self.sectionId = sectionId ?? 0
     }

}
