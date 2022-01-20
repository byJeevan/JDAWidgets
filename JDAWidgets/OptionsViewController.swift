//
//  ViewController.swift
//  JDAWidgets
//
//  Created by Jeevan on 13/04/2020.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

enum WidgetType: String, CaseIterable {
  case cardView = "1. Card View in ViewController"
  case floatingTextField = "2. Floating Label Text Field"
  case numberPad = "3. On screen number pad"
  case topHeaderPage = "4. Top Header Menu with Horizontal Paging"
  case paginationTableView = "5. Pagination Tableview" // 5
  case expandableTableView = "6. Expandable TableView"
  case scrollableStackCard = "7. Stack view capable of scrolling when overflows"
  case mvvmTableViewTemplate = "8. Table View template for MVVM"
  case labelExtened = "9. Extended functional Labels"
  case galleryDetailedZoom = "10. Image Gallery with Thumbnail and Zoom support" // 10
  case customAlertView = "11. Any UIView into Custom Alert (100% with protocol extension)"
  case stetchableHeaderTable = "12. Table with Custom(header) view - which can stretch to max height when scrolled down or Shrinks to min height when scrolled up."
  case topicSelectionGrid = "13. Topics are displayed as grid and when it overflows a new row created."
}

class OptionViewController: UIViewController {

  @IBOutlet weak var optionTableView: UITableView!

  struct Constants {
    static let tableId = "TableCellID"
    static let widgets: [WidgetType] =  WidgetType.allCases
  }

  // MARK: - View Controller Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.optionTableView.delegate = self
    self.optionTableView.dataSource = self
    self.optionTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.tableId)
  }

}

// MARK: - Table View Delegates
extension OptionViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Constants.widgets.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableId) {
      cell.textLabel?.text = Constants.widgets[indexPath.row].rawValue
      cell.textLabel?.numberOfLines = 5
      cell.accessoryType = .disclosureIndicator
      return cell
    }

    return UITableViewCell()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.gotoOption(Constants.widgets[indexPath.row])
  }
}

private extension OptionViewController {

  func gotoOption(_ type: WidgetType) {
    switch type {
    case .cardView:
      self.navigationController?.pushViewController(WidgetCardViewController(), animated: true)

    case .floatingTextField:
      self.navigationController?.pushViewController(FloatingTextFieldTestVC(), animated: true)

    case .numberPad:
      let numberPadVC: AmountPadViewController = AmountPadViewController(nibName: "AmountPadViewController", bundle: nil)
      self.navigationController?.pushViewController(numberPadVC, animated: true)

    case .topHeaderPage :
      self.navigationController?.pushViewController(PageContainerVC(nibName: "PageContainerVC", bundle: nil), animated: true)

    case .paginationTableView:
      self.navigationController?.pushViewController(LazyTableViewController(), animated: true)

    case .expandableTableView:
      self.navigationController?.pushViewController(ExpandableTableViewController(), animated: true)

    case .scrollableStackCard:
      self.navigationController?.pushViewController(InBornViewController(), animated: true)

    case .mvvmTableViewTemplate :
      self.navigationController?.pushViewController(BaseMVVMTableVC(viewModel: BaseMVVMTableViewModel()), animated: true)

    case .labelExtened:
      self.navigationController?.pushViewController(ExtendedLabelVC(), animated: true)

    case .galleryDetailedZoom:
      let images = [
        UIImage(named: "sample_1")!,
        UIImage(named: "sample_2")!,
        UIImage(named: "sample_3")!
      ]
      self.navigationController?.pushViewController(GalleryDetailViewController.init(images: images, defaultIndex: 0), animated: true)

    case .customAlertView:
      self.navigationController?.pushViewController(AlertUsageViewController(), animated: true)

    case .stetchableHeaderTable:
      self.navigationController?.pushViewController(StretchableTableViewController(), animated: true)
      
    case .topicSelectionGrid:
      self.navigationController?.pushViewController(TopicsGridMenuViewController(), animated: true)

    }
  }

}
