//
//  ApplicationServices.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-21.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

import Foundation

protocol ApplicationServiceDelegate: AnyObject {
    func getArticleService() -> ArticleService!
}

class ApplicationServices: ApplicationServiceDelegate  {
    
    
    private(set) var articleService: ArticleService!
    
    init() {
        articleService = ArticleManager.shared
    }
    
    func getArticleService() -> ArticleService! {
        return articleService
    }
    
}
