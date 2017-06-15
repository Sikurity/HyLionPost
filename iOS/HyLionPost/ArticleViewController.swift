//
//  ArticleViewController.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 5..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UIActionSheetDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 편집 모드에서 수행할 수정 작업을 선택할 ActionSheet
    let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    // 편집 모드에서 삭제를 할 것인지, 취소할 것인지 선택할 Alert
    let alertController = UIAlertController(title: "삭제하시겠습니까?", message: "삭제 후에는 되돌릴 수 없습니다", preferredStyle: .alert)
    
    @IBOutlet weak var articleTable: UITableView!                   // 게시글 목록 테이블
    
    @IBOutlet weak var archiveFilterButton: UIBarButtonItem!        // 관심글/전체글 보기 전환 버튼
    @IBOutlet weak var titleItem: UINavigationItem!                 // 제목
    @IBOutlet weak var editButton: UIBarButtonItem!                 // 편집/취소 전환 버튼
    
    @IBOutlet weak var editToolBar: UIToolbar!                      // 편집모드 용 ToolBar
    @IBOutlet weak var toolBarHeightConstraint: NSLayoutConstraint! // 편집모드 용 ToolBar Show/Hide 제어용 Constraint
    
    @IBOutlet weak var selectAllButton: UIBarButtonItem!            // 편집모드 용 ToolBar - 전체 선택/해제 버튼
    @IBOutlet weak var modifyButton: UIBarButtonItem!               // 편집모드 용 ToolBar - 수정 버튼
    @IBOutlet weak var removeButton: UIBarButtonItem!               // 편집모드 용 ToolBar - 삭제 버튼
    
    // 현재 편집 중인지, 아닌지 상태를 저장
    var isEditMode: Bool = false
    
    // 전체 게시글을 볼 것인지(false), 중요함 표시된 게시글만 볼 것인지(true)
    var isArchiveFiltered:Bool = false
    
    // 테이블 헤더에 추가할 검색창 입력
    var searchBarController:UISearchController = UISearchController(searchResultsController: nil)
    
    // 테이블에 표시할 게시글 목록
    var filteredArticles:[Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ArticleViewController viewDidLoad") // FOR DEBUG
        
        // delegate, datasource를 ArticleViewController로 적용
        self.articleTable.delegate = self
        self.articleTable.dataSource = self
        self.articleTable.allowsMultipleSelectionDuringEditing = true   // 편집 모드는 다중 선택 모드로 선택
        
        // 테이블 헤더에 추가할 검색창 속성 입력
        searchBarController.searchResultsUpdater = self
        searchBarController.hidesNavigationBarDuringPresentation = false
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.barStyle = UIBarStyle.default
        searchBarController.searchBar.barTintColor = UIColor.white
        searchBarController.searchBar.backgroundColor = UIColor.black
        
        // 검색 창이 화면전환 시에도 사라지지 않는 것을 방지
        self.definesPresentationContext = true
        
        // 테이블 헤더에 게시글 검색창 추가
        self.articleTable.tableHeaderView = searchBarController.searchBar
        
        // 편집 툴바를 처음에는 보이지 않게
        editToolBar.isHidden = !isEditMode
        
        /// 선택된 게시글들을 읽음으로 처리
        let readAction = UIAlertAction(title: "읽음으로 표시", style: .default) { action -> Void in
            print("읽음으로 표시")    // FOR DEBUG
            
            if let indexPaths = self.articleTable.indexPathsForSelectedRows {
                for indexPath in indexPaths {
                    let groupid = self.filteredArticles[indexPath.row].groupid
                    let key = self.filteredArticles[indexPath.row].key
                    
                    self.appDelegate.dataManager.supportedBoards[groupid]?.articles[key]?.unopened = false
                }
                
                self.appDelegate.dataManager.save()
                
                self.filterArticles(false)
                
                self.updateEditingViewWords()
                self.appDelegate.updateBoardTable()
                self.appDelegate.updateBadgeCount()
            }
        }
        
        /// 선택된 게시글들을 관심글로 등록
        let registAction = UIAlertAction(title: "관심글로 등록", style: .default) { action -> Void in
            print("관심글로 등록")    // FOR DEBUG
            
            if let indexPaths = self.articleTable.indexPathsForSelectedRows {
                print("!!!")
                for indexPath in indexPaths {
                    print(indexPath.row)
                    let groupid = self.filteredArticles[indexPath.row].groupid
                    let key = self.filteredArticles[indexPath.row].key
                    
                    self.appDelegate.dataManager.supportedBoards[groupid]?.articles[key]?.archived = true
                }
                
                self.appDelegate.dataManager.save()
                
                self.filterArticles(false)
                
                self.updateEditingViewWords()
                self.appDelegate.updateBoardTable()
                self.appDelegate.updateBadgeCount()
            }
        }
        
        /// 선택된 게시글들을 관심글에서 제외
        let releaseAction = UIAlertAction(title: "관심글에서 제외", style: .default) { action -> Void in
            print("관심글에서 제외")    // FOR DEBUG
            
            if let indexPaths = self.articleTable.indexPathsForSelectedRows {
                for indexPath in indexPaths {
                    let groupid = self.filteredArticles[indexPath.row].groupid
                    let key = self.filteredArticles[indexPath.row].key
                    
                    self.appDelegate.dataManager.supportedBoards[groupid]?.articles[key]?.archived = false
                }
                
                self.appDelegate.dataManager.save()
                
                self.filterArticles(false)
                
                self.updateEditingViewWords()
                self.appDelegate.updateBoardTable()
                self.appDelegate.updateBadgeCount()
            }
        }
        
        /// 수정 취소
        let cancelModifyAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            // Just dismiss the action sheet
            print("수정 취소")
        }
        
        /// 게시글 일괄 삭제
        let removeAction = UIAlertAction(title: "확인", style: .destructive) { action -> Void in
            if let indexPaths = self.articleTable.indexPathsForSelectedRows {
                for indexPath in indexPaths {
                    let groupid = self.filteredArticles[indexPath.row].groupid
                    let key = self.filteredArticles[indexPath.row].key
                    
                    self.appDelegate.dataManager.supportedBoards[groupid]?.articles.removeValue(forKey: key)
                }
                
                self.appDelegate.dataManager.save()
                
                self.filterArticles(false)
                
                self.updateEditingViewWords()
                self.appDelegate.updateBoardTable()
                self.appDelegate.updateBadgeCount()
            }
        }
        
        /// 삭제 취소
        let cancelRemoveAction = UIAlertAction(title: "취소", style: .cancel) { action -> Void in
            // Just dismiss the action sheet
            print("삭제 취소")
        }
        
        // 편집 중 수정 ActionSheet의 선택지 추가
        actionSheetController.addAction(readAction)
        actionSheetController.addAction(registAction)
        actionSheetController.addAction(releaseAction)
        actionSheetController.addAction(cancelModifyAction)
        
        // 편집 중 삭제 Alert의 선택지 추가
        alertController.addAction(removeAction)
        alertController.addAction(cancelRemoveAction)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }   
    
    override func viewWillAppear(_ animated: Bool)
    {
        print("ArticleViewController - viewWillAppear") // FOR DEBUG
        super.viewWillAppear(animated)
        
        editToolBar.isHidden = !isEditMode
        toolBarHeightConstraint.constant = self.tabBarController?.bottomLayoutGuide.length ?? 0.0
        
        self.tabBarController?.tabBar.isHidden = isEditMode
        
        self.filterArticles(false)           // 화면이 새로 표시될 때마다, 게시물 필터 적용
    }
    
    /// (뒤로가기) 웹뷰 -> 탭1
    @IBAction func prepareForUnwindFromWebView(segue: UIStoryboardSegue){
        /// 웹뷰에 있는 동안 변경된 데이터를 위해 테이블 갱신
        self.filterArticles(false)
    }

    /// 편집 중인 경우 웹뷰 이동 막음
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !isEditMode
    }
    
    /// 웹뷰로 이동할 때 읽음 처리
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 게시글을 누를 경우 웹뷰로 이동
        if segue.identifier == "webViewSegue" {
            if let webVC = segue.destination as? WebViewController {
                if let selectedIndex = self.articleTable.indexPathForSelectedRow?.row {
                    let article = filteredArticles[selectedIndex]
                    
                    if let article = appDelegate.dataManager.supportedBoards[article.groupid]?.articles[article.key] {
                        // 게시글 읽음으로 처리
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
    
    // 우측 상단 별 모양 버튼 리스너, 중요함 표시를 한 게시글들만 볼지 전체를 볼지 선택
    @IBAction func changeArchiveFiltered(_ sender: Any) {
        print("높이")
        print(toolBarHeightConstraint.constant)
        print("히든")
        print(editToolBar.isHidden)
        isArchiveFiltered = !isArchiveFiltered
        titleItem.title = (isArchiveFiltered ? "중요 게시물" : "전체 게시물")
        
        archiveFilterButton.image = UIImage(named: (isArchiveFiltered ? "Star4Filter" : "Unstar4Filter"))
        
        UIView.transition(with: self.articleTable, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.filterArticles(false)
        })
        
        if isEditMode { // 편집 모드인 경우, 편집용 버튼들 갱신
            updateEditingViewWords()
        }
    }
    
    /// 편집/취소 버튼을 누른 경우 실행
    @IBAction func changeArticles(_ sender: Any) {
        isEditMode = !isEditMode
        articleTable.setEditing(isEditMode, animated: true)
        
        if isEditMode { // 편집모드 시작
            searchBarController.searchBar.barStyle = UIBarStyle.default
            searchBarController.searchBar.barTintColor = UIColor.lightGray
            searchBarController.searchBar.backgroundColor = UIColor.white
            searchBarController.searchBar.alpha = 0.2
            
            editButton.title? = "취소"
            toolBarHeightConstraint.constant = self.tabBarController?.bottomLayoutGuide.length ?? 0.0
            
            self.tabBarController?.tabBar.isHidden = true
            self.editToolBar.isHidden = false
            self.searchBarController.searchBar.isUserInteractionEnabled = false
            
            updateEditingViewWords()
            
        } else {        // 편집모드 취소
            searchBarController.searchBar.barStyle = UIBarStyle.default
            searchBarController.searchBar.barTintColor = UIColor.white
            searchBarController.searchBar.backgroundColor = UIColor.black
            searchBarController.searchBar.alpha = 1.0
            
            editButton.title? = "편집"
            toolBarHeightConstraint.constant = 0.0
            
            self.tabBarController?.tabBar.isHidden = false
            self.editToolBar.isHidden = true
            self.searchBarController.searchBar.isUserInteractionEnabled = true
            
            titleItem.title? = isArchiveFiltered ? "중요 게시글" : "전체 게시글"
            
            self.filterArticles(false)
        }
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
            
            self.filterArticles(false)
            
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
            
            UIView.transition(with: self.articleTable, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.filterArticles(false)
            })
            
            self.appDelegate.updateBoardTable()
            self.appDelegate.updateBadgeCount() // 게시글이 삭제 되었으므로, badge 갱신
            
            return true
            }]
        cell.rightSwipeSettings.transition = MGSwipeTransition.rotate3D
        
        return cell
    }
    
    /// 전체 선택/해제 버튼을 누를 경우 전체 게시글들을 선택/해제
    @IBAction func selectDeselectAll(_ sender: Any) {
        if let indexPaths = self.articleTable.indexPathsForSelectedRows , indexPaths.count > 0 {  // 선택된 셀들이 있으므로 전체 해제
            for indexPath in indexPaths {
                self.articleTable.deselectRow(at: indexPath, animated: false)
            }
        } else {  // 선택된 셀들이 없으므로 전체 선택
            for row in 0..<self.articleTable.numberOfRows(inSection: 0) {
                self.articleTable.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
            }
        }
        
        updateEditingViewWords()
    }
    
    /// 수정 버튼을 누를 경우 작업할 선택지들을 표시할 ActionSheet 띄움
    @IBAction func showModifyActionSheet(_ sender: Any) {
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    /// 삭제 버튼을 누를 경우 삭제할 지, 취소할 지 선택할 Alert 띄움
    @IBAction func confirmRemoveCancel(_ sender: Any) {
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// cell을 눌러 선택 상태로 변경된 경우 실행 됨
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode { // 편집 모드인 경우, 편집용 버튼들 갱신
            updateEditingViewWords()
            print(filteredArticles[indexPath.row].time) // FOR DEBUG
            // print("didSelectRowAt \(indexPath.row)")
            // print(tableView.indexPathsForSelectedRows)
        }
    }
    
    /// cell이 선택 상태에서 해제될 경우 실행 됨
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isEditMode { // 편집 모드인 경우, 편집용 버튼들 갱신
            updateEditingViewWords()
            
            // print("didDeselectRowAt \(indexPath.row)")   // FOR DEBUG
            // print(tableView.indexPathsForSelectedRows)   // FOR DEBUG
        }
    }
    
    /// 편집모드에서 선택된 게시글들의 개수를 토대로 제목, 편집용 버튼 이름 변경
    func updateEditingViewWords() {
        // print(self.articleTable.indexPathsForSelectedRows)   // FOR DEBUG
        if let indexPaths = self.articleTable.indexPathsForSelectedRows, indexPaths.count > 0 {
            titleItem.title? = "\(indexPaths.count)개 선택 됨"
            selectAllButton.title? = "전체 해제"
            
            modifyButton.isEnabled = true
            removeButton.isEnabled = true
        } else {
            titleItem.title? = "게시글 편집"
            selectAllButton.title? = "전체 선택"
            
            modifyButton.isEnabled = false
            removeButton.isEnabled = false
        }
    }
    
    /// 전체 게시물 중 테이블에 표시할 게시물들 필터링
    func filterArticles(_ willBlockedAtEditing:Bool){
        if willBlockedAtEditing && isEditMode {
            return
        }
        
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
            
            if date1 != date2 {
                return date1 > date2
            } else {
                return left.time > right.time
            }
        })
        
        articleTable.reloadData()
    }
    
    /// 검색 창에 키가 입력 될 때 마다 필터 적용
    func updateSearchResults(for searchController: UISearchController) {
        self.filterArticles(false)
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
            unreadImage.image = article.unopened ? UIImage(named: "GreenDot")! : nil
            
            self.groupid = article.groupid
            self.key = article.key
        }
    }
}
