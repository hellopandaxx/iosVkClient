//
//  FriendPhotosViewController.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 03/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class FriendPhotosViewController: UICollectionViewController {
    @IBOutlet weak var photosNavigationItem: UINavigationItem!
    @IBOutlet var photosTableView: UICollectionView!
    
    var friend : User?
    var photos : Results<Photo>? //= [Photo]()
    
    var token : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        photosNavigationItem.title = (friend?.firstName)! + "'s photos"
        
//        vkService.loadAllUserPhotos(userId: friend!.id){[weak self] photos in
//            self?.photos = photos
//            self?.photosTableView.reloadData()
//        }
        
        vkService.loadAllUserPhotos(userId: friend!.id)
        
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        
        let filter = "ownerId=\(friend?.id)"
        photos = realm.objects(Photo.self).filter(filter)
        token = photos?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.photosTableView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
                }, completion: nil)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as? FriendPhotoViewCell
    
        cell?.photoCell.downloadedFrom(link: photos![indexPath.row].photo75url)
    
        return cell!
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
