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
    
    @IBOutlet weak var archiveFilterButton: UIBarButtonItem!
    @IBOutlet weak var articleTable: UITableView!
    
    // 전체 게시글을 볼 것인지(false), 중요함 표시된 게시글만 볼 것인지(true)
    var isArchiveFiltered:Bool = false
    
    // 우측 상단 별 모양 버튼 리스너, 중요함 표시를 한 게시글들만 볼지 전체를 볼지 선택 
    @IBAction func changeArchiveFiltered(_ sender: Any) {
        isArchiveFiltered = !isArchiveFiltered
            
        archiveFilterButton.image = UIImage(named: (isArchiveFiltered ? "Star4Filter" : "Unstar4Filter"))
        
        UIView.transition(with: articleTable, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            self.filterArticles()
                            self.articleTable.reloadData()
        })
    }
    
    // 테이블 헤더에 추가할 검색창 입력
    var searchBarController:UISearchController = UISearchController(searchResultsController: nil)
    
    // 테이블에 표시할 게시글 목록
    var filteredArticles:[Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ArticleViewController viewDidLoad") // FOR DEBUG
        
        self.articleTable.delegate = self
        self.articleTable.dataSource = self
        
        // 테이블 헤더에 추가할 검색창 속성 입력
        searchBarController.searchResultsUpdater = self
        searchBarController.hidesNavigationBarDuringPresentation = false
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.barStyle = UIBarStyle.default
        searchBarController.searchBar.barTintColor = UIColor.white
        searchBarController.searchBar.backgroundColor = UIColor.black
        
        self.definesPresentationContext = true
        
        // 테이블 헤더에 게시글 검색창 추가
        self.articleTable.tableHeaderView = searchBarController.searchBar
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("ArticleViewController - viewWillAppear") // FOR DEBUG
        super.viewWillAppear(animated)
        
        filterArticles()
        
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
        
        // didSet을 이용한 cell 변경
        cell.articleForCell = filteredArticles[indexPath.row]
        
        // 왼쪽버튼 이미지
        let flagImg = resizeImage(image:UIImage(named:(filteredArticles[indexPath.row].archived ? "Star" : "Unstar")), newWidth:tableView.rowHeight / 2)
        
        // 게시글 우측으로 슬라이딩 시 좌측에 나타나는 버튼
        cell.leftButtons = [MGSwipeButton(title: "", icon: flagImg, backgroundColor:UIColor.lightGray){
            (sender: MGSwipeTableCell!) -> Bool in
            let cell = sender as! AritlceTableViewCell
            
            // 게시글에 중요 표시/해제
            self.appDelegate.dataManager.supportedBoards[cell.groupid]?.articles[cell.key]?.archived = !self.filteredArticles[indexPath.row].archived
            self.appDelegate.dataManager.save()
            
            self.filterArticles()
            self.articleTable.reloadData()
            
            return false
            }]
        cell.leftSwipeSettings.transition = MGSwipeTransition.rotate3D
        
        // 게시글 좌측으로 슬라이딩 시 우측에 나타나는 버튼
        cell.rightButtons = [MGSwipeButton(title: "Delete", icon: nil, backgroundColor: UIColor.red){
            (sender: MGSwipeTableCell!) -> Bool in
            let cell = sender as! AritlceTableViewCell
            
            // 게시글 삭제(복구 불가!!)
            self.appDelegate.dataManager.supportedBoards[cell.groupid]?.articles.removeValue(forKey:cell.key)
            self.appDelegate.dataManager.save()
            
            self.filterArticles()
            self.articleTable.reloadData()
            
            self.appDelegate.updateBoardTable()
            self.appDelegate.updateBadgeCount() // 게시글이 삭제 되었으므로, badge 갱신
            
            return true
            }]
        cell.rightSwipeSettings.transition = MGSwipeTransition.rotate3D
        
        return cell
    }
    
    /// (뒤로가기) 웹뷰 -> 탭1
    @IBAction func prepareForUnwindFromWebView(segue: UIStoryboardSegue){
        /// 웹뷰에 있는 동안 변경된 데이터를 위해 테이블 갱신
        self.filterArticles()
        self.articleTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// 게시글을 누를 경우 웹뷰로 이동
        if segue.identifier == "webViewSegue" {
            if let webVC = segue.destination as? WebViewController {
                if let selectedIndex = self.articleTable.indexPathForSelectedRow?.row {
                    let article = filteredArticles[selectedIndex]
                    
                    if let article = appDelegate.dataManager.supportedBoards[article.groupid]?.articles[article.key] {
                        // 게시글이 읽음으로 처리
                        appDelegate.dataManager.supportedBoards[article.groupid]?.articles[article.key]?.unopened = false
                        self.appDelegate.dataManager.save()
                        
                        self.appDelegate.updateBoardTable()
                        self.appDelegate.updateBadgeCount() // 게시글이 읽혀졌으므로, badge 갱신
                    }
                    webVC.link = filteredArticles[selectedIndex].url
                }
            }
        }
    }
    
    // 테이블에 표시한 게시물들을 선별
    func filterArticles(){
        filteredArticles.removeAll(keepingCapacity: false)
        
        // Tab2에서 설정한 필터를 적용한 결과로 테이블 갱신
        for groupid in appDelegate.dataManager.supportedBoards.keys
        {
            if let board = appDelegate.dataManager.supportedBoards[groupid], board.favorite && !board.filtered{
                for key in board.articles.keys{
                    if let article = board.articles[key] {
                        if !isArchiveFiltered || article.archived {
                            
                            /// 날짜 필터
                            if appDelegate.dataManager.filterByDate(article) {
                                filteredArticles.append(article)
                            }
                        }
                    }
                }
            }
        }
        
        // 검색창에 단어가 입력 된 경우, 키워드 필터 적용
        if let keyword = searchBarController.searchBar.text, keyword != "" {
            filteredArticles = filteredArticles.filter({$0.title.range(of:keyword) != nil})
        }
        
        // 게시물을 날짜 별로 최신순으로 정렬
        filteredArticles.sort(by: { (left:Article, right:Article) -> Bool in
            guard let format1 = appDelegate.dataManager.supportedBoards[left.groupid]?.format,
                let format2 = appDelegate.dataManager.supportedBoards[right.groupid]?.format else {
                    return true
            }
            
            let date1 = appDelegate.dataManager.convertDateToDefaultFormat(from: left.date, format: format1)
            let date2 = appDelegate.dataManager.convertDateToDefaultFormat(from: right.date, format: format2)
            
            return date1 > date2
        })
    }
    
    /// 검색 창에 키가 입력 될 때 마다 필터 적용
    func updateSearchResults(for searchController: UISearchController) {
        self.filterArticles()
        self.articleTable.reloadData()
    }
    
    /// 이미지 크기를 변경
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
        
        if let board = appDelegate.dataManager.supportedBoards[article.groupid] {
            
            // 날짜를 앱 기본 날짜 포맷으로 변환하여 표시
            dateLabel.text = appDelegate.dataManager.convertDateToDefaultFormat(from: article.date, format: board.format)
            titleLabel.text = article.title
            boardLabel.text = appDelegate.dataManager.supportedBoards[article.groupid]?.name
            unreadImage.image = article.unopened ? UIImage(named: "Bluedot")! : nil
            
            self.groupid = article.groupid
            self.key = article.key
        }
    }
}
