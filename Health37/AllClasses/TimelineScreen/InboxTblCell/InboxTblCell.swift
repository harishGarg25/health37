//
//  InboxTblCell.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class InboxTblCell: UITableViewCell {

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgUsers: UIImageView!
    @IBOutlet var viewInboxCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewInboxCell.layer.borderWidth = 1.0
        viewInboxCell.layer.borderColor = UIColor.lightGray.cgColor
        imgUsers.layer.cornerRadius = imgUsers.frame.size.width/2
        imgUsers.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
