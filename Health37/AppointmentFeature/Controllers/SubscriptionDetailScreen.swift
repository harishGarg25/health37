//
//  LoginSignupScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class SubscriptionDetailScreen: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var subscribeLable: UILabel!
    @IBOutlet weak var subscriptionPeriodLable: UILabel!
    @IBOutlet weak var subscribeValidLable: UILabel!
    @IBOutlet weak var subscribeValidTillLable: UILabel!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var upgradeField: UITextField!
    @IBOutlet weak var upgradeView: UIView!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Subscription Detail".localized
        subscribeLable.text = "Subscribed to:".localized
        subscribeValidLable.text = "Subscription valid till:".localized
        cancelButton.setTitle("Cancel Subscription".localized, for: .normal)
        upgradeField.text = upgradeField.text?.localized

        let backItem = self.navigationItem.backButtonOnRight(title: "Back")
        backItem.addTarget(self, action: #selector(backTapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem  =  UIBarButtonItem(customView: backItem)
                        
        cancelButton.layer.cornerRadius = 20.0
        cancelButton.layer.cornerRadius = 20.0
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor.init(red: 1/255.0, green: 152/255.0, blue: 159/255.0, alpha: 1.0).cgColor
        
        if let imgUrl = UserDefaults.standard.object(forKey: "profileImage")
        {
            let url = URL.init(string: "\(imgUrl)")
            print("imgUrl&&&URL", imgUrl)
            self.userImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                self.userImage.sd_removeActivityIndicator()
            })
        }
        
        let strUserName = UserDefaults.standard.object(forKey: kFullName) as? String
        nameLable.text = strUserName
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            mainView.semanticContentAttribute = .forceRightToLeft
            upgradeField.textAlignment = .right
            upgradeView.semanticContentAttribute = .forceRightToLeft
            arrowIcon.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @objc func backTapped(sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Picker Cancel
    @IBAction func cancelButton(_ sender: Any)
    {
        self.showOptionAlert(title: "Alert".localized, message: "Are you sure you want to cancel the Subscription?".localized, button1Title: "Yes".localized, button2Title: "No".localized, completion: { (success) in
            if success
            {
                
            }
        })
    }
    
    @IBAction func upgradebuttonAction(_ sender: Any)
    {
        let controller = PriceSelectionViewController.instantiate(fromAppStoryboard: .Appointment)
        self.navigationController?.pushViewController(controller, animated:true)
    }
    
    func addPostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
        {
            dictUser.setObject(userid, forKey: "created_by" as NSCopying)
        }
        dictUser.setObject(UserDefaults.standard.hospital_name ?? "", forKey: "hospital_name" as NSCopying)

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            dictUser.setObject("ar", forKey: "language" as NSCopying)
        }
        else
        {
            dictUser.setObject("en", forKey: "language" as NSCopying)
        }
        return dictUser
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
