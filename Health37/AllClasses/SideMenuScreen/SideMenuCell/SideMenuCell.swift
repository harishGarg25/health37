//
//  TableOptionCell.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet weak var img_icon: UIImageView!

    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_notificationCount: UILabel!

   
    @IBOutlet weak var view_options: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
