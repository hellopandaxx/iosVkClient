//
//  User.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 09/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User : Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photo50Url = ""
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
    convenience init(json: JSON)
    {
        self.init()
        
        self.id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        
        self.photo50Url = json["photo_50"].stringValue
    }
}
