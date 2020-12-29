//
//  DropDown.swift
//  Appt
//
//  Created by user on 02/07/20.
//  Copyright © 2020 AgustinMendoza. All rights reserved.
//

import UIKit
class DropDown: UIView{
    
    @IBOutlet weak private var tableView: UITableView!
    var anchorView: UIView?
    
    var dataSet: [String] = []
    private let cellID = "cell"
    var selectionCallback : ((_ item: String,_ index: Int) -> ())?
    
    func setUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "", bundle: nil) , forCellReuseIdentifier: cellID)
    }
    
//    func add(anchorView: UIView){
//        self.anchorView = anchorView
//        var frameY: CGFloat = 0
//        let y = anchorView.frame.minY
//        let heightOfScreen = UIScreen.main.bounds.height
//        if heightOfScreen-y > y{
//            frameY =
//        }
//        else{
//            
//        }
//    }
    
}

extension DropDown: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSet.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionCallback?(dataSet[indexPath.row],indexPath.row)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
