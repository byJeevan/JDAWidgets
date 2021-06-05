//
//  AmountPad.swift
//  JDAWidgets
//
//  Created by Jeevan on 19/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

/*
 * NumberPadView is sublcass of UIView which will draw common number pad for Phone Number, PIN screens.
 */
protocol NumberPadInputProtocol : class  {
    func didEnterNumber(_ number:Int)
    func didClearTapped()
    func didTickTapped()
    func decimalTapped()
}

@IBDesignable
class NumberPadView : UIView {
    
    weak var inputDelegate:NumberPadInputProtocol?
    
    enum NumberTags : Int {
        case zero = 0
        case one = 1
        case two = 2
        case three = 3
        case four = 4
        case five = 5
        case six = 6
        case seven = 7
        case eight = 8
        case nine = 9
        case empty = 100
        case tick = 101
        case del = 102
        case decimal = 103
        
    }
    
    struct Constants {
        static let buttonTitleColor:UIColor = .gray
        static let buttonFont:UIFont = UIFont.systemFont(ofSize: 30)
    }
    
    private let gridView = GridStackView.init(rowSize: 3, rowHeight: 5)
    
    @IBInspectable
    public var enableTickButton:Bool = false
    
    @IBInspectable
    public var enableClearButton:Bool = false
    
    @IBInspectable
    public var enableDecimalButton:Bool = false
    
    //MARK:- Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gridView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.gridView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.gridView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.gridView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    
    //MARK:- Private methods
    internal func setupView() {
        gridView.addCell(view: createPadButton("1", NumberTags.one.rawValue))
        gridView.addCell(view: createPadButton("2", NumberTags.two.rawValue))
        gridView.addCell(view: createPadButton("3", NumberTags.three.rawValue))
        gridView.addCell(view: createPadButton("4", NumberTags.four.rawValue))
        gridView.addCell(view: createPadButton("5", NumberTags.five.rawValue))
        gridView.addCell(view: createPadButton("6", NumberTags.six.rawValue))
        gridView.addCell(view: createPadButton("7", NumberTags.seven.rawValue))
        gridView.addCell(view: createPadButton("8", NumberTags.eight.rawValue))
        gridView.addCell(view: createPadButton("9", NumberTags.nine.rawValue))
        
        if enableDecimalButton {
            gridView.addCell(view: createPadButton(".", NumberTags.decimal.rawValue))
        }
        else{
            gridView.addCell(view: createPadButton("  ", NumberTags.empty.rawValue))
        }
        
        gridView.addCell(view: createPadButton("0", NumberTags.zero.rawValue))
        
        if (enableTickButton){
            gridView.addCell(view: createPadButton("",NumberTags.tick.rawValue))
            
        }
        if (enableClearButton){
            gridView.addCell(view: createPadButton("", NumberTags.del.rawValue))
            
        }
        self.addSubview(gridView)
        
        if (enableTickButton == true && enableClearButton == true ) {
            assertionFailure("Button Conflicts : Either Tick button or Clear/Delete button expected. Both cannot be enabled")
        }
        
    }
    
    internal func createPadButton(_ title:String,_ tag:Int) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(Constants.buttonTitleColor, for: .normal)
        button.titleLabel?.font = Constants.buttonFont
        button.tag = tag
        button.addTarget(self, action: #selector(didTappedButton(_ :)), for: .touchUpInside)
        button.layer.cornerRadius = 0.6
        self.setIconAndTarget(button, tag)
        
        return button
    }
    
    internal func setIconAndTarget(_ button:UIButton,_ tag:Int) {
        switch tag {
        case NumberTags.tick.rawValue :
            button.setImage(UIImage.init(named: "tick"), for: .normal)
        case NumberTags.del.rawValue :
            button.setImage(UIImage.init(named: "backspace"), for: .normal)
        default:
            break;
        }
        
    }
    
    internal func highlightAnimator(_ sender:UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.backgroundColor = UIColor.black.withAlphaComponent(0.02)
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (isCompleted) in
            
            UIView.animate(withDuration: 0.15, animations: {
                sender.backgroundColor = UIColor.white
                sender.transform = CGAffineTransform.identity
                
            }) { (isCompleted) in
                //do nothing.
            }
        }
    }
    
    @objc func didTappedButton(_ sender:UIButton) {
        self.highlightAnimator(sender)
        
        if let delegate = self.inputDelegate {
            if((0...9).contains(sender.tag))  {
                delegate.didEnterNumber(sender.tag)
            } //Only numbers 0-9 notified
            
            if sender.tag == NumberTags.tick.rawValue {
                delegate.didTickTapped()
            }
            
            if sender.tag == NumberTags.del.rawValue {
                delegate.didClearTapped()
            }
            
            if sender.tag == NumberTags.decimal.rawValue {
                delegate.decimalTapped()
            }
            
        }
    }
}

