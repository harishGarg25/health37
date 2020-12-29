//
//  ReplyCommentTblCell.swift
//  Health37
//
//  Created by Ramprasad on 02/11/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ReplyCommentTblCell: UITableViewCell {

    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var viewLblsBG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewLblsBG.layer.cornerRadius = 4.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
