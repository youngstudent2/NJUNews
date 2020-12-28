//
//  NewsItem.swift
//  NJUNews
//
//  Created by nju on 2020/12/28.
//

import Foundation
class NewsItem : NSObject {
    var title : String
    var href : String
    var date : String
    init?(title:String,href:String,date:String){
        self.title = title
        self.href = href
        self.date = date
    }
}
