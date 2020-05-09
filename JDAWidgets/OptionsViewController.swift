//
//  ViewController.swift
//  JDAWidgets
//
//  Created by Jeevan on 13/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit


enum WidgetType:String, CaseIterable {
    case cardView = "Card View in ViewController"
    case floatingTextField = "Floating Label Text Field"
    case numberPad = "On screen number pad"
}

class OptionViewController: UIViewController {
    
    @IBOutlet weak var optionTableView: UITableView!
    
    struct Constants {
        static let tableId = "TableCellID"
        static let widgets:[WidgetType] =  WidgetType.allCases
    }
    
    //Step 1: ADD WIDGET ROW
    func gotoOption(_ type:WidgetType){
        switch type {
        case .cardView:
            self.navigationController?.pushViewController(WidgetCardViewController(), animated: true)
            break
        case .floatingTextField:
            self.navigationController?.pushViewController(FloatingTextFieldTestVC(), animated: true)
            break
        case .numberPad:
            let vc:AmountPadViewController = AmountPadViewController.instantiate(xibName: "AmountPadViewController")
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    
    //MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.optionTableView.delegate = self
        self.optionTableView.dataSource = self
        self.optionTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.tableId)
    }
    
}

//MARK:- Table View Delegates
extension OptionViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.widgets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableId) {
            cell.textLabel?.text = Constants.widgets[indexPath.row].rawValue
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gotoOption(Constants.widgets[indexPath.row])
    }
    
}
