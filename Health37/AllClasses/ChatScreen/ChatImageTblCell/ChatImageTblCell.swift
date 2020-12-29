//
//  ChatImageTblCell.swift
//  Health37
//
//  Created by Ramprasad on 12/11/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.


import UIKit

class ChatImageTblCell: UITableViewCell {

    @IBOutlet var imgPostBG: UIImageView!
    @IBOutlet var lblPostDetails: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var imgPost: UIImageView!
    @IBOutlet var btnUserProfile: UIButton!
    @IBOutlet var imgUserPro: UIImageView!
    ////Other UserOUtlet
    @IBOutlet var viewCellBG: UIView!
    @IBOutlet var imgPostBG2: UIImageView!
    @IBOutlet var imgUserPro2: UIImageView!
    @IBOutlet var btnUserProfile2: UIButton!
    @IBOutlet var imgPost2: UIImageView!
    @IBOutlet var lblPostDetails2: UILabel!
    @IBOutlet var lblTime2: UILabel!
    
    @IBOutlet var btnImgInfoFirst: UIButton!
    @IBOutlet var btnImgInfo: UIButton!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        imgUserPro.layer.cornerRadius = imgUserPro.frame.size.width/2
        imgUserPro.layer.masksToBounds = true
        imgUserPro2.layer.cornerRadius = imgUserPro2.frame.size.width/2
        imgUserPro2.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
