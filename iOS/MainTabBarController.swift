//
//  MainTabBarController.swift
//  
//
//  Created by YeongsikLee on 2017. 5. 27..
//
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{
    /**
     *  @author
     *      이영식
     *  @date
     *      17` 05. 29
     *  @brief
     *      서비스가 제공되는 게시판 목록, 만약 변경이 생기면 App 업데이트를 통해 변경해주어야 함
     */
    var supportedBoards:[Board] = [
        Board(name:"컴퓨터소프트웨어학부 특성화사업단 게시판", groupid:"csck2notice", url:"http://csck2.hanyang.ac.kr/front/community/notice", interest:false),
        Board(name:"컴퓨터소프트웨어학부 졸업프로젝트 게시판", groupid:"csgradu", url:"http://cs.hanyang.ac.kr/board/gradu_board.php", interest:false),
        Board(name:"컴퓨터소프트웨어학부 취업정보 게시판", groupid:"csjob", url:"http://cs.hanyang.ac.kr/board/job_board.php", interest:false),
        Board(name:"컴퓨터소프트웨어학부 학사일반 게시판", groupid:"csnotice", url:"http://cs.hanyang.ac.kr/board/info_board.php", interest:false),
        Board(name:"컴퓨터소프트웨어학부 삼성트랙 게시판", groupid:"csstrk", url:"http://cs.hanyang.ac.kr/board/trk_board.php", interest:false),
        Board(name:"컴퓨터소프트웨어학부 학생 게시판", groupid:"csstu", url:"http://cs.hanyang.ac.kr/board/stu_board.php", interest:false),
        ]
    
    /**
     *  @author
     *      이영식
     *  @date
     *      17` 05. 29
     *  @brief
     *      보유 중인 공지, 게시글 모음
     */
    var articles:[Article]? = [
        Article(title:"창의융합교육원 2017학년도 2학기 교양교육 설명회 안내", groupid:"csck2notice", key:"321", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.24", favorite:true),
        Article(title:"2017-1학기 공통기초과학과목 기말시험 일정 안내", groupid:"csnotice", key:"2232", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.23", favorite:false),
        Article(title:"2017-2학기 국가장학금1,2유형 (1차) 신청 안내", groupid:"csnotice", key:"1332", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.22", favorite:false),
        Article(title:"2017-2학기 교내장학 신청 일정 안내", groupid:"csstu", key:"1232", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.21", favorite:false),
        Article(title:"2017학년도 1학기 지도교수 간담회 결과 보고", groupid:"csgradu", key:"3523", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.20", favorite:true),
        Article(title:"삼성전자 SCSC 2017학년도 2학기 설명회 안내", groupid:"csstrk", key:"4456", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.24", favorite:false),
        Article(title:"2017-1학기 공통기초과학과목 기말시험 일정 안내", groupid:"csnotice", key:"65785", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.23", favorite:false),
        Article(title:"2017-2학기 국가장학금1,2유형 (1차) 신청 안내", groupid:"csnotice", key:"63465", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.22", favorite:false),
        Article(title:"2017-1학기 교내장학 신청 일정 안내", groupid:"csstu", key:"7564", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.21", favorite:true),
        Article(title:"2016학년도 2학기 지도교수 간담회 결과 보고", groupid:"csgradu", key:"834566", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.20", favorite:false),
        Article(title:"2017-1학기 교내장학 신청 일정 안내", groupid:"csnotice", key:"95554", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.21", favorite:false),
        Article(title:"2016학년도 1학기 지도교수 간담회 결과 보고", groupid:"csgradu", key:"10345", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.20", favorite:false),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
        print("MainTabBar viewDidLoad")
        
        let fileMgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0] as NSString
        let dataFilePath:String? = docsDir.appendingPathComponent("boards.archive")
        
        if let path = dataFilePath {
            if( fileMgr.fileExists(atPath: path) == false )
            {
                self.selectedIndex = 2
                print("파일 없음 : \(self.selectedIndex)")
            }
            else
            {
                print("파일 있음")
            }
        }
        else{
            print("경로 문자열 이상")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        if let title = viewController.title{
            print("Title is \(title)")
            switch(title)
            {
            case "Articles":
                let articleTVC = viewController as! ArticleTableViewController
                //articleTVC.articles
                break
                
            case "Favorites":
                break
                
            case "Boards":
                break
                
            default:
                break
            }
        } else {
            print("Title is nil")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
