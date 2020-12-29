//
//  AddCommentTblCell.swift
//  Health37
//
//  Created by Ramprasad on 02/11/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class AddCommentTblCell: UITableViewCell {

    @IBOutlet weak var tblRepliesHeight: NSLayoutConstraint!
    @IBOutlet var tblReplyComment: UITableView!
    @IBOutlet var btnUserDetails: UIButton!
    @IBOutlet var imgPostUser: UIImageView!
    @IBOutlet var lblPostUserName: UILabel!
    @IBOutlet var lblComment: UILabel!
    @IBOutlet var btnLikes: UIButton!
    @IBOutlet var btnComment: UIButton!
    @IBOutlet var lblLikesCount: UILabel!
    @IBOutlet var lblCommentsCount: UILabel!
    @IBOutlet var btnReply: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnReply.layer.cornerRadius = 13.0
        imgPostUser.layer.cornerRadius = imgPostUser.frame.size.width/2
        imgPostUser.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
