//
//  AppDelegate.swift
//  Health37
//
//  Created by RamPrasad-IOS on 06/04/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SystemConfiguration
import Firebase
import FirebaseAuth
import FirebaseMessaging
import UserNotifications
import FBSDKLoginKit
import AVFoundation
import Photos
import GoogleSignIn
import SDWebImage


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate,MessagingDelegate  {
    
    var window: UIWindow?
    var currentLocation:CLLocation!
    let locationManager = CLLocationManager()
    var health37UserInfo : UserInfoH37!
    
    var  arrAllCategory = NSMutableArray()
    var  arrAllHomeCategory = NSMutableArray()
    
    var strUrlAuthanticateType = ""
    var currencyRates = [String : Any]()

    var navController = UINavigationController()
    var strDeviceLanguage = ""
    var strNotificationTotal = ""
    var strNotificationUPTo = ""
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //   SDWebImageManager.shared().imageDownloader?.maxConcurrentDownloads = 3
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        GMSServices.provideAPIKey(kGMSServiceApiKey)
        GMSPlacesClient.provideAPIKey(kGMSServiceApiKey)
        
        FirebaseApp.configure()
        self.registerForPushNotifications(application: application)
        
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge,.sound]) { (granted, error) in
                UNUserNotificationCenter.current().delegate = self
                // Enable or disable features based on authorization.
                if UserDefaults.standard.object(forKey: kLoginCheck) != nil && UserDefaults.standard.object(forKey: kLoginCheck) as! String == "Yes"
                {
                    self.methodNotificationCount()
                }
                
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            // Fallback on earlier versions
        }
        
        Messaging.messaging().delegate = self
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.makeKeyAndVisible()
        // let langCode = Locale.current.languageCode
        
        //        if  UserDefaults.standard.string(forKey: "applanguage") == nil
        //        {
        //let preferredLanguage = NSLocale.preferredLanguages[0] as String
        let langCode = Locale.current.languageCode
        if langCode == "ar"
        {
            UserDefaults.standard.set("ArabicDevice", forKey: "applanguageArabic")
        }
        else
        {
            UserDefaults.standard.set("EnglishDevice", forKey: "applanguageArabic")
            UserDefaults.standard.synchronize()
        }
        
        //print(preferredLanguage)
        // UserDefaults.standard.set(langCode, forKey: "applanguage")
        
        UserDefaults.standard.synchronize()
        //        }
        // print("Lan1",UserDefaults.standard.string(forKey: "applanguage"))
        getCurrentLocation()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 1/255, green: 152/255, blue: 159/255, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        if UserDefaults.standard.object(forKey: kLoginCheck) != nil && UserDefaults.standard.object(forKey: kLoginCheck) as! String == "Yes"
        {
            self.ShowMainviewController()
        }
        else
        {
            self.showFirstScreen()
        }
        
        return true
    }
    
    func showFirstScreen()
    {
        let login: LoginSignupScreen!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            login = LoginSignupScreen.init(nibName: "LoginSignupView_Arabic", bundle: nil)
        }
        else
        {
            login = LoginSignupScreen.init(nibName: "LoginSignupScreen", bundle: nil)
        }
        navController = UINavigationController(rootViewController: login)
        navController.setNavigationBarHidden(true, animated: false)
        
        window?.rootViewController = navController
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        //UserDefaults.standard.set(fcmToken, forKey: kDeviceToken)
        //let dict = ["device_token" : fcmToken]
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String : AnyObject] {
            if UserDefaults.standard.object(forKey: kLoginCheck) != nil && UserDefaults.standard.object(forKey: kLoginCheck) as! String == "Yes"
            {
                self.methodNotificationCount()
            }
        }
        completionHandler([.alert, .badge, .sound])
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo = response.notification.request.content.userInfo as? [String : AnyObject] {
            if UserDefaults.standard.object(forKey: kLoginCheck) != nil && UserDefaults.standard.object(forKey: kLoginCheck) as! String == "Yes"
            {
                if let aps = userInfo["aps"] as? NSDictionary {
                    if let alert = aps["alert"] as? NSDictionary {
                        if let title = alert["title"] as? String {
                            debugPrint(title)
                        }
                        if let body = alert["body"] as? String {
                            debugPrint(body)
                        }
                    }
                    if let screen_type = userInfo["notification_message_type"] as? String {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                            self.redirectToLinkedScreen(screenType: screen_type)
                        })
                    }
                }
                //self.methodNotificationCount()
            }
        }
        completionHandler()
    }
    
    //MARK: Notification Method
    func registerForPushNotifications(application: UIApplication)
    {
        if #available(iOS 10.0, *)
        {
            UNUserNotificationCenter.current().delegate = self
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                
                if (granted)
                {
                    DispatchQueue.main.async
                        {
                            UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                }
                else
                {
                    // Do stuff if unsuccessful...
                    UserDefaults.standard.set("SIMULATOR", forKey: kDeviceToken)
                    UserDefaults.standard.synchronize()
                }
            })
        }
            
        else
        {
            //If user is not on iOS 10 use the old methods we've been using
            
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound];
            let setting = UIUserNotificationSettings(types: type, categories: nil);
            UIApplication.shared.registerUserNotificationSettings(setting);
            UIApplication.shared.registerForRemoteNotifications();
            
        }
        
    }
    
    
    
    //    func initialize()
    //    {
    //
    //    FIROptions *firOptions = [[FIROptions alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"some-plist-name" ofType:@"plist"]];
    //    [FIRApp configureWithOptions:firOptions];
    //    }
    
    func ShowMainviewController()
    {
        let home : UIViewController;
        var LeftMenuViewController:UIViewController;
        var RightMenuViewController:UIViewController;
        
        //        let RightMenuViewController_AR:SidemenuScreen;
        //        let LeftMenuViewController_AR:SettingsScreen;
        
        
        //  let home: HomeViewController!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            
            RightMenuViewController = SidemenuScreen(nibName:"SidemenuScreen_Arabic",bundle: nil)
            LeftMenuViewController = SettingsScreen(nibName:"Settings_Arabic",bundle: nil)
            
            home = HomeViewController.init(nibName: "HomeViewController_Arabic", bundle: nil)
        }
        else
        {
            LeftMenuViewController = SidemenuScreen(nibName:"SidemenuScreen",bundle: nil)
            RightMenuViewController = SettingsScreen(nibName:"SettingsScreen",bundle: nil)
            home = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
        }
        
        
        LeftMenuViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        RightMenuViewController.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        // home  = HomeViewController(nibName:"HomeViewController",bundle: nil)
        let navigationC = UINavigationController(rootViewController: home)
        navigationC.setNavigationBarHidden(true, animated: false)
        
        
        let container: MFSideMenuContainerViewController = MFSideMenuContainerViewController .container(withCenter: navigationC, leftMenuViewController: LeftMenuViewController, rightMenuViewController: RightMenuViewController)
        
        container.panMode = MFSideMenuPanModeNone
        
        container.leftMenuWidth = UIScreen.main.bounds.size.width-80
        container.rightMenuWidth = UIScreen.main.bounds.size.width-120
        
        container.shadow.enabled = true
        
        navController = UINavigationController(rootViewController: container)
        navController.setNavigationBarHidden(true, animated: false)
        
        self.window!.rootViewController = navController
