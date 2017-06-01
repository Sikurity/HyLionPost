//
//  ArticleViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 5..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ArticleTableViewController: UITableViewController{
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainTBC = self.tabBarController as! MainTabBarController
        if let news = mainTBC.articles{
            return news.count
        } else {
            return 0
        }
    }
    
    /// right-to-left / left-to-right swipe 시 숨겨진 버튼이 나오는 기능 구현 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! AritlceTableViewCell
        
        let mainTBC = self.tabBarController as! MainTabBarController
        if let news = mainTBC.articles {
            cell.articleForCell = news[indexPath.row]
            cell.setUpBoardName(getBoardName(news[indexPath.row].groupid))
            
            //configure left buttons
            let flagImg = resizeImage(image:UIImage(named:(news[indexPath.row].favorite ? "Unstar" : "Star")), newWidth:tableView.rowHeight / 2)
            
            cell.leftButtons = [MGSwipeButton(title: "", icon: flagImg, backgroundColor:(news[indexPath.row].favorite ? UIColor.lightGray : UIColor.yellow)){
                (sender: MGSwipeTableCell!) -> Bool in
                    news[indexPath.row].favorite = !news[indexPath.row].favorite
                    print("Changed \(!news[indexPath.row].favorite) -> \(news[indexPath.row].favorite)")
                    self.tableView.reloadData()
                    return true
                }]
            cell.leftSwipeSettings.transition = MGSwipeTransition.rotate3D
            
            //configure right buttons
            let trashcanImg = resizeImage(image:UIImage(named:"Trashcan"), newWidth:tableView.rowHeight / 2)
            
            cell.rightButtons = [MGSwipeButton(title: "", icon: trashcanImg, backgroundColor: UIColor.red){
                (sender: MGSwipeTableCell!) -> Bool in
                    print("\(news[indexPath.row].title) Removed")
                    //mainTBC.articles?.remove(???) /// groupid, key 값으로 찾아서 삭제
                    return true
                }]
            cell.rightSwipeSettings.transition = MGSwipeTransition.rotate3D
        }
        
        return cell
    }
    
    /// 마지막 게시글이 탭바에 가려져 선택하기 힘든 것을 해결하기 위해 탭바 높이 만큼의 Footer를 추가
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.tabBarController!.tabBar.frame.height
    }
    
    /// 마지막 게시글이 탭바에 가려져 선택하기 힘든 것을 해결하기 위해 빈 탭바 추가
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }
    
    /// 이미지 크기를 테이블 크기에 맞게 변경하기 위해 작성
    func resizeImage(image: UIImage?, newWidth: CGFloat) -> UIImage? {
        var retImage:UIImage? = image
        
        if let newImg = image {
            let scale = newWidth / newImg.size.width
            let newHeight = newImg.size.height * scale
            
            let newSize = CGSize(width:newWidth, height:newHeight)
            UIGraphicsBeginImageContext(newSize)
            newImg.draw(in: CGRect(origin:CGPoint(), size:newSize))
            
            retImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return retImage
    }
    
    /// 게시글의 groupid를 이용해 소속 게시판 이름을 얻어냄
    func getBoardName(_ groupid:String) -> String
    {
        let mainTBC = self.tabBarController as! MainTabBarController
    
        for board in mainTBC.supportedBoards{
            if board.groupid == groupid{
                return board.name
            }
        }
        
        return "unknown"
    }
}

class AritlceTableViewCell:MGSwipeTableCell {
    @IBOutlet weak var boardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var articleForCell:Article? {
        didSet {
            setUpCell()
        }
    }
    
    func setUpBoardName(_ boardName:String){
        boardLabel.text = boardName
    }
    
    func setUpCell() {
        guard let article = articleForCell else {
            return
        }
        
        dateLabel.text = article.date
        titleLabel.text = article.title
    }
}
