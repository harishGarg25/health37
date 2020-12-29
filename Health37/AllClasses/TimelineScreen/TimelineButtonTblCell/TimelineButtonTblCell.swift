//
//  TimelineButtonTblCell.swift
//  Health37
//
//  Created by RamPrasad-IOS on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class TimelineButtonTblCell: UITableViewCell {

    @IBOutlet var btnHeart: UIButton!
    @IBOutlet var btnAllPost: UIButton!
    @IBOutlet var btnHome: UIButton!
    @IBOutlet var btnAddPost: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
