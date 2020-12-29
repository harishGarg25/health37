//
//  TextFieldDelegate.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 7/18/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

extension NewApptTableViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}


