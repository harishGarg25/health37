//
//  DropDownVC.swift
//  Appt
//
//  Created by user on 02/07/20.
//  Copyright © 2020 AgustinMendoza. All rights reserved.
//

import UIKit

class DropDownVC: UIViewController {
    @IBOutlet weak private var tableView: UITableView!
   var anchorView: UIView?
   
   var dataSet: [String] = []
   private let cellID = "cell"
   var selectionCallback : ((_ item: String,_ index: Int) -> ())?
   
   func setUI(){
       tableView.delegate = self
       tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
   }
    override func viewDidLoad() {
        super.viewDidLoad()
setUI()
    }
    
    static func show(present over: UIViewController, anchorView: UIView, dataSet: [String], selection : ((_ item: String,_ index: Int) -> ())?){
        let popUpViewController = UIStoryboard(name: "Appointment", bundle: nil).instantiateViewController(withIdentifier: "DropDownVC") as! DropDownVC
        
        popUpViewController.dataSet = dataSet
        popUpViewController.selectionCallback = selection
        popUpViewController.modalPresentationStyle = .popover
        let popoverc = popUpViewController.popoverPresentationController
        if let delegate = over as? UIPopoverPresentationControllerDelegate{
            popoverc?.delegate = delegate
        }
        else{
            fatalError("implement delegate in presented viewcontroller")
        }
        popoverc?.barButtonItem = UIBarButtonItem(customView: anchorView)
        over.present(popUpViewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        preferredContentSize = CGSize(width:160 , height: tableView.contentSize.height)
    }
}
extension DropDownVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSet.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = dataSet[indexPath.row]
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionCallback?(dataSet[indexPath.row],indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}



