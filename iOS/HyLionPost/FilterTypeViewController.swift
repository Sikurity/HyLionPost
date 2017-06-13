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
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var beginDatePickerView: UIView!
    @IBOutlet weak var endDatePickerView: UIView!
    
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var boardTable: UITableView!
    
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    /// 시작일 변경 시 필터 적용
    @IBAction func beginDatePickerChanged(_ sender: Any) {
        appDelegate.dataManager.beginDate = beginDatePicker.date
        beginDateLabel.text = dateFormatter.string(from: beginDatePicker.date)
        
        self.boardTable.reloadData()
        
        appDelegate.updateBadgeCount()
    }
    
    /// 종료일 변경 시 필터 적용
    @IBAction func endDatePickerChanged(_ sender: Any) {
        appDelegate.dataManager.endDate = endDatePicker.date
        endDateLabel.text = dateFormatter.string(from: endDatePicker.date)
        beginDatePicker.maximumDate = appDelegate.dataManager.endDate
        
        // 시작일이 종료일을 넘을 수 없도록 강제
        self.beginDatePickerChanged(sender)
    }
    
    /// 테이블에 표시할 게시판 목록
    var favorites:[Board] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FilterTypeViewController++") // FOR DEBUG
        
        boardTable.delegate = self
        boardTable.dataSource = self
        
        beginDatePicker.date = appDelegate.dataManager.beginDate
        endDatePicker.date = appDelegate.dataManager.endDate
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"  // 날짜를 표시할 포맷
        
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
        
        // date picker가 접혀있도록 강제
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardPickerCell", for: indexPath) as! BoardFilterTableViewCell
        
        // didSet을 이용한 cell 변경
        cell.boardForCell = favorites[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 게시판 필터링 적용/해제
        appDelegate.dataManager.supportedBoards[favorites[indexPath.row].groupid]?.filtered = !favorites[indexPath.row].filtered
        tableView.reloadData()
        
        self.appDelegate.dataManager.save()
        
        self.appDelegate.updateBadgeCount()
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
        // 시작일 date picker 보이기/숨기기
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
            // 종료일 date picker 보이기/숨기기
            self.endDatePickerView.isHidden = !self.endDatePickerView.isHidden
            if( self.endDatePickerView.isHidden ) {
                self.endDatePickerViewHeightConstraint.constant = 0
            } else {
                self.endDatePickerViewHeightConstraint.constant = self.stackView.frame.height * 0.2
            }
        })
    }
}

class BoardFilterTableViewCell:UITableViewCell {
    @IBOutlet weak var isFilteredImageView: UIImageView!
    @IBOutlet weak var boardNameLabel: UILabel!
    @IBOutlet weak var unopenedCountLabel: UILabel!
    
    var groupid:String = ""
    var key:String = ""
    
    var boardForCell:Board? {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        guard let board = boardForCell else {
            return
        }
        
        // 필터 안된 경우 [Checkmark], 필터 된 경우 이미지 없음
        isFilteredImageView.image = board.filtered ? nil : UIImage(named: "Checkmark")!
        boardNameLabel.text = board.name
        
        let newsCount = appDelegate.dataManager.calculateNewsCount(at: board.groupid)
        unopenedCountLabel.text = newsCount > 0 ? "\(newsCount)" : ""   // 0개인 경우 표시 안함
    }
}
