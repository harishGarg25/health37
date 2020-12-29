//
//  UserInfoH37.swift
//  Health37
//
//  Created by Ramprasad on 24/09/18.
//  Copyright © 2018 Anveshan It Solutions. All rights reserved.
//

import UIKit

class UserInfoH37: NSObject, NSCoding {

    var strUserID        = ""

    var strUserName         = ""
    var strEmail            = ""
    var strPassword         = ""
    var strNumber          = ""
    var strAddress              = ""
    var strCountry_code     = ""
    var strFull_name           = ""
    var strProfile_picture     = ""
    var strGender              =  ""
    var strLatitude              =  ""
    var strLongitude             =  ""
    var strSecurity_token      = ""
    var strIsPrivate        = ""
    var strItemsCount       = ""
    var strFollowerCount    = ""
    var strFavCounts        = ""

    override init() {
        
    }
    
    //MARK:- NSCoding
    required init?(coder aDecoder: NSCoder) {
        

        strFull_name = aDecoder.decodeObject(forKey: kName) as! String
        strEmail = aDecoder.decodeObject(forKey:kEmail) as! String
        strUserID = aDecoder.decodeObject(forKey:kUserID) as! String

        strUserName = aDecoder.decodeObject(forKey:kUsername) as! String
//        strLatitude = aDecoder.decodeObject(forKey:kLatitude) as! String
//        strLongitude = aDecoder.decodeObject(forKey:kLongitude) as! String

    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(strFull_name, forKey: kName)
       aCoder.encode(strUserID, forKey: kUserID)
        aCoder.encode(strEmail, forKey: kEmail)
        aCoder.encode(strUserName, forKey: kUsername)
//        aCoder.encode(strLatitude, forKey: kLatitude)
//        aCoder.encode(strLongitude, forKey: kLongitude)
    }
    
    init(dict : NSDictionary)
        
    {
        if dict.object(forKey: kName) != nil && !(dict.object(forKey: kName) is NSNull) {
            strFull_name = dict.object(forKey: kName) as! String
        }

        if dict.object(forKey: kEmail) != nil && !(dict.object(forKey: kEmail) is NSNull) {
            strEmail = dict.object(forKey: kEmail) as! String
        }
        if dict.object(forKey: kUsername) != nil && !(dict.object(forKey: kUsername) is NSNull) {
            strUserName = dict.object(forKey: kUsername) as! String
        }
//        if dict.object(forKey: kLatitude) != nil && !(dict.object(forKey: kLatitude) is NSNull) {
//            strLatitude = dict.object(forKey: kLatitude) as! String
//        }
//        if dict.object(forKey: kLongitude) != nil && !(dict.object(forKey: kLongitude) is NSNull) {
//            strLongitude = dict.object(forKey: kLongitude) as! String
//        }
        if dict.object(forKey: kUserID) != nil && !(dict.object(forKey: kUserID) is NSNull) {
            strUserID = dict.object(forKey: kUserID) as! String
          //  strUserID = String(format: "%d", dict.object(forKey: kUserID) as! NSNumber)
        }
        
    }
}

