//
//  ArticleViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 5..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    @IBOutlet weak var articleTable: UITableView!
    @IBOutlet weak var filterSeg: UISegmentedControl!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var searchBarController:UISearchController = UISearchController(searchResultsController: nil)
    
    var filteredData:[Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ArticleViewController viewDidLoad")
        
        self.articleTable.delegate = self
        self.articleTable.dataSource = self
        
        searchBarController.searchResultsUpdater = self
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.hidesNavigationBarDuringPresentation = false
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.barStyle = UIBarStyle.black
        searchBarController.searchBar.barTintColor = UIColor.white
        searchBarController.searchBar.backgroundColor = UIColor.clear
        
        self.articleTable.tableHeaderView = searchBarController.searchBar
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("ArticleViewController viewWillAppear")
        super.viewWillAppear(animated)
        
        /// @TODO 2번째 탭에서 설정된 필터링된 결과로 변경
        filteredData = appDelegate.dataManager.articles
        
        self.articleTable.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    /// right-to-left / left-to-right swipe 시 숨겨진 버튼이 나오는 기능 구현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! AritlceTableViewCell
        
        cell.articleForCell = filteredData[indexPath.row]
        cell.setUpBoardName(getBoardName(filteredData[indexPath.row].groupid))
        
        //configure left buttons
        let flagImg = resizeImage(image:UIImage(named:(filteredData[indexPath.row].favorite ? "Unstar" : "Star")), newWidth:tableView.rowHeight / 2)
        
        cell.leftButtons = [MGSwipeButton(title: "", icon: flagImg, backgroundColor:(filteredData[indexPath.row].favorite ? UIColor.lightGray : UIColor.yellow)){
            (sender: MGSwipeTableCell!) -> Bool in
            var cell = sender as! AritlceTableViewCell
            
            self.filteredData[indexPath.row].favorite = !self.filteredData[indexPath.row].favorite
            print("Changed \(!self.filteredData[indexPath.row].favorite) -> \(self.filteredData[indexPath.row].favorite)")
            // self.tableView.reloadData()
            return true
            }]
        cell.leftSwipeSettings.transition = MGSwipeTransition.rotate3D
        
        cell.rightButtons = [MGSwipeButton(title: "Delete", icon: nil, backgroundColor: UIColor.red){
            (sender: MGSwipeTableCell!) -> Bool in
            var cell = sender as! AritlceTableViewCell
            
            print("\(self.filteredData[indexPath.row].title) Removed")
            //mainTBC.articles?.remove(???) /// groupid, key 값으로 찾아서 삭제
            return true
            }]
        cell.rightSwipeSettings.transition = MGSwipeTransition.rotate3D
        
        return cell
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webViewSegue" {
            if let webVC = segue.destination as? WebViewController {
                if let selectedIndex = self.articleTable.indexPathForSelectedRow?.row {
                    webVC.link = appDelegate.dataManager.articles[selectedIndex].url
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredData.removeAll(keepingCapacity: false)
        
        if searchBarController.isActive {
            if let keyword = searchBarController.searchBar.text, keyword != "" {
                filteredData = appDelegate.dataManager.articles.filter({$0.title.range(of:keyword) != nil})
            } else {
                filteredData = appDelegate.dataManager.articles
            }
        } else {
            filteredData = appDelegate.dataManager.articles
        }
        
        self.articleTable.reloadData()
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
        for board in appDelegate.dataManager.supportedBoards{
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
    
    var grouid:String = ""
    var key:String = ""
    
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
        
        self.grouid = article.groupid
        self.key = article.key
    }
}
