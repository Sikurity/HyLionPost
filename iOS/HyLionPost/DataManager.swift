
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
    let defaultDateFormatter = DateFormatter()  // 기본 날짜 포맷
    
    // 앱이 실행될 때, 현재 날짜를 기준으로 한 달 전까지 게시글들만 기본적으로 보여지게 설정
    var beginDate = Calendar.current.date(byAdding: .month, value: -1, to: Date(), wrappingComponents: false)!
    var endDate = Date()
    
    // 서비스가 제공되는 게시판 목록, 만약 변경이 생기면 App 업데이트를 통해 변경해주어야 함
    var supportedBoards:[String:Board] = [:]
    
    var filePath:String{
        get{
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        }
    }
    
    init(){
        defaultDateFormatter.dateFormat = "yy.MM.dd" // 앱에서 기본으로 날짜를 표시할 형식
        print("FILEPATH:" + filePath + "/HyLionPostDatas.archive")
        if FileManager.default.fileExists(atPath: filePath + "/HyLionPostDatas.archive") {    // 이전에 저장된 데이터가 있는 경우 불러오기
            self.supportedBoards = (NSKeyedUnarchiver.unarchiveObject(withFile: self.filePath + "/HyLionPostDatas.archive") as? [String:Board])!
            
            print("UNARCHIVE:")
            print(self.supportedBoards)
        } else {    // 앱을 처음 실행했거나, 데이터가 삭제된 경우 실행 됨
            print("NO ARCHIVE")
            self.supportedBoards = [
                "csnotice":Board(name:"컴퓨터소프트웨어학부 학사일반", groupid:"csnotice", url:"http://cs.hanyang.ac.kr/board/info_board.php", favorite:true, format:"yy.MM.dd"),
                "csck2notice":Board(name:"컴퓨터소프트웨어학부 특성화사업단", groupid:"csck2notice", url:"http://csck2.hanyang.ac.kr/front/community/notice", favorite:false, format:"yyyy-MM-dd"),
                "csgradu":Board(name:"컴퓨터소프트웨어학부 졸업프로젝트", groupid:"csgradu", url:"http://cs.hanyang.ac.kr/board/gradu_board.php", favorite:false, format:"yy.MM.dd"),
                "csjob":Board(name:"컴퓨터소프트웨어학부 취업정보", groupid:"csjob", url:"http://cs.hanyang.ac.kr/board/job_board.php", favorite:false, format:"yy.MM.dd"),
                "csstrk":Board(name:"컴퓨터소프트웨어학부 삼성트랙", groupid:"csstrk", url:"http://cs.hanyang.ac.kr/board/trk_board.php", favorite:false, format:"yy.MM.dd"),
                "demon":Board(name:"컴퓨터소프트웨어학부 테스트", groupid:"demon", url:"http://cs.hanyang.ac.kr/board/stu_board.php", favorite:false, format:"yyyy-MM-dd"),
                "engrnotice":Board(name:"공과대학 공지사항", groupid:"engrnotice", url:"http://cs.hanyang.ac.kr/board/stu_board.php", favorite:false, format:"yyyy.MM.dd"),
            ]
            
            /* TEST CODE BEGIN
            self.supportedBoards["csnotice"]?.articles = ["2232" : Article(title:"2017-1학기 공통기초과학과목 기말시험 일정 안내", groupid:"csnotice", key:"2232", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2017-05-23", archived:false),
                                                                 "1332" : Article(title:"2017-2학기 국가장학금1,2유형 (1차) 신청 안내", groupid:"csnotice", key:"1332", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2017-05-22", archived:false),
                                                                 "65785" : Article(title:"2016-2학기 공통기초과학과목 기말시험 일정 안내", groupid:"csnotice", key:"65785", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2016-11-23", archived:false),
                                                                 "63465" : Article(title:"2017-1학기 국가장학금1,2유형 (1차) 신청 안내", groupid:"csnotice", key:"63465", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2016-11-22", archived:false),
                                                                 "95554" : Article(title:"2017-1학기 교내장학 신청 일정 안내", groupid:"csnotice", key:"95554", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2016-11-21", archived:false)]
            
            self.supportedBoards["csck2notice"]?.articles = ["321" : Article(title:"창의융합교육원 2017학년도 2학기 교양교육 설명회 안내", groupid:"csck2notice", key:"321", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2017-05-24", archived:true)]
            
            self.supportedBoards["csgradu"]?.articles = [
                "83456" : Article(title:"2016학년도 2학기 지도교수 간담회 결과 보고", groupid:"csgradu", key:"83456", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2016-11-20", archived:false),
                "10345" : Article(title:"2016학년도 1학기 지도교수 간담회 결과 보고", groupid:"csgradu", key:"10345", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2016-05-20", archived:false),
                "3523" : Article(title:"2017학년도 1학기 지도교수 간담회 결과 보고", groupid:"csgradu", key:"3523", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2017-05-20", archived:true)]
            
            self.supportedBoards["csjob"]?.articles = [:]
            
            self.supportedBoards["csstrk"]?.articles = [
                "4456" : Article(title:"삼성전자 SCSC 2017학년도 2학기 설명회 안내", groupid:"csstrk", key:"4456", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2017-05-24", archived:false)]
            
            self.supportedBoards["demon"]?.articles = [
                "1232" : Article(title:"2017-2학기 교내장학 신청 일정 안내", groupid:"demon", key:"1232", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2017-05-21", archived:false),
                "7564" : Article(title:"2017-1학기 교내장학 신청 일정 안내", groupid:"demon", key:"7564", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"2017-11-21", archived:true)]
            TEST CODE END */
        }
    }
    
    /// AppIcon badge에 표시될 값을 계산
    func calculateAllNewsCount() -> Int {
        var newsCount = 0
        
        for board in supportedBoards.values {
            if board.favorite
            {
                for article in board.articles.values{
                    if article.unopened{
                        newsCount += 1
                    }
                }
            }
        }
        
        return newsCount
    }
    
    /// 탭1, 탭2 badge에 표시될 읽지 않은 게시글 개수 계산
    func calculateAllNewsCount(filtered:Bool) -> Int {
        var newsCount = 0
        
        for board in supportedBoards.values {
            if board.favorite {
                for article in board.articles.values{
                    if ((board.filtered || !self.filterByDate(article)) == filtered) && article.unopened{
                        newsCount += 1
                    }
                }
            }
        }
        
        return newsCount
    }
    
    /// 탭2 게시판 별 필터링 되어 보이지 않고 읽지 않은 게시글 개수 계산
    func calculateNewsCount(at groupid:String) -> Int {
        var newsCount = 0
        
        if let board = supportedBoards[groupid] {
            if board.favorite {
                for article in board.articles.values{
                    if (board.filtered || !self.filterByDate(article)) && article.unopened{
                        newsCount += 1
                    }
                }
            }
        }
        
        return newsCount
    }
    
    /// 날짜 필터, 게시글 마다 날짜 형식이 다르므로 Date 형으로 복원하여 비교
    func filterByDate(_ article:Article) -> Bool{
        let dateFormatter = DateFormatter()
        
        guard let format = supportedBoards[article.groupid]?.format else {
            return false
        }
        
        dateFormatter.dateFormat = format
        
        let beginDate = dateFormatter.string(from: self.beginDate)
        let endDate = dateFormatter.string(from: self.endDate)
        
        return beginDate <= article.date && article.date <= endDate
    }
    
    /// 입력된 날짜를 앱 기본 날짜 표현 형식으로 변환
    func convertDateToDefaultFormat(from:String, format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        guard let date = dateFormatter.date(from: from) else {
            return "00.00.00"
        }
        
        return defaultDateFormatter.string(from: date)
    }
    
    /// 현재 데이터 저장
    func save(){
        print("ARCHIVE:" + self.filePath + "/HyLionPostDatas.archive")
        
        for board in supportedBoards.values {
            if board.favorite {
                supportedBoards[board.groupid]?.count = board.articles.count
            }
        }
        
        NSKeyedArchiver.archiveRootObject(self.supportedBoards, toFile: self.filePath + "/HyLionPostDatas.archive")
    }
}
