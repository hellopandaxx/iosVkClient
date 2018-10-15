//
//  VKService.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 06/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class VKService{
    
    let baseUrl = "https://api.vk.com/method/"
    
    func loadFriendsList(/*completion: @escaping () -> Void*/) {
        let path = "friends.get"
        
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.74",
            "fields": "nickname,photo_50"
            ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { [weak self] response in
            
            guard let myData = response.value else { return }
            
            let rootjson = try! JSON(data: myData)
            
            let responseJson = rootjson["response"]
            let itemsJson = responseJson["items"]
            
            let users = itemsJson.flatMap{User(json: $1)}
            
            self?.saveFriendsList(users)
            // completion()
        }
    }
    
    func saveFriendsList(_ friends: [User])
    {
        do{
            let realm = try Realm()
            
            let oldFriends = realm.objects(User.self)
            
            realm.beginWrite()
            realm.delete(oldFriends)
            realm.add(friends)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func loadAllUserPhotos(userId: Int /*, completion: @escaping ([Photo]) -> Void*/) {
        let path = "photos.getAll"
        
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.74",
            "owner_id" : userId
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            
            guard let myData = response.value else { return }
            
            let rootjson = try! JSON(data: myData)
            
            let responseJson = rootjson["response"]
            let itemsJson = responseJson["items"]
            
            let photos = itemsJson.flatMap{Photo(json: $1)}
            
            self.saveUserPhotos(photos, userId: userId)
            
            // completion(photos)
        }
    }
    
    func saveUserPhotos(_ photos: [Photo], userId: Int)
    {
        do{
            let realm = try Realm()
            
            let oldPhotos = realm.objects(Photo.self).filter("ownerId=\(userId)")
            
            realm.beginWrite()
            realm.delete(oldPhotos)
            realm.add(photos)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func loadUserGroups(completion: @escaping ([Group]) -> Void) {
        let path = "groups.get"
        
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.74",
            "extended": "1",
            "fields" : "members_count"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            guard let myData = response.value else { return }
            
            let rootjson = try! JSON(data: myData)
            
            let responseJson = rootjson["response"]
            let itemsJson = responseJson["items"]
            
            let groups = itemsJson.flatMap{Group(json: $1)}
            
            completion(groups)
        }
    }
    
    func searchGroups(param: String, completion: @escaping ([Group]) -> Void)  {
        let path = "groups.search"
        
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.74",
            //"extended": "1",
            "q" : param,
            "fields" : "members_count"
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            guard let myData = response.value else { return }
            
            let rootjson = try! JSON(data: myData)
            
            let responseJson = rootjson["response"]
            let itemsJson = responseJson["items"]
            
            let groups = itemsJson.flatMap{Group(json: $1)}
            
            completion(groups)
        }
    }
    
    func joinGroup(id: Int, completion: @escaping (Bool) -> Void) {
        let path = "groups.join"
        
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.74",
            "group_id" : id
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            guard let myData = response.value else { return }
            
            let rootjson = try! JSON(data: myData)
            
            let success = rootjson["response"].intValue == 1
            
            completion(success)
        }
    }
    
    func leaveGroup(id: Int, completion: @escaping (Bool) -> Void) {
        let path = "groups.leave"
        
        let parameters: Parameters = [
            "access_token": token,
            "v": "5.74",
            "group_id" : id
        ]
        
        let url = baseUrl + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseData { response in
            guard let myData = response.value else { return }
            
            let rootjson = try! JSON(data: myData)
            
            let success = rootjson["response"].intValue == 1
            
            completion(success)
        }
    }
}

