//
//  ArticlesManager.swift
//  MySwiftNews
//
//  Created by Sailee Pereira on 2020-07-21.
//  Copyright © 2020 SaileePereira. All rights reserved.
//

/*
 this class is pertaining to only Article service, any articles related API requests to be included here
 */
import Foundation

protocol ArticleService: class {
    var articles: [ArticleModel]? { get }
    func getArticles(onCompletion: @escaping ((ErrorModel?, [ArticleModel]?) -> ()))
}

final class ArticleManager: BaseService, ArticleService {
    var articles: [ArticleModel]?
    private static let getArticlesUrl = "https://www.reddit.com/r/swift/.json"
    
    static let shared = ArticleManager()
    
    func getArticles(onCompletion: @escaping ((ErrorModel?, [ArticleModel]?) -> ())) {
        self.makeRequest(uri: ArticleManager.getArticlesUrl, method: .get, completion: { responseModel in
            switch responseModel.responseCode {
            case .ok(_ ):
                if let responseData = responseModel.responseData, let result = self.toCodable(News.self, from: responseData) {
                    if let dataList =  result.data?.children, dataList.count > 0 {
                        var resultList: [ArticleModel] = []
                        dataList.forEach({ item in
                            let model = ArticleModel(title: item.data?.title ?? "", thumbnailUrl: item.data?.thumbnail, thumbnail_height: item.data?.thumbnail_height ?? 0, articleData: item.data?.selftext_html)
                            resultList.append(model)
                        })
                        onCompletion(nil, resultList)
                        return
                    } else {
                        onCompletion(ErrorModel(errorCode: 9999, message: "No Articles Found"), nil)
                        return
                    }
                }
            default:
                //try to encode the error response if any
                if let responseData = responseModel.responseData, let errorResult = self.toCodable(ErrorModel.self, from: responseData){
                    onCompletion(errorResult, nil)
                    return
                } else {
                    onCompletion(ErrorModel(errorCode: responseModel.statusCode, message: responseModel.errorMessage ?? responseModel.responseCode.errorMessage), nil)
                    return
                }
            }
            onCompletion(ErrorModel(errorCode: responseModel.statusCode, message: responseModel.errorMessage ?? responseModel.responseCode.errorMessage), nil)
        })
    }
}
