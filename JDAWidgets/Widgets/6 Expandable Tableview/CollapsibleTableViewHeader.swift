//
//  CollapsibleTableViewHeader.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 09/06/20.
//  Copyright © 2020 jda. All rights reserved.
//

import Foundation
import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader : UITableViewHeaderFooterView {
    
    //MARK:- Cell constants
    struct Constant {
        static let id = "CollapsibleTableViewHeader"
        static let nibName = "CollapsibleTableViewHeader"
    }
    
    //MARK:- Public properties
    var delegate: CollapsibleTableViewHeaderDelegate?
    
    @objc @IBOutlet weak var planHeaderTitle: UILabel!
    @objc @IBOutlet weak var headerIcon: UIImageView!
    
    var viewModel:CollapsibleHeaderViewModel? {
        didSet {
            self.bindUIElements()
        }
    }
    
    
    //MARK:- Initializers
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initElementStyle()
        
    }
    
    //MARK:- Private methods
    private func initElementStyle() {
        self.contentView.backgroundColor = .systemPink
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(tapHeader(_ :))
        ))
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(header: self, section: cell.viewModel?.sectionId ?? 0)
    }
    
    private func changeArrowDirection(_ collapsed: Bool) {
        self.headerIcon.image = UIImage.init(named: collapsed ? "plus" : "minus")
    }
    
    private func bindUIElements(){
        self.viewModel?.isCollpased.bind { [unowned self] (isCollpsed) in
            self.changeArrowDirection(isCollpsed)
        }
        
        self.viewModel?.headerTitle.bind({ [unowned self] (title) in
            self.planHeaderTitle.text = title
        })
    }
    
}
