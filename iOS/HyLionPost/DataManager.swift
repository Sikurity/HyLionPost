
//  DataManager.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 6. 2..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import Foundation
import Firebase
import FirebaseInstanceID

class DataManager{
    ///서비스가 제공되는 목록, 만약 변경이 생기면 App 업데이트를 통해 변경해주어야 함
    var beginDate = Calendar.current.date(byAdding: .month, value: -1, to: Date(), wrappingComponents: false)!
    var endDate = Date()
    var supportedBoards:[String:Board] = [:]
    var filePath:String{
        get{
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        }
    }
    
    var ref:FIRDatabaseReference!
    
    init(){
        print("FILEPATH:" + filePath + "/HyLionPostDatas.archive")
        if FileManager.default.fileExists(atPath: filePath + "/HyLionPostDatas.archive") // == false
        {
            self.supportedBoards = (NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath + "/HyLionPostDatas.archive") as? [String:Board])!
            
            print("UNARCHIVE:")
            print(self.supportedBoards)
        } else {
            print("NO ARCHIVE")
            self.supportedBoards = [
                "csnotice":Board(name:"컴퓨터소프트웨어학부 학사일반", groupid:"csnotice", url:"http://cs.hanyang.ac.kr/board/info_board.php", favorite:true),
                "csck2notice":Board(name:"컴퓨터소프트웨어학부 특성화사업단", groupid:"csck2notice", url:"http://csck2.hanyang.ac.kr/front/community/notice", favorite:false),
                "csgradu":Board(name:"컴퓨터소프트웨어학부 졸업프로젝트", groupid:"csgradu", url:"http://cs.hanyang.ac.kr/board/gradu_board.php", favorite:false),
                "csjob":Board(name:"컴퓨터소프트웨어학부 취업정보", groupid:"csjob", url:"http://cs.hanyang.ac.kr/board/job_board.php", favorite:false),
                "csstrk":Board(name:"컴퓨터소프트웨어학부 삼성트랙", groupid:"csstrk", url:"http://cs.hanyang.ac.kr/board/trk_board.php", favorite:false),
                "demon":Board(name:"컴퓨터소프트웨어학부 테스트", groupid:"demon", url:"http://cs.hanyang.ac.kr/board/stu_board.php", favorite:false),
            ]
            
            getDefaultDataFromFirebase("csnotice")
        }
    }
    
    func getDefaultDataFromFirebase(_ groupid:String){
        
        if( supportedBoards[groupid]?.count == -1 )
        {
            // test()
        }
    }
    
    /// @TEST
    func test(){
        ref.child("board_datas").child("demon").observeSingleEvent (of:.value, with: { (snapshot) in
            print("snapshot!!")
            print(snapshot)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func save(){
        print("ARCHIVE:" + self.filePath + "/HyLionPostDatas.archive")
        print(self.supportedBoards)
        NSKeyedArchiver.archiveRootObject(self.supportedBoards, toFile: self.filePath + "/HyLionPostDatas.archive")
    }
}
