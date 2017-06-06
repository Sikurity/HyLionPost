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
    
    let alertController = UIAlertController(title: "저장완료", message: "", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("BoardSettingViewController++")
        
        boardTable.layer.cornerRadius = 20.0
        boardTable.layer.masksToBounds = true
        
        boardTable.delegate = self      /// BoardSettingViewController가 Tableview에서 유저와 상호작용 함수 호출
        boardTable.dataSource = self    /// BoardSettingViewController가 Tableview에서 데이터 관리하는 함수 호출// Create the actions
        
        let okAction = UIAlertAction(title: "확인", style: UIAlertActionStyle.default) {UIAlertAction in return}
        alertController.addAction(okAction)

        // Do any additional setup after loading the view.
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
        
        let cell = tableView.cellForRow(at: indexPath) as! SelectBoardTableViewCell
        cell.boardForCell = appDelegate.dataManager.supportedBoards[groupid]!
        
        if( appDelegate.dataManager.supportedBoards[groupid]?.favorite )!{
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        } else {
            tableView.moveRow(at: indexPath, to: IndexPath(row: favorites.count - 1, section: 0))
        }
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
        for groupid in appDelegate.dataManager.supportedBoards.keys{
            if let board = appDelegate.dataManager.supportedBoards[groupid] {
                if board.favorite {
                    FIRMessaging.messaging().subscribe(toTopic:"/topics/" + board.groupid);
                    print("\(board.groupid) subscribed")
                } else {
                    FIRMessaging.messaging().unsubscribe(fromTopic:"/topics/" + board.groupid);
                    print("\(board.groupid) unsubscribed")
                }
                
                if board.count == -1 {
                    appDelegate.dataManager.getDefaultDataFromFirebase(groupid)
                }
            }
        }
        
        appDelegate.dataManager.save()
        
        self.present(alertController, animated: true, completion: nil)
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
        
        starImageView.image = UIImage(named: board.favorite ? "Star" : "Unstar")
        nameLabel.text = board.name
    }
}
