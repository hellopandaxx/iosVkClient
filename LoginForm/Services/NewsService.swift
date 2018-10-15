//
//  NewsService.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 27/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class NewsService{
    let baseUrl = "https://api.vk.com/method/"
    
    func loadNews(completion: @escaping ([Feed]) -> Void){
        let path = "newsfeed.get"
        
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.74",
            "filters": "post"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            guard let myData = response.value else { return }
            
            let rootjson = try! JSON(data: myData)
            
            let responseJson = rootjson["response"]
            let itemsJson = responseJson["items"]
            let profilesJson = responseJson["profiles"]
            let groupsJson = responseJson["groups"]
            
            let profiles = profilesJson.compactMap{User(json: $1)}
            let groups = groupsJson.compactMap{Group(json: $1)}
            
            let news = itemsJson.compactMap{Feed(json: $1, profiles: profiles, groups: groups)}
            
            completion(news)
        }
    }
}
