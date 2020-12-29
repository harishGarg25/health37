//
//  Extension+Storyboard.swift
//  DenNetwork
//
//  Created by Harish on 11/09/19.
//  Copyright © 2019 Harish. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    
    case Appointment
    case Tabbar
    case Sidemenu
    case Account
    case Services
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}


extension UIViewController {
    // Not using static as it wont be possible to override to provide custom storyboardID then
    class var storyboardID : String {
        return "\(self)"
    }
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func PushToScreen(screen:UIViewController){
        self.navigationController?.pushViewController(screen, animated: true)
    }
    
    func performSegueToReturnBack()
    {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func showAlert(message:String)
    {
        let alertController = UIAlertController.init(title: "Alert".localized, message: message, preferredStyle: .alert)
        let action1 = UIAlertAction.init(title: "OK".localized, style: .default) { (Continue) in
            self.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showOptionAlert(title:String,message:String,button1Title:String,button2Title:String,completion:@escaping (_ isSuccess:Bool)->Void)
    {
        
        let alertController = UIAlertController.init(title: title.isEmpty ? nil : title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction.init(title: button1Title, style: .default) { (Continue) in
            completion(true)
        }
        
        let action2 = UIAlertAction.init(title: button2Title, style: .default) { (Cancel) in
            completion(false)
        }
        
        if button1Title.count > 0
        {
            alertController.addAction(action1)
        }
        if button2Title.count > 0
        {
            alertController.addAction(action2)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UINavigationItem {
    func addSettingButtonOnRight(title : String){
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back-white@3x.png"), for: .normal)
        button.setTitle(" \(title.localized)", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        button.addTarget(self, action: #selector(gotSettingPage), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.leftBarButtonItem = barButton
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            button.imageView?.semanticContentAttribute = .forceRightToLeft
        }
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
        {
            button.semanticContentAttribute = .forceRightToLeft
        }
    }
    
    @objc func gotSettingPage(){
        if let topController = UIApplication.topViewController()
        {
            topController.navigationController?.popViewController(animated: true)
        }
    }
    
    func backButtonOnRight(title : String) -> UIButton{
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back-white@3x.png"), for: .normal)
        button.setTitle(" \(title.localized)", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            button.imageView?.semanticContentAttribute = .forceRightToLeft
        }
        return button
    }
}

enum USER_STATE {
    static let LOGIN  = "1"
    static let DASHBOARD = "2"
}
