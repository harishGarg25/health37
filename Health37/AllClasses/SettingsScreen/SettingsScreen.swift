//
//  SettingsScreen.swift
//  Health37
//
//  Created by RamPrasad-IOS on 09/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class SettingsScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //IBOutlets
    @IBOutlet var tblSettings: UITableView!
    @IBOutlet var viewChangeLangPopup: UIView!
    
    @IBOutlet var viewPopupBG: UIView!
    ///NSArray For Title & Images
    var arr_img  = NSArray()
    var arr_tittle = NSArray()
    @IBOutlet var btnArebic: UIButton!
    @IBOutlet var btnEnglish: UIButton!
    
    @IBOutlet var btnOk: UIButton!
    @IBOutlet var btnCancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            self.arr_tittle = ["Languages".localized,"Terms and conditions".localized, "Privacy policy".localized]
            
            btnCancel.setTitle("CANCEL".localized, for: .normal)
            btnOk.setTitle("OK".localized, for: .normal)
            btnArebic.isSelected = true
        }
        else
        {
            btnEnglish.isSelected = true
            self.arr_tittle = ["Languages","Terms & Conditions", "Privacy policy"]
        }
        
        self.arr_img =  ["langugage_icon_drawer","terms_icon_drawer","terms_icon_drawer"]
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateHomeScreenData), name: NSNotification.Name(rawValue: "updateHomeData"), object: nil)
    }
    
    @objc func updateHomeScreenData()
    {
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            //            self.arr_tittle = ["اللغات","البنود و الظروف","سياسة الخصوصية"]
            self.arr_tittle = ["Languages".localized,"Terms and conditions".localized, "Privacy policy".localized]
        }
        else
        {
            self.arr_tittle = ["Languages", "Terms & Conditions", "Privacy policy"]
        }
        
        self.arr_img =  ["langugage_icon_drawer","terms_icon_drawer","terms_icon_drawer"]
        
        tblSettings.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func methodSelectLanguage(_ sender: UIButton)
    {
        btnEnglish.isSelected = false
        btnArebic.isSelected = false
        
        if sender.tag == 0
        {
            btnEnglish.isSelected = true
        }
        else
        {
            btnArebic.isSelected = true
        }
        // sender.isSelected = !sender.isSelected
    }
    @IBAction func methodCancelSubmit(_ sender: UIButton)
    {
        if sender.tag == 11
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHomeData"), object: nil)
            
            if (btnEnglish.isSelected == true) && (UserDefaults.standard.object(forKey: "applanguage") as! String == "ar")
            {
                UserDefaults.standard.set("en", forKey: "applanguage")
                self.changeLanguagePassAPI(language: "en")
            }
            else if (btnArebic.isSelected == true) && (UserDefaults.standard.object(forKey: "applanguage") as! String == "en")
            {
                
                UserDefaults.standard.set("ar", forKey: "applanguage")
                self.changeLanguagePassAPI(language: "ar")
            }
        }
        appDelegate.ShowMainviewController()
    }
    
    // MARK : UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arr_tittle.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cellIdentifier:String = "CustomFields"
        var cell : SideMenuCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? SideMenuCell
        if (cell == nil)
        {
            let nib:Array<Any>!
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                nib = Bundle.main.loadNibNamed("SideMenuCell_AR", owner: nil, options: nil)!
            }
            else
            {
                nib = Bundle.main.loadNibNamed("SideMenuCell", owner: nil, options: nil)! as [Any]
            }
            cell = nib[0] as? SideMenuCell
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
            cell?.backgroundColor = (UIColor.clear);
        }
        
        cell?.lbl_Name.frame = CGRect.init(x: (cell?.lbl_Name.frame.origin.x)! - 10, y:  (cell?.lbl_Name.frame.origin.y)!, width:  (cell?.lbl_Name.frame.size.width)!, height:  (cell?.lbl_Name.frame.size.height)!)
        
        cell?.lbl_Name.font = UIFont.init(name: "Lato-Regular", size: 14.0)
        
        cell?.lbl_Name.text = (arr_tittle.object(at: indexPath.row)) as? String
        cell?.img_icon.image = UIImage(named: arr_img.object(at: indexPath.row) as! String)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row {
        case 0:
            self.menuContainerViewController.setMenuWidth(0.0, animated: false)
            let window = UIApplication.shared.keyWindow!
            window.addSubview(viewChangeLangPopup)
            viewChangeLangPopup.frame = window.frame
            break
        case 1:
            let demoController = WebViewScreen(nibName: "WebViewScreen",bundle: nil)
            demoController.strWebURLFrom = "TermsAndCond"
            self.appDelegate.navController.pushViewController(demoController, animated: false)
            self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
            })
            break
        case 2:
            let demoController = WebViewScreen(nibName: "WebViewScreen",bundle: nil)
            demoController.strWebURLFrom = "PrivacyPolicy"
            self.appDelegate.navController.pushViewController(demoController, animated: false)
            self.menuContainerViewController .setMenuState(MFSideMenuStateClosed, completion: { () -> Void in
            })
            break
        default:
            break
        }
    }

    func changeLanguagePassAPI(language : String)
    {
        if  let userid = "\(UserDefaults.standard.object(forKey: kUserID)!)" as? String
        {
            let params = ["serviceName":kChangeLanguage,"default_language":language,"user_id":userid]
            getAllApiResults(Details:  params as NSDictionary , srtMethod: kChangeLanguage) { (responseData, error) in
                
            }
        }
    }
    
}
