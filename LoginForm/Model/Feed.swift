//
//  Feed.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 27/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Feed {
    
    var type = "" // post,photo
    var sourceId = 0
    
    var authorName = ""
    var authorImageUrl = ""
    
    var text = ""
    var mainImageUrl = ""
    
    var likes = 0
    var reposts = 0
    var views = 0
    
    
    init(json: JSON, profiles: [User], groups: [Group]){
        self.type = json["type"].stringValue
        self.sourceId = json["source_id"].intValue
        
        if self.type == "post" {
            self.likes = json["likes"]["count"].intValue
            self.reposts = json["reposts"]["count"].intValue
            self.views = json["views"]["count"].intValue
            
            self.text = json["text"].stringValue
            
            let photo = json["attachments"].arrayValue.first(where: {$0["type"]=="photo"})
            self.mainImageUrl = photo?["photo"]["photo_130"].stringValue ?? ""
        } else if self.type == "photo" {
            let photo = json["photos"]["items"][0]
            
            self.likes = photo["likes"]["count"].intValue
            self.reposts = photo["reposts"]["count"].intValue
            self.mainImageUrl = photo["photo_130"].stringValue
        }
        
        if self.sourceId > 0 {
            // Post from User
            let user = profiles.first(where: {$0.id == self.sourceId})
            
            self.authorName = (user?.firstName ?? "") + " " + (user?.lastName ?? " ")
            self.authorImageUrl = user?.photo50Url ?? ""
        } else {
            // Post from Group
            let group = groups.first(where: {$0.id == -self.sourceId})
            
            self.authorName = group?.name ?? ""
            self.authorImageUrl = group?.pictureUrl ?? ""
        }
    }
}
