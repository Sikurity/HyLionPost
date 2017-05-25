//
//  ArticleViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 5..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController{
    var articles:[Article]? = nil

    override func viewDidLoad() {
        
        /// 첫 앱 실행시(=개인설정 아카이브가 없다면) 게시판 선택 화면으로 이동(테스트를 위해 임시로 true)
        let isSettingArchiveExisted = true
        
        if( isSettingArchiveExisted )
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "InitialSettingID") as! InitialSettingViewController
            
            /// completion에 관심 게시판 설정 결과를 아카이브로 저장하고, 서버로부터 관련 최근 게시물들을 요청해 게시물 목록에 추가하는 함수 입력
            self.present(newViewController, animated: true, completion: nil)
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if articles != nil{
//            return articles!.count
//        } else {
//            return 0
//        }
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! AritlceTableViewCell
//        
//        if articles != nil{
//            cell.articleForCell = articles![indexPath.row]
//        }
//        
//        return cell
//    }
}

class AritlceTableViewCell:UITableViewCell {
    //    @IBOutlet weak var profileImageView: UIImageView!
    //    @IBOutlet weak var nameLabel: UILabel!
    //    @IBOutlet weak var quoteLabel: UILabel!
    //    @IBOutlet weak var timeLabel: UILabel!
    
    
    var articleForCell:Article? {
        didSet {
            setUpCell()
        }
    }
    
    
    func setUpCell() {
        guard let article = articleForCell else {
            return
        }
        
        //        nameLabel.text = article.name
        //        quoteLabel.text = article.quote
        //        timeLabel.text = article.time
    }
}
