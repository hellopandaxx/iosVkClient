//
//  FriendsTableViewCell.swift
//  VKClient
//
//  Created by Sergey Kuznetsov on 01/04/2018.
//  Copyright © 2018 Sergey Kuznetsov. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
