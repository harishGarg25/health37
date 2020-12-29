//
//  SlotsCollectionViewCell.swift
//  Appt
//
//  Created by user on 02/07/20.
//  Copyright © 2020 AgustinMendoza. All rights reserved.
//

import UIKit

class SlotsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func selectCell(){
        
        containerView.backgroundColor = Color.theme
        titleLbl.textColor = UIColor.white
        subtitleLbl.textColor = UIColor.white.withAlphaComponent(0.4)
    }
    func deSelectCell(){
        
        containerView.backgroundColor = UIColor.white
        titleLbl.textColor = Color.theme
        subtitleLbl.textColor = Color.theme.withAlphaComponent(0.7)
    }
    
    func configure(with slot: Slot){
        titleLbl.text = slot.title.localized
        subtitleLbl.text = slot.descrition.localized
        //seperatorView.backgroundColor = Color.theme
        containerView.borderColor = Color.theme
        containerView.borderWidth = 1
    }
}

