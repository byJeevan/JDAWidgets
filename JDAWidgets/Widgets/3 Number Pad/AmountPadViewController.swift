//
//  AmountPadViewController.swift
//  JDAWidgets
//
//  Created by Jeevan on 19/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

class AmountPadViewController : UIViewController {
    
    @IBOutlet weak var amountPad: NumberPadView!
    @IBOutlet weak var displayLabel: UILabel!
    
    var amountWholeDegits:[Int] = []
    var amountDecimalDigits:[Int] = []
    
    var isDecimalEnabled = false
    var kDecimalMaxLimit = 4
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        amountPad.inputDelegate = self
        self.prefillAmountFrom(0)
    }
    
    func updatedAmount(_ amount:String) {
        self.displayLabel.text = "$ \(amount)"
    }
    
}

extension AmountPadViewController : NumberPadInputProtocol {
    
    func prefillAmountFrom(_ amount:Double) {
        amountWholeDegits = amount.whole.digits
        amountDecimalDigits = amount.fraction.digits
        
        //avoids for eg. 123.00
        if let _ = amountDecimalDigits.first(where: { $0 != 0 }) {
            self.isDecimalEnabled = true //if any decimal value persits, keep editing as decimal part.
        }
        else{
            amountDecimalDigits = []
        }
        
        stichAmountDigits()
    }
    
    func stichAmountDigits(){
        //Mapping Digits array stream into Single Display String
        
        //cleanup
        if let _ = amountWholeDegits.first(where: { $0 != 0 }) {
            //continue if any non-zero digits
        }
        else {
            amountWholeDegits = [0] //avoids empty Amount by placing '0'
        }
        
        var amountString:String = amountWholeDegits.map { String($0) }.joined(separator: "")
        
      if !amountDecimalDigits.isEmpty {
            amountString.append(".\(amountDecimalDigits.map { String($0) }.joined(separator: ""))")
        }
        
        self.updatedAmount(amountString)
    }
    
    func didEnterNumber(_ number: Int) {
        if isDecimalEnabled == true {
            if amountDecimalDigits.count >= kDecimalMaxLimit {
                return
            }
            amountDecimalDigits.append(number)
        }
        else{
            if(amountWholeDegits.count == 1) && amountWholeDegits[0] == 0 {
                //Condition avoid 0 at beginning "0123..."
                amountWholeDegits.removeAll()
            }
            amountWholeDegits.append(number)
        }
        self.stichAmountDigits()
    }
    
    func didClearTapped() {
        if isDecimalEnabled && !amountDecimalDigits.isEmpty {
            amountDecimalDigits = amountDecimalDigits.dropLast()
            if amountDecimalDigits.isEmpty {
                self.isDecimalEnabled = false
            }
        } else{
            amountWholeDegits = amountWholeDegits.dropLast()
        }
        
        self.stichAmountDigits()
    }
    
    func decimalTapped() {
        self.isDecimalEnabled = true
    }
    
    func didTickTapped() {
        //Do when tick button pressed.
        print("Entered \(self.displayLabel.text ?? "")")
    }
    
}

extension Double {
    var whole: Double { return modf(self).0 }
    var fraction: Double { return modf(self).1 }
    
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}

