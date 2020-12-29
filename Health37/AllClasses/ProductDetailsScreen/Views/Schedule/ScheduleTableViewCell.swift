//
//  ScheduleTableViewCell.swift
//  WLAppleCalendar
//
//  Created by willard on 2017/9/18.
//  Copyright © 2017年 willard. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLine: UIView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    
    var sectionDate = String()
    
    var schedule: [String : Any]! {
        didSet {
            titleLabel.text = (schedule["patient_name"] as? String ?? schedule["doctor_name"] as? String)?.capitalized
            noteLabel.text = (schedule["notes"] as? String ?? nil)?.capitalized
            startTimeLabel.text = (schedule["time_slot"] as? String ?? "").convertToStringDate()
            categoryLine.backgroundColor = schedule["status"] as? String ?? "1" == "1" ? .green : .red
            moreInfoButton.isHidden = schedule["status"] as? String ?? "1" == "1" ? false : true
        }
    }
}
