//
//  TextViewDelegate.swift
//  Appt
//
//  Created by Agustin Mendoza Romo on 7/18/17.
//  Copyright © 2017 AgustinMendoza. All rights reserved.
//

import UIKit

extension NewApptTableViewController:  UITextViewDelegate {
  
  func setTextViewDelegates(){
  }
  
  func textViewShouldReturn(_ textField: UITextView) -> Bool {
    self.view.endEditing(true)
    return false
  }
}

extension NewApptTableViewController {
  
  func setDoneOnKeyboard() {
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.sizeToFit()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(NewApptTableViewController.dismissKeyboard))
    keyboardToolbar.items = [flexBarButton, doneBarButton]
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
