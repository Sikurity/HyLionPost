//
//  InitialSettingViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 19..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class InitialSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet
    weak var boardTable: UITableView!   /// 게시판 목록 선택 테이블
    
    /**
     *  @author 
     *      이영식
     *  @date
     *      17` 05. 19
     *  @brief
     *      지원하는 게시판 목록, 만약 변경이 생기면 어플리케이션 업데이트(패치)를 통해 반영해주어야 함
     *  @discussion
     *       게시판 번호(groupid)는 현재 임시로 지정해 둔 상태
     */
    let selectableBoards:[Board] = [
        Board(name:"컴퓨터공학부 특성화사업단 게시판", groupid:"0", url:"http://csck2.hanyang.ac.kr/front/community/notice", interested:false),
        Board(name:"컴퓨터공학부 졸업프로젝트 게시판", groupid:"1", url:"http://cs.hanyang.ac.kr/board/gradu_board.php", interested:false),
        Board(name:"컴퓨터공학부 취업정보 게시판", groupid:"2", url:"http://cs.hanyang.ac.kr/board/job_board.php", interested:false),
        Board(name:"컴퓨터공학부 학사일반 게시판", groupid:"3", url:"http://cs.hanyang.ac.kr/board/info_board.php", interested:true),
        Board(name:"컴퓨터공학부 삼성트랙 게시판", groupid:"4", url:"http://cs.hanyang.ac.kr/board/trk_board.php", interested:true),
        Board(name:"컴퓨터공학부 학생 게시판", groupid:"5", url:"http://cs.hanyang.ac.kr/board/stu_board.php", interested:true),
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardTable.delegate = self      /// InitialSettingViewController가 Tableview에서 유저와 상호작용 함수 호출
        boardTable.dataSource = self    /// InitialSettingViewController가 Tableview에서 데이터 관리하는 함수 호출

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
        return selectableBoards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BoardCell", for: indexPath) as! SelectBoardTableViewCell
        
        cell.boardForCell = selectableBoards[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell selected code here
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
        
        starImageView.image = UIImage(named: board.interested ? "Star" : "Unstar")
        nameLabel.text = board.name
    }
}
