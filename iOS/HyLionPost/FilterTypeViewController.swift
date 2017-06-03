//
//  FilterTypeViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 27..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class FilterTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favorites:[Board] = []
    
    @IBOutlet weak var datePickerViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var beginDatePickerView: UIView!
    @IBOutlet weak var endDatePickerView: UIView!
    
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet
    weak var boardTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardTable.delegate = self
        boardTable.dataSource = self
        
        print("FilterTypeViewController++")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.tableView.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        favorites = []
    
        for board in appDelegate.dataManager.supportedBoards
        {
            if board.interest {
                favorites.append(board)
            }
        }
        
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardPickerCell", for: indexPath)
        
        cell.accessoryType = .checkmark
        cell.textLabel?.text = favorites[indexPath.row].name
        
        return cell
    }
    
    @IBAction func beginDateViewClicked(_ sender: Any) {
        UIView.animate(withDuration:0.3, animations: {
            self.beginDatePicker.isHidden = !self.beginDatePicker.isHidden
            self.beginDatePickerView.isHidden =  self.beginDatePicker.isHidden
        })
    }
    
    @IBAction func endDateViewClicked(_ sender: Any) {
        UIView.animate(withDuration:0.3, animations: {
            self.endDatePicker.isHidden = !self.endDatePicker.isHidden
            self.endDatePickerView.isHidden = self.endDatePicker.isHidden
        })
    }
}
