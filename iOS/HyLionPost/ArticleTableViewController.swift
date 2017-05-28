//
//  ArticleViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 5..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController{
    var articles:[Article]? = [
        Article(title:"창의융합교육원 2017학년도 2학기 교양교육 설명회 안내", group:"컴퓨터소프트웨어학부 특성화사업단 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.24", favorite:false),
        Article(title:"2017-1학기 공통기초과학과목 기말시험 일정 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.23", favorite:false),
        Article(title:"2017-2학기 국가장학금1,2유형 (1차) 신청 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.22", favorite:false),
        Article(title:"2017-2학기 교내장학 신청 일정 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.21", favorite:false),
        Article(title:"2017학년도 1학기 지도교수 간담회 결과 보고", group:"컴퓨터소프트웨어학부 졸업프로젝트 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.20", favorite:false),
        Article(title:"창의융합교육원 2017학년도 2학기 교양교육 설명회 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.24", favorite:false),
        Article(title:"2017-1학기 공통기초과학과목 기말시험 일정 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.23", favorite:false),
        Article(title:"2017-2학기 국가장학금1,2유형 (1차) 신청 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.22", favorite:false),
        Article(title:"2017-2학기 교내장학 신청 일정 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.21", favorite:false),
        Article(title:"2017학년도 1학기 지도교수 간담회 결과 보고", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.20", favorite:false),
        Article(title:"2017-2학기 교내장학 신청 일정 안내", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.21", favorite:false),
        Article(title:"2017학년도 1학기 지도교수 간담회 결과 보고", group:"컴퓨터소프트웨어학부 학사일반 게시판", url:"http://cs.hanyang.ac.kr/board/info_board.php", date:"17.05.20", favorite:false),
        ]

    override func viewDidLoad() {
        
        /// 첫 앱 실행시(=개인설정 아카이브가 없다면) 게시판 선택 화면으로 이동(테스트를 위해 임시로 true)
        
        super.viewDidLoad()
        print("ArticleTableViewController++")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
//        let account = accountTypes[indexPath.section].accounts[indexPath.row]
        
        let test1 = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "TEST1", handler: { (action, indexPath) -> Void in
            // action delete
        })
        
        let test2 = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "TEST2", handler: { (action, indexPath) -> Void in
            // action activate
        })
        
        test2.backgroundColor = UIColor.lightGray
        
        let arrayofactions: Array = [test1, test2]
        
        return arrayofactions
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let news = articles{
            return news.count
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! AritlceTableViewCell
        
        if articles != nil{
            cell.articleForCell = articles![indexPath.row]
        }
        
        return cell
    }
}

class AritlceTableViewCell:UITableViewCell {
    @IBOutlet weak var boardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var articleForCell:Article? {
        didSet {
            setUpCell()
        }
    }
    
    
    func setUpCell() {
        guard let article = articleForCell else {
            return
        }
        
        boardLabel.text = article.group
        dateLabel.text = article.date
        titleLabel.text = article.title
    }
}
