//
//  Photo.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 09/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo : Object {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var photo75url = ""
    @objc dynamic var user : User?
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
    convenience init(json: JSON){
        self.init()
        
        self.id = json["id"].intValue
        self.photo75url = json["photo_75"].stringValue
        self.ownerId = json["owner_id"].intValue
    }
}
