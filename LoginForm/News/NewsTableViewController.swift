//
//  NewsTableViewController.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 27/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    @IBOutlet var newsTV: UITableView!
    
    var photoService: PhotoService?
    
    var news = [Feed]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoService = PhotoService(container: newsTV)

        let service = NewsService()
        
        DispatchQueue.global(qos: .userInteractive).async {
            service.loadNews(){[weak self] news in
                DispatchQueue.main.async {
                    self?.news = news
                    self?.newsTV.reloadData()
                }
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsPostCell", for: indexPath) as!  NewsTableViewCell

        let feed = news[indexPath.row]
        
        //cell.authorImage.downloadedFrom(link: feed.authorImageUrl)
        cell.authorImage.image = photoService?.photo(atIndexpath: indexPath, byUrl: feed.authorImageUrl)
        cell.authorImage.layer.cornerRadius = cell.authorImage.bounds.width / 2.0
        cell.authorImage.layer.masksToBounds = true
        
        cell.authorNameTxt.text = feed.authorName
        cell.contentTextTxt.text = feed.text
        
        if feed.mainImageUrl != "" {
            cell.mainImageImg.downloadedFrom(link: feed.mainImageUrl)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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