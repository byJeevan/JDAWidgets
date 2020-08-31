//
//  LazyTableViewController.swift
//  JDAWidgets
//
//  Created by Jeevan-1382 on 04/06/20.
//  Copyright © 2020 jda. All rights reserved.
//

import UIKit

class LazyTableViewController : UIViewController {
    
    //MARK:- Public properties
    private var tableView:UITableView = UITableView.init(frame: .zero, style: .grouped) //any style.
    let spinner = UIActivityIndicatorView(style: .gray)
    
    private var dataSource:[String] = ["Pull up to add more rows..."]
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUIElements()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
    //MARK:- Initialize UI Elements
    private func initUIElements() {
        self.view.addSubview(tableView)
        //initialize table
        tableView.delegate = self
        tableView.dataSource = self
        
        //**** Custom Footer view *****/
        spinner.color = UIColor.darkGray
        spinner.hidesWhenStopped = true
        spinner.frame  = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        tableView.tableFooterView = spinner
        //*** End of Custom Footer view *****/
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    func retriedData() {
        if self.spinner.isAnimating { //avoid calls for more than one time.
            return
        }
        
        self.spinner.startAnimating()
        //do update data source from API Calls
        //example mocked:
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.dataSource.append("\(Date.timeIntervalSinceReferenceDate)")
            
            //stop spinning and reload table.(or Section will much better)
            self.spinner.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
}

extension LazyTableViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfSection = tableView.numberOfSections - 1
        let numberOfRows = tableView.numberOfRows(inSection: indexPath.section) - 1
        if indexPath.section == numberOfSection &&
            indexPath.row == numberOfRows{
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//      let isReachingEnd = scrollView.contentOffset.y >= 0
//          && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
//        if isReachingEnd {
//            print("Reached End")
//            retriedData()
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 10.0
        if y > (h + reload_distance) {
            print("load more rows")
             retriedData()
        }
    }
    
}



