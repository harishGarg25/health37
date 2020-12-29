//
//  UsersInfoTblCell.swift
//  Health37
//
//  Created by RamPrasad-IOS on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class UsersInfoTblCell: UITableViewCell {

    @IBOutlet var btnRateAndReview: UIButton!
    @IBOutlet var btnFollowUnfollow: UIButton!
    @IBOutlet var btnFollowing: UIButton!
    @IBOutlet var btnFollowers: UIButton!
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblWorkingPost: UILabel!
    @IBOutlet var lblUserDetails: UILabel!
    @IBOutlet var btnSeeMore: UIButton!
    @IBOutlet var btnAskMe: UIButton!
    @IBOutlet var viewRating: FloatRatingView!
    @IBOutlet var lblRatingCounting: UILabel!
    @IBOutlet var imgCoverPhoto: UIImageView!
    @IBOutlet weak var lblTotalFollowers: UILabel!
    @IBOutlet weak var lblTotalFollowing: UILabel!
    @IBOutlet var lblDiscriptions: UILabel!
    @IBOutlet var imgAsk: UIImageView!
    @IBOutlet weak var appointmentView: UIView!
    @IBOutlet var btnBookAppointMent: UIButton!
    @IBOutlet var buttonTitleLabel: UILabel!
    @IBOutlet var btnLocation: UIButton!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var discLabel: UILabel!
    @IBOutlet var btnCall: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnFollowUnfollow.layer.cornerRadius = 14.0
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width/2
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.borderWidth = 1.0
        imgProfile.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        if buttonTitleLabel != nil
        {
            discLabel.text = discLabel.text?.localized
            buttonTitleLabel.text = "BOOK APPOINTMENT".localized
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
