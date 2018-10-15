//
//  Group.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 09/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group : Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var usersCount = 0
    @objc dynamic var pictureUrl = ""
    @objc dynamic var isMember = false
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
    convenience init(json: JSON){
        self.init()
        
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.pictureUrl = json["photo_100"].stringValue
        self.usersCount = json["members_count"].intValue
        self.isMember = json["is_member"].boolValue
    }
}
