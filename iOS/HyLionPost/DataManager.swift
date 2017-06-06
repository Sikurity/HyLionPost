//
//  DataManager.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 6. 2..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import Foundation

class DataManager{
    ///서비스가 제공되는 게시판 목록, 만약 변경이 생기면 App 업데이트를 통해 변경해주어야 함
    var supportedBoards:[String:Board] = [:]
    var filePath:String{
        get{
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        }
    }
    
    init(){
        if FileManager.default.fileExists(atPath: filePath + "HyLionPostDatas.archive")
        {
            self.supportedBoards = (NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath+"HyLionPostDatas.archive") as? [String:Board])!
        } else {
            self.supportedBoards = [
                "csnotice":Board(name:"컴퓨터소프트웨어학부 학사일반 게시판", groupid:"csnotice", url:"http://cs.hanyang.ac.kr/board/info_board.php", favorite:true),
                "csck2notice":Board(name:"컴퓨터소프트웨어학부 특성화사업단 게시판", groupid:"csck2notice", url:"http://csck2.hanyang.ac.kr/front/community/notice", favorite:false),
                "csgradu":Board(name:"컴퓨터소프트웨어학부 졸업프로젝트 게시판", groupid:"csgradu", url:"http://cs.hanyang.ac.kr/board/gradu_board.php", favorite:false),
                "csjob":Board(name:"컴퓨터소프트웨어학부 취업정보 게시판", groupid:"csjob", url:"http://cs.hanyang.ac.kr/board/job_board.php", favorite:false),
                "csstrk":Board(name:"컴퓨터소프트웨어학부 삼성트랙 게시판", groupid:"csstrk", url:"http://cs.hanyang.ac.kr/board/trk_board.php", favorite:false),
                "csstu":Board(name:"컴퓨터소프트웨어학부 학생 게시판", groupid:"csstu", url:"http://cs.hanyang.ac.kr/board/stu_board.php", favorite:false),
            ]
            
            getDefaultDataFromFirebase("csnotice")
        }
    }
    
    func getDefaultDataFromFirebase(_ groupid:String){
        
        if( supportedBoards[groupid]?.count == -1 )
        {
            // @TODO Firebase로 부터 최근 게시물 10개 요청
            // supportedBoards[groupid].articles = %GET_DEFAULT_ARTICLES_FROM_FIREBASE_DB%
            // supportedBoards[groupid].count = supportedBoards[groupid].articles.count
        }
    }
    
    func save(){
        NSKeyedArchiver.archiveRootObject(self.supportedBoards, toFile: filePath + "HyLionPostDatas.archive")
    }
}
