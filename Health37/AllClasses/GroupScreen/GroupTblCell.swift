//
//  GroupTblCell.swift
//  Health37
//
//  Created by Ramprasad on 13/09/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class GroupTblCell: UITableViewCell {
    @IBOutlet var btnJoin: UIButton!
    
    @IBOutlet  var btnGroupDtls: UIButton!
    @IBOutlet var imgUsers: UIImageView!
    @IBOutlet var lblSubtitle: UILabel!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgUsers.layer.cornerRadius = imgUsers.frame.size.width/2
        imgUsers.layer.masksToBounds = true
        btnJoin.layer.cornerRadius = 14.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
