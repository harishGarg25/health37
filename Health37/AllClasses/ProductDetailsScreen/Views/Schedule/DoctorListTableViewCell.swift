//
//  DoctorListTableViewCell.swift
//  WLAppleCalendar
//
//  Created by willard on 2017/9/18.
//  Copyright © 2017年 willard. All rights reserved.
//

import UIKit

class DoctorListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioLable: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    var sectionDate = String()
    
    override func prepareForReuse() {
        cardView.setNeedsDisplay()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.setNeedsDisplay()
        setBorder()
    }
    
    func setBorder() {
        cardView.layer.cornerRadius = 8.0
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowOpacity = 0.2
        cardView.layer.shadowRadius = 2
        cardView.clipsToBounds = false
        cardView.layer.masksToBounds = false
        cardView.backgroundColor = .white
    }
    
    var detail: [String : Any]! {
        didSet {
            nameLabel.text = (detail["full_name"] as? String ?? "")?.capitalized
            typeLabel.text = (detail["category_name"] as? String ?? nil)?.capitalized
            bioLable.text = (detail["user_brief"] as? String ?? nil)?.capitalized
            let url = URL.init(string: "\(detail["User_image"] as? String ?? "")")
            profilePicture.sd_setImage(with: url, placeholderImage: UIImage.init(named: "plaeholder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                self.profilePicture.sd_removeActivityIndicator()
            })
            
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
            {
                bioLable.textAlignment = .right
            }
            else
            {
                bioLable.textAlignment = .left
            }
            cardView.setNeedsDisplay()
            cardView.layoutIfNeeded()
        }
    }
}
