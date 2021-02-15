//
//  ChangePasswordViewController.swift
//  BURST
//
//  Created by Administrator on 3/14/17.
//  Copyright © 2017 Administrator. All rights reserved.
//

import UIKit

class ManageCouponViewController: UIViewController, UITextFieldDelegate
{
    
    // MARK:- Properties
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var couponSwitch: UISwitch!
    @IBOutlet weak var couponCodeLabel: UILabel!
    @IBOutlet weak var couponDiscountLabel: UILabel!
    @IBOutlet weak var discountSlider: UISlider!
    @IBOutlet weak var discountField: UITextField!
    
    // MARK:- Class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage Discount".localized
        label1.text = label1.text?.localized
        label2.text = label2.text?.localized
        
        if #available(iOS 11.0, *) {
            mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else {
            mainScrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        }
        let logoutBarButtonItem = UIBarButtonItem(title: "Save".localized, style: .done, target: self, action: #selector(saveTapped))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        self.navigationItem.addSettingButtonOnRight(title: "Back")
        
        getCouponDetail()
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            couponDiscountLabel.textAlignment = .left
            discountField.textAlignment = .left
        }
        else
        {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            couponDiscountLabel.textAlignment = .right
            discountField.textAlignment = .right
        }
    }
    
    @objc func saveTapped(){
        discountField.text = discountField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if(discountField.text?.count == 0) || (discountField.text?.toInt() ?? 0 < 10)
        {
            self.showAlert(message: "Please Select Coupon Discount and it should be above or equal to 10%.".localized)
        }
        else
        {
            self.showActivity(text: "")
            makeUpdateCouponDetail()
        }
    }
    
    
    // MARK:- Button Actions
    
    @IBAction func charityModeSwitch(_ sender: Any)
    {
        
    }
    
    @IBAction func discountSlider(_ sender: UISlider) {
        let formattedValue = String(format: "\(("\(sender.value)" as NSString).intValue)")
        debugPrint(formattedValue)
        couponDiscountLabel.text = "%\(formattedValue)"
    }
    
    @IBAction func shareCoupon(_ sender: Any) {
        let firstActivityItem = "\("Coupon Code:".localized) \(couponCodeLabel.text ?? "")"
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - TextField Delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    // MARK:- Api Methods
    
    func makeUpdateCouponDetail() {
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodManageDiscountCoupon, Details: getProfileParams()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String == "1"
                    {
                        let alertController = UIAlertController(title: "", message: "Discount setting updated".localized as String?, preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "OK".localized, style: .default) { (action) -> Void in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                        alertController.addAction(yesAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else
                    {
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
    
    func getCouponDetail() {
        
        let dictUser = NSMutableDictionary()
        if UserDefaults.standard.object(forKey: kUserID) != nil
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        }
        self.showActivity(text: "")
        getallApiResultwithGetMethod(strMethodname: kMethodGetCoupon, Details: dictUser) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        if let coupon_data = responseData?.object(forKey: "coupon_data") as? [Any]
                        {
                            if let data = coupon_data[0] as? [String : Any]
                            {
                                self.couponCodeLabel.text = data["coupon_code"] as? String ?? ""
                                self.discountField.text = "\(data["discount_amount"] as? String ?? "10")"
                                //self.discountSlider.value = (data["discount_amount"] as? NSString ?? "10").floatValue
                                if let enableValue : String = data["coupon_status"] as? String
                                {
                                    self.couponSwitch.setOn(enableValue.toInt() == 1 ? false : true, animated: false)
                                }
                            }
                        }
                    }
                    else
                    {
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
                                                                                                               
    func getProfileParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        if UserDefaults.standard.object(forKey: kUserID) != nil
        {
            dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        }
        dictUser.setObject(self.discountField.text ?? "", forKey: "discount_amount" as NSCopying)
        dictUser.setObject(couponSwitch.isOn ? "0" : "1", forKey: "coupon_status" as NSCopying)
        
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
    
    // MARK:- TextFields Methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = textField.text!.count + string.count - range.length
        if (textField == discountField)
        {
            let updatedText = textField.text! + string
            if newLength > 3
            {
                self.showAlert(message: "Please Select Coupon Discount and it should be above or equal to 10%.".localized)
                return false
            }else
            {
                if updatedText.toInt() > 100
                {
                    self.showAlert(message: "Please Select Coupon Discount and it should be above or equal to 10%.".localized)
                    return false
                }
            }
            return newLength > 3 ? false : true
        }
        return true
    }
    
}
