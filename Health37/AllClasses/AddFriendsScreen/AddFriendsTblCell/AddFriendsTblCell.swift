//
//  AddFriendsTblCell.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class AddFriendsTblCell: UITableViewCell {

    @IBOutlet weak var btnFriendProfile: UIButton!
    @IBOutlet var viewCellBG: ShadowView!
    @IBOutlet var btnAddFriends: UIButton!
    @IBOutlet var lblFriendsName: UILabel!
    @IBOutlet var imgFriends: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
