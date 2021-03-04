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
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            mainView.semanticContentAttribute = .forceRightToLeft
            upgradeField.textAlignment = .right
            upgradeView.semanticContentAttribute = .forceRightToLeft
            arrowIcon.semanticContentAttribute = .forceRightToLeft
        }
        subscriptionInformationUpdate()
    }
    
    func subscriptionInformationUpdate()
    {
        cancelButton.isHidden = true
        upgradeView.isHidden = false
        if let detail = self.getDataInLocal(fileName : "profile_data") as? NSMutableArray
        {
            if let detailDict = detail[0] as? [String : Any]
            {
                if let imgUrl = detailDict["user_avatar"] as? String
                {
                    let url = URL.init(string: "\(imgUrl)")
                    print("imgUrl&&&URL", imgUrl)
                    self.userImage.sd_setImage(with: url, placeholderImage: UIImage.init(named: "imagePlace.png"), options: .refreshCached, completed: { (img, error, cacheType, url) in
                        self.userImage.sd_removeActivityIndicator()
                    })
                }
                
                nameLable.text = detailDict[kFullName] as? String
                let started = "\(detailDict["package_months"] as? String ?? "") "//(\(detailDict["sub_start_date"] as? String ?? ""))
                subscriptionPeriodLable.text = started
                subscribeValidTillLable.text =  detailDict["sub_expiry_date"] as? String
                if let is_free_sub_applied = detailDict["is_free_sub_applied"] as? String ?? "0"
                {
                    if is_free_sub_applied == "1"
                    {
                        if let is_payment_done = detailDict["is_payment_done"] as? Int ?? 0
                        {
                            //upgradeView.isHidden = is_payment_done == 0
                        }
                    }else
                    {
                        if let is_payment_done = detailDict["is_payment_done"] as? Int ?? 0
                        {
                            //upgradeView.isHidden = is_payment_done == 1
                        }
                    }
                }
            }
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
                self.cancelSubscription()
            }
        })
    }
    
    @IBAction func upgradebuttonAction(_ sender: Any)
    {
                let controller = PriceSelectionViewController.instantiate(fromAppStoryboard: .Appointment)
                self.navigationController?.pushViewController(controller, animated:true)
        
//        let controller = PriceSelectionViewController.instantiate(fromAppStoryboard: .Appointment)
//        self.navigationController?.pushViewController(controller, animated:true)
    }
    
    @objc func cancelSubscription()
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodCancelSubsciption, Details: self.addPostParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if let response = responseData?["response"] as? String, response == "1"
                    {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.onShowAlertController(title: "Error" , message: "Having some issue.Please try again.".localized)
                }
            }
        }
    }
    
    
    func addPostParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if  let userid : String = UserDefaults.standard.object(forKey: kUserID) as? String
        {
            dictUser.setObject(userid, forKey: "user_id" as NSCopying)
        }

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
 
}
