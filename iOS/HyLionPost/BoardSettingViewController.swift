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
    @IBOutlet
    weak var applyBtn: UIButton!        /// 적용하기(시작하기) 버튼
    
    @IBOutlet
    weak var boardTable: UITableView!   /// 게시판 목록 선택 테이블

    override func viewDidLoad() {
        super.viewDidLoad()
        print("BoardSettingViewController++")
        
        boardTable.layer.cornerRadius = 20.0
        boardTable.layer.masksToBounds = true
        
        boardTable.delegate = self      /// BoardSettingViewController가 Tableview에서 유저와 상호작용 함수 호출
        boardTable.dataSource = self    /// BoardSettingViewController가 Tableview에서 데이터 관리하는 함수 호출

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainTBC = self.tabBarController as! MainTabBarController
        return  mainTBC.supportedBoards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as! SelectBoardTableViewCell
        
        let mainTBC = self.tabBarController as! MainTabBarController
        cell.boardForCell = mainTBC.supportedBoards[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainTBC = self.tabBarController as! MainTabBarController
        mainTBC.supportedBoards[indexPath.row].interest = !mainTBC.supportedBoards[indexPath.row].interest
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as! SelectBoardTableViewCell
        cell.boardForCell = mainTBC.supportedBoards[indexPath.row]
        
        mainTBC.supportedBoards = mainTBC.supportedBoards.sorted(by: {($0.interest ? 1 : 0) >= ($1.interest ? 1 : 0)})
        
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func applySelectedBoards(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            print("Delegated By \(tabBarController)")
            
            let mainTBC = self.tabBarController as! MainTabBarController
            for board in mainTBC.supportedBoards{
                if board.interest {
                    FIRMessaging.messaging().subscribe(toTopic:"/topics/" + board.groupid);
                    print("\(board.groupid) subscribed")
                } else {
                    FIRMessaging.messaging().unsubscribe(fromTopic:"/topics/" + board.groupid);
                    print("\(board.groupid) unsubscribed")
                }
            }
        }
//        else {
//            print("Not Delegated")
//        }
    }
}

class SelectBoardTableViewCell:UITableViewCell {
    @IBOutlet
    weak var starImageView: UIImageView!
    
    @IBOutlet
    weak var nameLabel: UILabel!
    
    var boardForCell:Board? {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        guard let board = boardForCell else {
            return
        }
        
        starImageView.image = UIImage(named: board.interest ? "Star" : "Unstar")
        nameLabel.text = board.name
    }
}
