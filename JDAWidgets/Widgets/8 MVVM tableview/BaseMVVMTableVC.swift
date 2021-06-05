//
//  MVVMTableViewController.swift
//  JDAWidgets
//
//  Created by Jeevan on 03/10/20.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

/*
 * BaseMVVMTableVC demo class for a Table view with MVVM
 */
class BaseMVVMTableVC : UIViewController {
    
    var sampleTableView: UITableView!
    var viewModel: BaseMVVMTableViewModel?
    
    struct Constants {
        static let tableCellId = "TableCellID"
        static let tableHeaderID =  "TableHeaderID"
    }
    
    //MARK:- Initilizers for class
    ///Inject view model
    init(viewModel: BaseMVVMTableViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK:- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        self.bindElements()
    }
    
    private func bindElements(){
        self.viewModel?.dataSource.bind({ (dataSource) in
            self.sampleTableView.reloadData()
        })
    }
    
    private func initTableView(){
        self.sampleTableView = UITableView(frame: self.view.bounds)
        self.sampleTableView.delegate = self
        self.sampleTableView.dataSource = self
        self.sampleTableView.register(DemoTableCellView.self, forCellReuseIdentifier: Constants.tableCellId)
        self.sampleTableView.register(DemoHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.tableHeaderID)
        self.view.addSubview(self.sampleTableView)
    }
}

//MARK:- Table View Delegates
extension BaseMVVMTableVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.numberOfSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.numberOfRows(at: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tableCellId) as? DemoTableCellView,
            let vm:DemoTableCellViewModel = self.viewModel?.rowItem(at: indexPath) {
            cell.cellViewModel = vm
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let tableHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.tableHeaderID) as? DemoHeaderFooterView,
            let vm:DemoHeaderFooterViewModel = self.viewModel?.sectionItem(at: section) {
            tableHeaderView.headerViewModel = vm
            return tableHeaderView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
