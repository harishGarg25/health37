//
//  HomeOptionsTblCell.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class HomeOptionsTblCell: UITableViewCell {

    @IBOutlet var viewCellBG: UIView!
    @IBOutlet var lblHomeOptions: UILabel!
    @IBOutlet var imgOptions: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
