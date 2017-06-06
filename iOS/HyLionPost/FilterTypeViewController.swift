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
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var beginDatePickerView: UIView!
    @IBOutlet weak var endDatePickerView: UIView!
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var boardTable: UITableView!
    
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    @IBAction func beginDatePickerChanged(_ sender: Any) {
        appDelegate.beginDate = beginDatePicker.date
        beginDateLabel.text = dateFormatter.string(from: beginDatePicker.date)
    }
    @IBAction func endDatePickerChanged(_ sender: Any) {
        appDelegate.endDate = endDatePicker.date
        endDateLabel.text = dateFormatter.string(from: endDatePicker.date)
        beginDatePicker.maximumDate = appDelegate.endDate
        
        appDelegate.beginDate = beginDatePicker.date
        beginDateLabel.text = dateFormatter.string(from: beginDatePicker.date)
    }
    @IBOutlet weak var endDatePickerChanged: UIDatePicker!
    var favorites:[Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FilterTypeViewController++") // FOR DEBU
        
        boardTable.delegate = self
        boardTable.dataSource = self
        
        beginDatePicker.date = appDelegate.beginDate
        endDatePicker.date = appDelegate.endDate
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        beginDateLabel.text = dateFormatter.string(from: beginDatePicker.date)
        endDateLabel.text = dateFormatter.string(from: endDatePicker.date)
        
        endDatePicker.maximumDate = Date()
        beginDatePicker.maximumDate = endDatePicker.maximumDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        beginDatePickerView.isHidden = true
        endDatePickerView.isHidden = true
        
        self.boardTable.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        favorites.removeAll(keepingCapacity: false)
    
        for groupid in appDelegate.dataManager.supportedBoards.keys
        {
            if let board = appDelegate.dataManager.supportedBoards[groupid], board.favorite {
                favorites.append(board)
            }
        }
        
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardPickerCell", for: indexPath)
        
        cell.textLabel?.text = favorites[indexPath.row].name
        cell.accessoryType = favorites[indexPath.row].filtered ? .none : .checkmark
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appDelegate.dataManager.supportedBoards[favorites[indexPath.row].groupid]?.filtered = !favorites[indexPath.row].filtered
        tableView.reloadData()
    }
    
    /// 시작일 View 누를 시 실행되는 Trigger
    @IBAction func beginDateViewClicked(_ sender: Any) {
        UIView.animate(withDuration:0.3, animations: {
            self.beginDatePicker.isHidden = !self.beginDatePicker.isHidden
            self.beginDatePickerView.isHidden =  self.beginDatePicker.isHidden
        })
    }
    
    /// 종료일 View 누를 시 실행되는 Trigger
    @IBAction func endDateViewClicked(_ sender: Any) {
        UIView.animate(withDuration:0.3, animations: {
            self.endDatePicker.isHidden = !self.endDatePicker.isHidden
            self.endDatePickerView.isHidden = self.endDatePicker.isHidden
        })
    }
}
