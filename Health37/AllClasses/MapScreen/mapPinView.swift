//
//  mapPinView.swift
//  EATAPP
//
//  Created by Parikshit on 22/06/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class mapPinView: UIViewController {
    
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    
    var imagePath = ""
    var imageProfile = ""
    var name = ""
    var address = ""
    var discount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.width/2
        imgUserProfile.layer.masksToBounds = true
        
        
        self.view.layer.cornerRadius = 3
        self.view.clipsToBounds = true
        
        self.imgCover.sd_addActivityIndicator()
        let url = URL.init(string: "\(String(describing: imagePath))")
        imgCover.sd_setImage(with: url, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
            self.imgCover.sd_removeActivityIndicator()
        })
        
        self.imgUserProfile.sd_addActivityIndicator()
        let url2 = URL.init(string: "\(String(describing: imageProfile))")
        imgUserProfile.sd_setImage(with: url2, placeholderImage: UIImage.init(named: "cover_place_holder.png"), options: .refreshCached, completed: { (img, error, cacheType, url2) in
            self.imgUserProfile.sd_removeActivityIndicator()
        })
        
        lblname.text = "\(name)"
        lblAddress.text = "\(address)"
        discountLabel.text = "\(discount.count == 0 ? "" : "-\(discount)%")"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
