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
    case topHeaderPage = "Top Header Menu with Horizontal Paging"
    case paginationTableView = "Pagination Tableview" // 5
    case expandableTableView = "Expandable TableView"
    case scrollableStackCard = "Stack view capable of scrolling when overflows"
    case mvvmTableViewTemplate = "Table View template for MVVM"
    case labelExtened = "Extended functional Labels"
    case galleryDetailedZoom = "Image Gallery with Thumbnail and Zoom support" // 10

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
        case .topHeaderPage :
          self.navigationController?.pushViewController(PageContainerVC(nibName: "PageContainerVC", bundle: nil), animated: true)
            break
        case .paginationTableView:
            self.navigationController?.pushViewController(LazyTableViewController(), animated: true)
            break
        case .expandableTableView:
            self.navigationController?.pushViewController(ExpandableTableViewController(), animated: true)
            break
        case .scrollableStackCard:
            self.navigationController?.pushViewController(InBornViewController(), animated: true)
            break
        case .mvvmTableViewTemplate :
            self.navigationController?.pushViewController(BaseMVVMTableVC(viewModel: BaseMVVMTableViewModel()), animated: true)
            break
        case .labelExtened:
            self.navigationController?.pushViewController(ExtendedLabelVC(), animated: true)
            break
        case .galleryDetailedZoom:
          let images = [
                UIImage(named: "sample_1")!,
                UIImage(named: "sample_2")!,
                UIImage(named: "sample_3")!
              ]
          self.navigationController?.pushViewController(GalleryDetailViewController.init(images: images, defaultIndex: 0), animated: true)

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
            cell.textLabel?.numberOfLines = 3
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.gotoOption(Constants.widgets[indexPath.row])
    }
    
}
