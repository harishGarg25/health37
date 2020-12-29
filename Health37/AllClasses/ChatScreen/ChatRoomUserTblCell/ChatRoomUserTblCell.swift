//
//  ChatRoomUserTblCell.swift
//  SimSim
//
//  Created by RamPrasad-IOS on 05/05/17.
//  Copyright © 2017 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ChatRoomUserTblCell: UITableViewCell {

    @IBOutlet var imgUserSelf: UIImageView!
    @IBOutlet var lblTimes: UILabel!
    @IBOutlet var lblMSG: UILabel!
    @IBOutlet var imgTextMessage: UIImageView!
    @IBOutlet var btnUserProfile: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUserSelf.layer.cornerRadius = imgUserSelf.frame.size.width/2
        imgUserSelf.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
