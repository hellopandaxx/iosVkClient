//
//  MyGroupsController.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 03/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MyGroupsController: UITableViewController {

    var myGroups = [Group]()

    @IBOutlet var myGroupsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadGroups()
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
        return myGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupCell", for: indexPath) as! MyGroupsCell

        // Configure the cell...
        let group = myGroups[indexPath.row]
        cell.groupNameLabel.text = group.name
        
        cell.groupImage.downloadedFrom(link: group.pictureUrl)

        return cell
    }
    
    @IBAction func addGroup(segue:UIStoryboardSegue){
     if segue.identifier == "addGroup"{
         let allGroupsController = segue.source as! AllGroupsController

         if let indexPath = allGroupsController.allGroupsTable.indexPathForSelectedRow {
             let newGroup = allGroupsController.allGroups[indexPath.row]
             // let groupName = newGroup.name
             if !newGroup.isMember{
                vkService.joinGroup(id: newGroup.id){[weak self] result in
                    if(result){
                        self?.loadGroups()
                        
                        let dbLink = Database.database().reference()
                        dbLink.child("Users/\(currentUserId)/addedGroups").updateChildValues([String(newGroup.id) : FBGroup(groupId: String(newGroup.id)).toAnyObject])
                    }
                }
             }
         }
     }
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let leaveGroup = myGroups[indexPath.row]
            
            vkService.leaveGroup(id: leaveGroup.id) {[weak self] result in
                if(result == true){
                    self?.myGroups.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func loadGroups(){
        vkService.loadUserGroups(){[weak self] groups in
            self?.myGroups = groups
            self?.myGroupsTable.reloadData()
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
