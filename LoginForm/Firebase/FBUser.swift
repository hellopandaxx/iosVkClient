//
//  User.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 15/05/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import Foundation

struct FBGroup {
    let groupId : String
    
    var toAnyObject : Any {
        return [ "groupId" : groupId ]
    }
}

struct FBUser {
    let userId : String
    var addedGroups: [FBGroup]
    
    var toAnyObject : Any {
        return [
            "userId" : userId,
            "addedGroups" : addedGroups.map{ $0.toAnyObject }
        ]
    }
}
