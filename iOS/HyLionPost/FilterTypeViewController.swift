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
    
    @IBAction func TEST(_ sender: Any) {
        appDelegate.dataManager.test()
    }
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var beginDatePickerView: UIView!
    @IBOutlet weak var endDatePickerView: UIView!
    
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var boardTable: UITableView!
    
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBAction func beginDatePickerChanged(_ sender: Any) {
        appDelegate.dataManager.beginDate = beginDatePicker.date
        beginDateLabel.text = dateFormatter.string(from: beginDatePicker.date)
    }
    @IBAction func endDatePickerChanged(_ sender: Any) {
        appDelegate.dataManager.endDate = endDatePicker.date
        endDateLabel.text = dateFormatter.string(from: endDatePicker.date)
        beginDatePicker.maximumDate = appDelegate.dataManager.endDate
        
        appDelegate.dataManager.beginDate = beginDatePicker.date
        beginDateLabel.text = dateFormatter.string(from: beginDatePicker.date)
    }
    @IBOutlet weak var endDatePickerChanged: UIDatePicker!
    var favorites:[Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FilterTypeViewController++") // FOR DEBU
        
        boardTable.delegate = self
        boardTable.dataSource = self
        
        beginDatePicker.date = appDelegate.dataManager.beginDate
        endDatePicker.date = appDelegate.dataManager.endDate
        
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
        
        beginDatePickerViewHeightConstraint.constant = 0
        beginDatePickerView.isHidden = true
        
        endDatePickerViewHeightConstraint.constant = 0
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "게시판 필터링"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.stackView.frame.height * 0.05
    }
    
    @IBOutlet weak var beginDatePickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var endDatePickerViewHeightConstraint: NSLayoutConstraint!
    /// 시작일 View 누를 시 실행되는 Trigger
    @IBAction func beginDateViewClicked(_ sender: Any) {

        UIView.animate (withDuration:0.5, animations: {
            self.beginDatePickerView.isHidden = !self.beginDatePickerView.isHidden
            if( self.beginDatePickerView.isHidden ) {
                self.beginDatePickerViewHeightConstraint.constant = 0
            } else {
                self.beginDatePickerViewHeightConstraint.constant = self.stackView.frame.height * 0.2
            }
        })
    }
    
    /// 종료일 View 누를 시 실행되는 Trigger
    @IBAction func endDateViewClicked(_ sender: Any) {
        UIView.animate(withDuration:0.5, animations: {
            self.endDatePickerView.isHidden = !self.endDatePickerView.isHidden
            if( self.endDatePickerView.isHidden ) {
                self.endDatePickerViewHeightConstraint.constant = 0
            } else {
                self.endDatePickerViewHeightConstraint.constant = self.stackView.frame.height * 0.2
            }
        })
    }
}
