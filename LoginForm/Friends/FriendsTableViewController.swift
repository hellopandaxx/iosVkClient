//
//  FriendsTableViewController.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 01/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    @IBOutlet var friendsTableView: UITableView!
    
    var friends: Results<User>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkService.loadFriendsList()
        
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(User.self).sorted(byKeyPath: "firstName")
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.friendsTableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendsTableViewCell

        // Configure the cell...
        let friend = friends![indexPath.row]
        cell?.nameLabel.text = friend.firstName + " " + friend.lastName
        
        cell?.friendImage.image = nil
        
        // Acync image loading.
        cell?.friendImage.downloadedFrom(link: friend.photo50Url)
        
        cell?.friendImage.layer.cornerRadius = (cell?.friendImage.bounds.height ?? 0) / 2.0
        cell?.friendImage.layer.masksToBounds = true
        
        //cell?.bounds.size height = (cell?.friendImage.bounds.height ?? 0) + 10

        return cell!
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos" {
            let photosController = segue.destination as? FriendPhotosViewController
            
            if let indexPath = friendsTableView.indexPathForSelectedRow {
                 let friend = friends![indexPath.row]
                
                photosController?.friend = friend
            }
        }
    }
}
