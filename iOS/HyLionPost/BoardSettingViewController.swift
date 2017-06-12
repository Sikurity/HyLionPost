//
//  BoardSettingViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 19..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit
import FirebaseMessaging

class BoardSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var boardTable: UITableView!   /// 게시판 목록 선택 테이블
    
    var favorites:[Board] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("BoardSettingViewController++")
        
        boardTable.layer.cornerRadius = 20.0
        boardTable.layer.masksToBounds = true
        
        boardTable.delegate = self      /// BoardSettingViewController가 Tableview에서 유저와 상호작용 함수 호출
        boardTable.dataSource = self    /// BoardSettingViewController가 Tableview에서 데이터 관리하는 함수 호출
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.removeAll(keepingCapacity: false)
        
        for groupid in appDelegate.dataManager.supportedBoards.keys{
            if let board = appDelegate.dataManager.supportedBoards[groupid]{
                favorites.append(board)
            }
        }
        
        favorites.sort(by: {($0.favorite ? 1 : 0) > ($1.favorite ? 1 : 0)})
        
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as! SelectBoardTableViewCell
        
        cell.boardForCell = favorites[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let groupid = favorites[indexPath.row].groupid
        appDelegate.dataManager.supportedBoards[groupid]?.favorite = !favorites[indexPath.row].favorite
        
        if let board = appDelegate.dataManager.supportedBoards[groupid] {
            if board.favorite {
                FIRMessaging.messaging().subscribe(toTopic:"/topics/" + board.groupid);
                print("\(board.groupid) subscribed")
            } else {
                FIRMessaging.messaging().unsubscribe(fromTopic:"/topics/" + board.groupid);
                print("\(board.groupid) unsubscribed")
            }
            
            print("\(board.favorite) \(board.count)")
            if board.favorite && board.count == -1 {
                appDelegate.getDefaultDataFromFirebase(where: groupid)
            }
            
            appDelegate.dataManager.save()
            
            self.appDelegate.updateArticleTable()
            self.appDelegate.updateBoardTable()
            self.appDelegate.updateBadgeCount()
            
            let cell = tableView.cellForRow(at: indexPath) as! SelectBoardTableViewCell
            cell.boardForCell = board
            
            if( board.favorite ){
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            } else {
                tableView.moveRow(at: indexPath, to: IndexPath(row: favorites.count - 1, section: 0))
            }
            
            for i in 0..<favorites.count {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SelectBoardTableViewCell,
                    let board = appDelegate.dataManager.supportedBoards[cell.groupId] {
                    favorites[i] = board
                } else {
                    favorites[i] = Board(name: "UNDEFINED", groupid: "", url: "about:blank", favorite: false, format: "yy.MM.dd")
                }
            }
        }
    }
}

class SelectBoardTableViewCell:UITableViewCell {
    @IBOutlet
    weak var starImageView: UIImageView!
    
    @IBOutlet
    weak var nameLabel: UILabel!
    
    var groupId:String = ""
    
    var boardForCell:Board? {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        guard let board = boardForCell else {
            return
        }
        
        self.groupId = board.groupid
        
        starImageView.image = UIImage(named: board.favorite ? "Star" : "Unstar")
        nameLabel.text = board.name
    }
}
