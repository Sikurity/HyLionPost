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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet weak var articleTable: UITableView!
    
    @IBAction func switchChanged(_ sender: Any) {
        showFilteredArticles()
        UIView.animate(withDuration:0.3, animations: {
            self.articleTable.reloadData()
        })
    }
    
    var searchBarController:UISearchController = UISearchController(searchResultsController: nil)
    var filteredArticles:[Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ArticleViewController viewDidLoad")
        
        self.articleTable.delegate = self
        self.articleTable.dataSource = self
        
        searchBarController.searchResultsUpdater = self
        searchBarController.hidesNavigationBarDuringPresentation = true
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.barStyle = UIBarStyle.black
        searchBarController.searchBar.barTintColor = UIColor.white
        searchBarController.searchBar.backgroundColor = UIColor.clear
        
        self.definesPresentationContext = true
        self.articleTable.tableHeaderView = searchBarController.searchBar
        
        filterSwitch.isOn = false
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("ArticleViewController - viewWillAppear")
        super.viewWillAppear(animated)
        
        showFilteredArticles()
        
        self.articleTable.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles.count
    }
    
    /// right-to-left / left-to-right swipe 시 숨겨진 버튼이 나오는 기능 구현
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! AritlceTableViewCell
        
        cell.articleForCell = filteredArticles[indexPath.row]
        
        /// 왼쪽 이미지
        let flagImg = resizeImage(image:UIImage(named:(filteredArticles[indexPath.row].archived ? "Star" : "Unstar")), newWidth:tableView.rowHeight / 2)
        
        cell.leftButtons = [MGSwipeButton(title: "", icon: flagImg, backgroundColor:(filteredArticles[indexPath.row].archived ? UIColor.lightGray : UIColor.yellow)){
            (sender: MGSwipeTableCell!) -> Bool in
            let cell = sender as! AritlceTableViewCell
            
            self.appDelegate.dataManager.supportedBoards[cell.groupid]?.articles[cell.key]?.archived = !self.filteredArticles[indexPath.row].archived
            self.articleTable.reloadData()
            
            self.appDelegate.dataManager.save()
            
            return true
            }]
        cell.leftSwipeSettings.transition = MGSwipeTransition.rotate3D
        
        cell.rightButtons = [MGSwipeButton(title: "Delete", icon: nil, backgroundColor: UIColor.red){
            (sender: MGSwipeTableCell!) -> Bool in
            let cell = sender as! AritlceTableViewCell
            
            self.appDelegate.dataManager.supportedBoards[cell.groupid]?.articles.removeValue(forKey:cell.key)
            
            self.showFilteredArticles()
            self.articleTable.reloadData()
            
            self.appDelegate.dataManager.save()
            
            return true
            }]
        cell.rightSwipeSettings.transition = MGSwipeTransition.rotate3D
        
        return cell
    }
    
    // 뒤로가기 용
    @IBAction func prepareForUnwindFromWebView(segue: UIStoryboardSegue){
        showFilteredArticles()
        self.articleTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// 게시글을 누를 경우 웹뷰로 이동
        if segue.identifier == "webViewSegue" {
            if let webVC = segue.destination as? WebViewController {
                if let selectedIndex = self.articleTable.indexPathForSelectedRow?.row {
                    let article = filteredArticles[selectedIndex]
                    appDelegate.dataManager.supportedBoards[article.groupid]?.articles[article.key]?.unopened = false
                    webVC.link = filteredArticles[selectedIndex].url
                }
            }
        }
    }
    
    func showFilteredArticles(){
        filteredArticles.removeAll(keepingCapacity: false)
        
        /// @TODO 2번째 탭에서 설정된 필터링된 결과로 변경
        for groupid in appDelegate.dataManager.supportedBoards.keys
        {
            if let board = appDelegate.dataManager.supportedBoards[groupid], board.favorite && !board.filtered{
                for key in board.articles.keys{
                    if let article = board.articles[key] {
                        if !filterSwitch.isOn || article.archived {
                            filteredArticles.append(article)
                        }
                    }
                }
            }
        }
        
        if let keyword = searchBarController.searchBar.text, keyword != "" {
            filteredArticles = filteredArticles.filter({$0.title.range(of:keyword) != nil})
        }
        
        filteredArticles.sort(by:{$0.date > $1.date})
    }
    
    /// 검색 창에 키가 입력 될 때 마다 실행 됨
    func updateSearchResults(for searchController: UISearchController) {
        showFilteredArticles()
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
}

class AritlceTableViewCell:MGSwipeTableCell {
    @IBOutlet weak var boardLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var unreadImage: UIImageView!
    
    var groupid:String = ""
    var key:String = ""
    
    var articleForCell:Article? {
        didSet {
            setUpCell()
        }
    }
    
    func setUpCell() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        guard let article = articleForCell else {
            return
        }
        
        dateLabel.text = article.date
        titleLabel.text = article.title
        boardLabel.text = appDelegate.dataManager.supportedBoards[article.groupid]?.name
        unreadImage.image = article.unopened ? UIImage(named: "Bluedot")! : nil

        self.groupid = article.groupid
        self.key = article.key
    }
}
