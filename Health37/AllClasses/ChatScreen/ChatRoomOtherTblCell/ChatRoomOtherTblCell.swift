//
//  ChatRoomOtherTblCell.swift
//  SimSim
//
//  Created by RamPrasad-IOS on 05/05/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ChatRoomOtherTblCell: UITableViewCell {

    @IBOutlet var imgUserFriend: UIImageView!
    @IBOutlet var lblMSG: UILabel!
    @IBOutlet var lblTimes: UILabel!
    @IBOutlet var imgTextMessage: UIImageView!
    @IBOutlet var btnUserProfile: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUserFriend.layer.cornerRadius = imgUserFriend.frame.size.width/2
        imgUserFriend.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
