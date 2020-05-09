//
//  GridStackView.swift
//  JDAWidgets
//
//  Created by Jeevan on 19/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

class GridStackView : UIStackView {
    
    private var cells: [UIView] = []
    
    private var currentRow: UIStackView?
    
    let rowSize: Int
    
    let rowHeight: CGFloat
    
    let paddingBetweenButton:CGFloat = 20.0
    
    init(rowSize: Int, rowHeight: CGFloat) {
        self.rowSize = rowSize
        self.rowHeight = rowHeight
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .vertical
        self.distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preapreRow() -> UIStackView {
        let row = UIStackView(arrangedSubviews: [])
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.spacing = paddingBetweenButton
        row.distribution = .fillEqually
        return row
    }
    
    
    func addCell(view: UIView) {
        self.currentRow?.spacing = paddingBetweenButton
        
        self.currentRow?.arrangedSubviews.filter { $0 is PlaceHolderView }.forEach({ view in
            view.removeFromSuperview()
        })
        
        let firstCellInRow = self.cells.count % self.rowSize == 0
        if self.currentRow == nil || firstCellInRow {
            self.currentRow = self.preapreRow()
            self.addArrangedSubview(self.currentRow!)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: self.rowHeight).isActive = true
        self.cells.append(view)
        self.currentRow!.addArrangedSubview(view)
        
        let lastCellInRow = self.cells.count % self.rowSize == 0
        if !lastCellInRow {
            let fakeCellCount = self.rowSize - self.cells.count % self.rowSize
            for _ in 0..<fakeCellCount {
                self.currentRow!.addArrangedSubview(PlaceHolderView())
            }
        }
    }
    
}


class PlaceHolderView : UIView {
    
}
