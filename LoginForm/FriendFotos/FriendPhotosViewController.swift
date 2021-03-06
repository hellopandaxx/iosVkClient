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
    
    private let columnsCount = CGFloat(4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        let screenWidth = UIScreen.main.bounds.width
        let layout = UICollectionViewFlowLayout()
        // layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth / columnsCount, height: screenWidth / columnsCount)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        
        photosNavigationItem.title = (friend?.firstName)! + "'s photos"
        
        vkService.loadAllUserPhotos(userId: friend!.id)
        
        pairTableAndRealm()
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        
        let filter = "ownerId=\(friend!.id.description)"
        
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
        return photos?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendPhotoCell", for: indexPath) as? FriendPhotoViewCell
        
        cell?.photoCell.image = nil
        cell?.photoCell.downloadedFrom(link: photos![indexPath.row].photo75url)
        cell?.photoCell.contentMode = .scaleAspectFill
        return cell!
    }
}
