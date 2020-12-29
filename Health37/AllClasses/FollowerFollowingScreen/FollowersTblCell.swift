//
//  FollowersTblCell.swift
//  Health37
//
//  Created by Ramprasad on 14/09/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class FollowersTblCell: UITableViewCell {

    @IBOutlet var btnFollowerUserDetails: UIButton!
    @IBOutlet var imgFollwers: UIImageView!
    @IBOutlet var lblFollowerName: UILabel!
    @IBOutlet var btnFollow: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgFollwers.layer.cornerRadius = imgFollwers.frame.size.width/2
        imgFollwers.layer.masksToBounds = true
       btnFollow.layer.cornerRadius = 14.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
