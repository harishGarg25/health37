//
//  GroupOuserProTblCell.swift
//  Health37
//
//  Created by Ramprasad on 12/10/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class GroupOuserProTblCell: UITableViewCell {
    @IBOutlet var imgCover: UIImageView!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet var lblGroupCount: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDesignation: UILabel!
    @IBOutlet var btnAddPost: UIButton!
    @IBOutlet var btnLeaveJoin: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnLeaveJoin.layer.cornerRadius = 14.0
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.width/2
        imgUserProfile.layer.masksToBounds = true
        imgUserProfile.layer.borderWidth = 1.0
        imgUserProfile.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
