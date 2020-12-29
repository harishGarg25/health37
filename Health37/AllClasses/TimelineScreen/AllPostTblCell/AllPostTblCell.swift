//
//  AllPostTblCell.swift
//  Health37
//
//  Created by RamPrasad-IOS on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class AllPostTblCell: UITableViewCell {

    @IBOutlet weak var btnUserProfile: UIButton!
    @IBOutlet var btnReadMore: UIButton!
    @IBOutlet var imgPost: UIImageView!
    @IBOutlet var btnLike: UIButton!
    @IBOutlet var btnComments: UIButton!
    @IBOutlet var btnSharing: UIButton!
    @IBOutlet var viewRating: FloatRatingView!
    @IBOutlet var lblNameTimeline: UILabel!
    @IBOutlet var imgTimeline: UIImageView!
    @IBOutlet var lblTimeAgo: UILabel!
    @IBOutlet var viewPostBG: UIView!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var lblPostDetails: UILabel!
    @IBOutlet var lblLikeCount: UILabel!
    @IBOutlet var lblComment: UILabel!
    
    @IBOutlet var btnHide: UIButton!
    @IBOutlet var btnInformation: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgTimeline.layer.cornerRadius = imgTimeline.frame.size.width/2
        imgTimeline.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
