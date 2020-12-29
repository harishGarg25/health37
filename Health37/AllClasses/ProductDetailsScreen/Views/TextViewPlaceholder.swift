//
//  TextViewPlaceholder.swift
//  Appt
//


import UIKit

extension UITextView: UITextViewDelegate {
  
  override open var bounds: CGRect {
    didSet {
      self.resizePlaceholder()
    }
  }
  
  public var placeholder: String? {
    get {
      var placeholderText: String?
      
      if let placeholderLabel = self.viewWithTag(100) as? UILabel {
        placeholderText = placeholderLabel.text
      }
      
      return placeholderText
    }
    set {
      if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
        placeholderLabel.text = newValue
        placeholderLabel.sizeToFit()
      } else {
        self.addPlaceholder(newValue!)
      }
    }
  }
  
  public func textViewDidChange(_ textView: UITextView) {
    if let placeholderLabel = self.viewWithTag(100) as? UILabel {
      placeholderLabel.isHidden = self.text.count > 0
    }
  }
  
  private func resizePlaceholder() {
    if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
      let labelX = self.textContainer.lineFragmentPadding
      let labelY = self.textContainerInset.top - 2
      let labelWidth = self.frame.width - (labelX * 2)
      let labelHeight = placeholderLabel.frame.height
      
      placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: UIScreen.main.bounds.size.width-30, height: labelHeight)
    }
  }
  
  private func addPlaceholder(_ placeholderText: String) {
    let placeholderLabel = UILabel()
    //placeholderLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-30, height: 25)
    placeholderLabel.text = placeholderText
    placeholderLabel.sizeToFit()
    placeholderLabel.font = self.font
    placeholderLabel.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
    placeholderLabel.tag = 100
    if UserDefaults.standard.object(forKey: "applanguage") != nil  && (UserDefaults.standard.object(forKey: "applanguage") as? String ?? "") == "ar"
    {
        //placeholderLabel.semanticContentAttribute = .forceRightToLeft
        placeholderLabel.textAlignment = .right
    }
    else
    {
        //placeholderLabel.semanticContentAttribute = .forceLeftToRight
        placeholderLabel.textAlignment = .left
    }
    placeholderLabel.isHidden = self.text.count > 0
    
    self.addSubview(placeholderLabel)
    self.resizePlaceholder()
    self.delegate = self
  }
    
    
  
}

class AllowedCharsTextField: UITextField, UITextFieldDelegate {
    
   @IBInspectable var allowedChars: String = ""
          
          required init?(coder aDecoder: NSCoder) {
              super.init(coder: aDecoder)
              delegate = self
              autocorrectionType = .no
          }
          
          func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
              guard string.count > 0 else {
                  return true
              }
              let currentText = textField.text ?? ""
              let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
              return prospectiveText.containsOnlyCharactersIn(matchCharacters: allowedChars)
          }
}
