//
//  Board.swift
//  HyLionPost
//
//  Created by YeongsikLee on 2017. 5. 19..
//  Copyright © 2017년 HanyangSpam. All rights reserved.
//

import Foundation

/**
 *  @author
 *      이영식
 *  @date
 *      17` 05. 19
 *  @brief
 *      게시판
 *  @discussion
 *      articles 삭제, 관심여부 변경 시
 *  @Todo :
 *      - 클래스 아카이브 화
 *      - 필터값이 입력되면, 해당되는 게시물들만 반환
 *      - 설정을 통해 값 변경 시, Firebase에 반영
 */
class Board{
    var name:String
    var groupid:String
    var url:String
    var interested:Bool
    var articles:[Article]
    
    init(name:String, groupid:String, url:String, interested:Bool)
    {
        self.name = name
        self.groupid = groupid
        self.url = url
        self.interested = interested
        self.articles = []
    }
    
    func addArticle(article:Article) -> Void
    {
        self.articles.append(article)
    }
    
    func deleteArticle(article:Article) -> Bool
    {
        if let idx = self.articles.index(where: {$0.title == article.title && $0.url == article.url && $0.date == article.date}) {
            self.articles.remove(at:idx)
            return true
        }
        
        return false
    }
    
    /// 설정을 통해 값 변경 시, Alamofire를 이용 Firebase에 반영시키는 함수
    func doPostAboutChangeInfo()
    {
        
    }
    
    /// 필터 설정을 통해 해당되는 게시물들만 반환
    func filterArticle() -> [Article]
    {
        
        return []
    }
}
