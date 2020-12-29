//
//  ChooseLanguageScreen.swift
//  Health37
//
//  Created by Ramprasad on 17/09/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class ChooseLanguageScreen: UIViewController {

    @IBOutlet var btnArebic: UIButton!
    @IBOutlet var btnEnglish: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        btnEnglish.isSelected = false
        btnArebic.isSelected = false

        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
           // btnEnglish.setTitle("English".localized, for: .normal)
            btnCancel.setTitle("CANCEL".localized, for: .normal)
            btnSubmit.setTitle("SUBMIT".localized, for: .normal)
            btnArebic.isSelected = true
        }
        else
        {
            btnEnglish.isSelected = true
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.title = "Change Language"
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodBack(_:)))
        
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
       }
        else
        {
            self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "menu")
        }
    }
        @objc override func methodSideMenu(_ sender : UIButton)
        {
            if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
            {
                self.menuContainerViewController.toggleRightSideMenuCompletion
                    { () -> Void in
                }
            }
            else
            {
                self.menuContainerViewController.toggleLeftSideMenuCompletion
                    { () -> Void in
                }
            }
            self.view.endEditing(true)

       }
    
    // MARK: - UIButtonsMethod

    @IBAction func methodSelectLanguage(_ sender: UIButton)
    {
        btnEnglish.isSelected = false
        btnArebic.isSelected = false
        
        if sender.tag == 0
        {
            UserDefaults.standard.set("en", forKey: "applanguage")
            btnCancel.setTitle("CANCEL", for: .normal)
            btnSubmit.setTitle("SUBMIT", for: .normal)

           btnEnglish.isSelected = true
        }
        else
        {
            UserDefaults.standard.set("ar", forKey: "applanguage")
            btnCancel.setTitle("CANCEL".localized, for: .normal)
            btnSubmit.setTitle("SUBMIT".localized, for: .normal)

         btnArebic.isSelected = true
        }
        
        UserDefaults.standard.synchronize()

      //  sender.isSelected = !sender.isSelected
    }
    @IBAction func methodCancelSubmit(_ sender: UIButton)
    {
        if sender.tag == 11
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHomeData"), object: nil)
        }
        else
        {
            if btnEnglish.isSelected == true
            {
                UserDefaults.standard.set("en", forKey: "applanguage")
            }
            else
            {
                UserDefaults.standard.set("ar", forKey: "applanguage")
            }
        }
        appDelegate.ShowMainviewController()
    }

        
//        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
//        {
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "menu"), style: .done, target: self, action: #selector(methodSideMenu(_:)))
//            self.menuContainerViewController.toggleRightSideMenuCompletion
//                { () -> Void in
//            }
//             self.navigationItem.leftBarButtonItem = nil
//        }
//        else
//        {
//            self.navigationItem.rightBarButtonItem = nil
//            self.navigationBarWithBackButton(strTitle: "", leftbuttonImageName: "menu")
//            self.menuContainerViewController.toggleLeftSideMenuCompletion
//                { () -> Void in
//            }
//        }
 //   }
    

}
