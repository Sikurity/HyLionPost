//
//  Article.swift
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
 *  @todo :
 *      - 클래스 아카이브 화
 */
class Article{
    var title:String    // 게시물 제목
    var url:String      // 게시물 링크
    var date:String     // 게시된 날짜
    var intersted:Bool  // 게시물 관심여부
    
    init(title:String, url:String, date:String, intersted:Bool)
    {
        self.title = title
        self.url = url
        self.date = date
        self.intersted = intersted
    }
}
