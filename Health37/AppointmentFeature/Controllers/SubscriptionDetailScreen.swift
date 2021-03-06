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
        getSubscriptionDetailAPI()
    }
    
    func subscriptionInformationUpdate()
    {
        cancelButton.isHidden = true
        if let detail = self.getDataInLocal(fileName : "profile_data") as? NSMutableArray
        {
            debugPrint(detail)
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
    
    @objc func getSubscriptionDetailAPI()
    {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kGetSubscriptionDetail, Details: self.addPostParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    self.upgradeView.isHidden = false
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                    {
                        debugPrint(responseData ?? "")
                        if  let subscriptionDetail = responseData?["user_data"] as? [String : Any]
                        {
                            let started = "\(subscriptionDetail["package_months"] as? String ?? "") "
                            self.subscriptionPeriodLable.text = started
                            self.subscribeValidTillLable.text =  subscriptionDetail["validtill_date"] as? String
                            if let is_payment_done = subscriptionDetail["is_applied_paid"] as? Int
                            {
                                self.upgradeView.isHidden = is_payment_done == 1
                            }
                        }
                    }
                    else
                    {
                        self.hideActivity()
                        self.onShowAlertController(title: "" , message: responseData?.object(forKey: "message")! as! String?)
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
 
}
