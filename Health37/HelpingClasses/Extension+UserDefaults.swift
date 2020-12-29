//
//  Extension.swift
//  DenNetwork
//
//  Created by Harish on 22/08/19.
//  Copyright © 2019 Harish. All rights reserved.
//

import Foundation

//MARK: Userdefaults
extension UserDefaults {
    
    var userType: String? {
        return string(forKey: "user_type")
    }
    
    func setUserType(_ authorization: String) {
        set(authorization, forKey: "user_type")
    }
    
    var getAppointmentStatus: String? {
        return string(forKey: "appointmentStatus")
    }
    
    func isAppointmentActive(_ authorization: String) {
        set(authorization, forKey: "appointmentStatus")
    }
    
    var user_id: String? {
        return string(forKey: "user_id")
    }
    
    func setUserID(_ authorization: String) {
        set(authorization, forKey: "user_id")
    }
    
    var cat_parent_id: String? {
        return string(forKey: "cat_parent_id")
    }
    
    func setParentCategory(_ authorization: String) {
        set(authorization, forKey: "cat_parent_id")
    }
    
    var hospital_name: String? {
        return string(forKey: "hospital_name")
    }
    
    func setHospitalName(_ authorization: String) {
        set(authorization, forKey: "hospital_name")
    }
    
    func clearAll() {
        let domain = Bundle.main.bundleIdentifier!
        removePersistentDomain(forName: domain)
        synchronize()
    }
}
