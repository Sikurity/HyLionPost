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
    
    @IBOutlet weak var boardTable: UITableView!     /// 게시판 목록 선택 테이블
    
    var favorites:[Board] = []                      /// 테이블에 추가될 목록

    override func viewDidLoad() {
        super.viewDidLoad()
        print("BoardSettingViewController++")
        
        boardTable.layer.cornerRadius = 20.0    // 로고 이미지 둥근 모서리 반경
        boardTable.layer.masksToBounds = true   // 로고 이미지 둥근 모서리 추가
        
        boardTable.delegate = self      // BoardSettingViewController가 Tableview에서 유저와 상호작용 함수 호출
        boardTable.dataSource = self    // BoardSettingViewController가 Tableview에서 데이터 관리하는 함수 호출
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
        
        // 서비스가 제공되는 게시판들을 모두 추가
        for board in appDelegate.dataManager.supportedBoards.values{
            favorites.append(board)
        }
        
        // 구독중인 게시판 들을 위쪽에 배치
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
        
        // 셀을 선택하면 구독 중이던 게시판은 구독 해제, 구독 중이지 않던 게시판은 구독
        appDelegate.dataManager.supportedBoards[groupid]?.favorite = !favorites[indexPath.row].favorite
        
        if let board = appDelegate.dataManager.supportedBoards[groupid] {
            if board.favorite {
                FIRMessaging.messaging().subscribe(toTopic:"/topics/" + board.groupid)      // 구독
                print("\(board.groupid) subscribed")
            } else {
                FIRMessaging.messaging().unsubscribe(fromTopic:"/topics/" + board.groupid)  // 해지
                print("\(board.groupid) unsubscribed")
            }
            
            print("\(board.favorite) \(board.count)")
            if board.favorite && board.count == -1 {
                appDelegate.getDefaultDataFromFirebase(where: groupid)  // 처음 구독하게 되는 경우, 해당 게시판의 최근 데이터 10개를 갖고 옴
            }
            
            appDelegate.dataManager.save()  // 저장
            
            self.appDelegate.updateBoardTable()     // 게시판 필터링 Badge 갱신
            self.appDelegate.updateBadgeCount()     // Badge Count 갱신
            
            let cell = tableView.cellForRow(at: indexPath) as! SelectBoardTableViewCell
            cell.boardForCell = board
            
            if( board.favorite ){   // 구독하게 된 게시판은 가장 위로 이동시킴
                tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
            } else {                // 구독해제 한 게시판은 가장 아래로 이동시킴
                tableView.moveRow(at: indexPath, to: IndexPath(row: favorites.count - 1, section: 0))
            }
            
            /// 보이는 내용과 내부 데이터 사이의 싱크 맞추기
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