//        if let rootWindow = self.window {
//            let screenSize = DeviceType.iPhoneX.getSize()
//            Projector.display(rootWindow: rootWindow, testingSize: screenSize)
//        }
    }
    
    //MARK: - User Location Methods
    func getCurrentLocation()
    {
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    //MARK: -  Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let arrayOfLocation = locations as NSArray
        let location = arrayOfLocation.lastObject as? CLLocation
        //        let coordLatLon = location.coordinate
        //        print("locations = \(coordLatLon.latitude) \(coordLatLon.longitude)")
        //            ?
        
        currentLocation = location
        
        print("currentLocation = ",currentLocation)
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        
        print(error)
    }
    ////MARK : Global Helping Methods
    func saveCurrentUser(dictResult : NSDictionary)
    {
        //    let userDtls = UserInfoH37.init(dict: dictResult)
        
        //  let userDefaults = UserDefaults.standard
        //  let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: userDtls)
        //   userDefaults.set(encodedData, forKey: kCurrentUser)//kCurrentUser
        //  userDefaults.synchronize()
    }
    
    // func getloginUser() -> UserInfoH37
    //   {
    //   let userDefaults = UserDefaults.standard
    //   let decoded  = userDefaults.object(forKey: kCurrentUser) as! Data
    //    let fUser : UserInfoH37 = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! UserInfoH37
    
    //  return fUser
    //   }
    func logoutAndClearDefaults()
    {
        self.showFirstScreen()
        self.health37UserInfo = nil
        var StrToken = ""
        if UserDefaults.standard.object(forKey: kDeviceToken) != nil {
            
            StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
        }
        UserDefaults.standard.clearAll()
        UserDefaults.standard.set(StrToken, forKey: kDeviceToken)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Socialtype-----------%@",url)
        if self.strUrlAuthanticateType == "FACEBOOK"
        {
            let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            return handled
        }
        else
        {
            if #available(iOS 9.0, *) {
                var _: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                              UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation as AnyObject]
            } else {
                // Fallback on earlier versions
            }
            return GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        if url.scheme?.localizedCaseInsensitiveCompare("com.release.braintreepayments") == .orderedSame {
//            return BTAppSwitch.handleOpen(url, options: options)
//        }
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        UserDefaults.standard.set(token, forKey: kDeviceToken)
        print(token)
        
        Messaging.messaging().apnsToken = deviceToken as Data
        
        //  Auth.auth().setAPNSToken(deviceToken, type: .unknown)
        // Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        print("Failed to register:", error)
        
        UserDefaults.standard.set("simulator", forKey: kDeviceToken)
        
        UserDefaults.standard.synchronize()
    }
    
    func redirectToLinkedScreen(screenType :String)  {
        
        /*
         addGroupPost == 1
         addNewGroup == 2
         likeUnlike == 3
         addComments == 4
         followUser == 5
         addMessages == 6
         */
        
        if let topController = UIApplication.topViewController()
        {
            if let controller = NavigateScreen.controller(screenType){
                topController.navigationController?.pushViewController(controller, animated: true)
                //                if topController.view.restorationIdentifier != controller.view.restorationIdentifier
                //                {
                //
                //                topController.navigationController?.pushViewController(controller, animated: true)`
                //                }
            }
        }
    }
    
    // MARK:- updateProfile API Integration...
    func getAddDeviceParams() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
        var StrToken = "simulator"
        
        if UserDefaults.standard.object(forKey: kDeviceToken) != nil {
            StrToken = UserDefaults.standard.object(forKey: kDeviceToken) as! String
        }
        
        // dictUser.setObject(StrToken1, forKey: kDeviceId as NSCopying)
        dictUser.setObject(StrToken, forKey: kDeviceToken as NSCopying)
        dictUser.setObject(kDeviceName, forKey: kDeviceType as NSCopying)
        
        return dictUser
    }
    // MARK:- Get Category API Integration.................
    @objc func methodAddDeviceAPI()
    {
        //let dictParameters = NSDictionary()
        getallApiResultwithGetMethod(strMethodname: kMethodAddDevices, Details: getAddDeviceParams()) { (responseData, error) in
            print("getAddDeviceParams()", self.getAddDeviceParams())
            if error == nil
            {
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    print("responseData",responseData!)
                }
                else
                {
                    if responseData?.object(forKey: "message") as? String == "User not exist."
                    {
                        self.logoutAndClearDefaults()
                    }
                    print("responseData",responseData!)
                }
            }
        }
    }
    
    // MARK:- Get Category API Integration.................
    @objc func methodGetCategoryApi()
    {
        let dictParameters = NSDictionary()
        getallApiResultwithGetMethod(strMethodname: kMethodGetCategory, Details: dictParameters) { (responseData, error) in
            if error == nil
            {
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    print("responseData",responseData!)
                    self.arrAllCategory = (responseData?.object(forKey: kUserSavedDetails)as!NSArray).mutableCopy() as! NSMutableArray
                    print("arrAllCategory",self.arrAllCategory)
                    //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHomeData"), object: nil)
                    
                }
                else
                {
                    if responseData?.object(forKey: "message") as? String == "User not exist."
                    {
                        self.logoutAndClearDefaults()
                    }
                    print("responseData",responseData!)
                    //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                }
            }
        }
    }
    
    // MARK:- Get Category API Integration.................
    @objc func methodGetCategoryHomeApi()
    {
        let dictParameters = NSDictionary()
        getallApiResultwithGetMethod(strMethodname: kMethodGetCategoryHome, Details: dictParameters) { (responseData, error) in
            if error == nil
            {
                if (responseData != nil) && responseData?.object(forKey: "response") as! String
                    == "1"
                {
                    // print("responseData",responseData!)
                    self.arrAllHomeCategory = (responseData?.object(forKey: kUserSavedDetails)as!NSArray).mutableCopy() as! NSMutableArray
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHomeData"), object: nil)
                }
                else
                {
                    if responseData?.object(forKey: "message") as? String == "User not exist."
                    {
                        self.logoutAndClearDefaults()
                    }
                    print("responseData",responseData!)
                    //self.onShowAlertController(title: "Error" , message: responseData?.object(forKey: "message")! as! String?)
                }
            }
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.performSelector(inBackground: #selector(self.methodGetCategoryApi), with: nil)
        self.performSelector(inBackground: #selector(self.methodGetCategoryHomeApi), with: nil)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if UserDefaults.standard.object(forKey: kLoginCheck) != nil && UserDefaults.standard.object(forKey: kLoginCheck) as! String == "Yes"
        {
            self.performSelector(inBackground: #selector(self.methodAddDeviceAPI), with: nil)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Check Internet Connection
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    func NotificaionPermissionCheck()
    {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .authorized
                {
                    // Already authorized
                }
                else {
                    // Either denied or notDetermined
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                        (granted, error) in
                        // add your own
                        UNUserNotificationCenter.current().delegate = self
                        let alertController = UIAlertController(title: "Notification Alert", message: "please enable notifications", preferredStyle: .alert)
                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                })
                            }
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        alertController.addAction(cancelAction)
                        alertController.addAction(settingsAction)
                        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                        
                    }
                }
            }
        } else {
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                print("APNS-YES")
            } else {
                let alertController = UIAlertController(title: "Notification Alert", message: "please enable notifications", preferredStyle: .alert)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            })
                        } else {
                            UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(settingsAction)
                self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    func getNotificationCounts() -> NSMutableDictionary
    {
        let dictUser = NSMutableDictionary()
        dictUser.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
        
        return dictUser
    }
    // MARK:- Get NotificationCount Integration.................
    @objc func methodNotificationCount()
    {
        //let dictParameters = NSDictionary()
        getallApiResultwithGetMethod(strMethodname: kMethodNotificationCount, Details: getNotificationCounts()) { (responseData, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    
                    //                    self.hideActivity()
                    if (responseData != nil) && responseData?.object(forKey: "response") as! String
                        == "1"
                    {
                        print("responseData",responseData!)
                        if responseData?.valueForNullableKey(key: "new") != "" && (responseData?.valueForNullableKey(key: "new") as! NSString).intValue > 0
                        {
                            self.strNotificationTotal = responseData?.valueForNullableKey(key: "new")as! String
                            self.strNotificationUPTo = responseData?.valueForNullableKey(key: "upto") as! String
                            
                            print("NotiTotal",self.strNotificationTotal)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateNoficationCounts"), object: nil)
                            
                            //                            self.viewNotificationCount.isHidden = false
                        }
                        else
                        {
                            //                            self.viewNotificationCount.isHidden = true
                        }
                        //                        self.strNotifcationUPTO = responseData?.valueForNullableKey(key: "upto") as! String
                        
                        
                        //                        print("From",self.strTabbarClick)
                        //                        if  self.strTabbarClick == "FromNotification"
                        //                        {
                        //                            if self.appDelegate.isInternetAvailable() == true
                        //                            {
                        //                                let dicDetails = NSMutableDictionary()
                        //                                dicDetails.setObject(UserDefaults.standard.object(forKey: kUserID)!, forKey: kUserID as NSCopying)
                        //                                dicDetails.setObject(self.strNotifcationUPTO, forKey: "upto" as NSCopying)
                        //
                        //                                self.performSelector(inBackground: #selector(self.methodAddNotificationCount), with: dicDetails)
                        //                            }
                        //                        }
                        
                    }
                    else
                    {
                        //                        self.viewNotificationCount.isHidden = true
                    }
                }
            }
        }
    }
    
    //MARK: -LocationGetPermission
    func checkLocationGetPermission()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                print("Location services are not enabled")
                let alert = UIAlertController(title: "Health37", message: "Device location off! \n Switch on your device location.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ENABLE LOCATION", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                        break
                    case .cancel:
                        print("cancel")
                        break
                    case .destructive:
                        print("destructive")
                        break
                    }
                }))
                alert.addAction(UIAlertAction(title: "NO, THANKS!", style: UIAlertActionStyle.cancel, handler: nil))
                // show the alert
                window?.rootViewController?.present(alert, animated: true, completion: nil)
                //self.present(alert, animated: true, completion: nil)
                break
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
            }
        }
        else
        {
            print("Location services are not enabled")
            let alert = UIAlertController(title: "Health37", message: "Device location off! \n Switch on your device location.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ENABLE LOCATION", style: .default, handler: { action in
                switch action.style{
                case .default:
                    UIApplication.shared.openURL(URL(string:UIApplicationOpenSettingsURLString)!)
                    break
                case .cancel:
                    print("cancel")
                    break
                case .destructive:
                    print("destructive")
                    break
                }
            }))
            alert.addAction(UIAlertAction(title: "NO, THANKS!", style: UIAlertActionStyle.cancel, handler: nil))
            // show the alert
            window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func checkCameraPermission(completionHandler:@escaping (Bool) -> ())
    {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            completionHandler(true)
            // Already Authorized
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    completionHandler(true)
                    // User granted
                } else {
                    //                    self.TabLogin.selectedIndex = self.selectTab
                    
                    completionHandler(false)
                    let alert:UIAlertController=UIAlertController(title: "Permissions", message: "App doesn't have camera access permissions. Please go to settings and allow Health37 for camera access permissions.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    alert.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
                    {
                        UIAlertAction in
                        
                    }
                    // Add the actions
                    alert.addAction(cancelAction)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    // User Rejected
                }
            })
        }
    }
    
    func checkGalleryPermission(completionHandler:@escaping (Bool) -> ())
    {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        // check the status for PHAuthorizationStatusAuthorized or ALAuthorizationStatusDenied e.g
        if status == PHAuthorizationStatus.notDetermined
        {
            PHPhotoLibrary.requestAuthorization({ (statusinner) in
                if statusinner != PHAuthorizationStatus.authorized {
                    //show alert for asking the user to give permission
                    completionHandler(false)
                    let alert:UIAlertController=UIAlertController(title: "Permissions", message: "App doesn't have gallery access permissions. Please go to settings and allow Health37 for gallery access permissions.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                            return
                        }
                        
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                    alert.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
                    {
                        UIAlertAction in
                    }
                    // Add the actions
                    alert.addAction(cancelAction)
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
                else
                {
                    completionHandler(true)
                }
            })
        }
        else if status != PHAuthorizationStatus.authorized {
            //show alert for asking the user to give permission
            completionHandler(false)
            let alert:UIAlertController=UIAlertController(title: "Permissions", message: "App doesn't have gallery access permissions. Please go to settings and allow Health37 for gallery access permissions.", preferredStyle: UIAlertControllerStyle.alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            alert.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
            {
                UIAlertAction in
            }
            // Add the actions
            alert.addAction(cancelAction)
            self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        else
        {
            completionHandler(true)
        }
        
    }
}


enum NavigateScreen: String {
    
    case AddGroupPost = "1"
    case AddNewGroup = "2"
    case LikeUnlike = "3"
    case Comment = "4"
    case Follow = "5"
    case Message = "6"
    case Appointment = "7"
    case Appointments = "8"
    case Appointmentss = "9"

    var controller: UIViewController {
        
        let language: String!
        if UserDefaults.standard.object(forKey: "applanguage") != nil  && UserDefaults.standard.object(forKey: "applanguage") as! String == "ar"
        {
            language  = "ar"
        }
        else
        {
            language  = "en"
        }
        
        switch self {
        case .AddGroupPost:
            return GroupScreen(nibName: language == "en" ? "GroupScreen" : "GroupScreen_Arabic", bundle: nil)
        case .AddNewGroup:
            return GroupScreen(nibName: language == "en" ? "GroupScreen" : "GroupScreen_Arabic", bundle: nil)
        case .LikeUnlike:
            return GroupScreen(nibName: language == "en" ? "GroupScreen" : "GroupScreen_Arabic", bundle: nil)
        case .Comment:
            return GroupScreen(nibName: language == "en" ? "GroupScreen" : "GroupScreen_Arabic", bundle: nil)
        case .Follow:
            return HomeSearchScreen(nibName: language == "en" ? "HomeSearchScreen" : "HomeSearchScreen_AR", bundle: nil)
        case .Message:
            return TimelineScreen(nibName: language == "en" ? "TimelineScreen" : "Timeline_Arabic", bundle: nil)
        case .Appointment:
            let controller = DoctorAppointmentsTableViewController.instantiate(fromAppStoryboard: .Appointment)
            return controller
        case .Appointments:
            let controller = DoctorAppointmentsTableViewController.instantiate(fromAppStoryboard: .Appointment)
            return controller
        case .Appointmentss:
            let controller = DoctorAppointmentsTableViewController.instantiate(fromAppStoryboard: .Appointment)
            return controller
        }
    }
    
    static func controller(_ screenName: String) -> UIViewController? {
        return NavigateScreen(rawValue: screenName.replacingOccurrences(of: "-", with: ""))?.controller
    }
}







//Health37 Client ID:
//
//Email : drsalbum@outlook.sa     [use Id for Login Itunes]
//Password : Zayed2020$


// These delegate methods MUST live in App Delegate and nowhere else!


