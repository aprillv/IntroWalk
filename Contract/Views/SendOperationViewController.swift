//
//  SendOperationViewController.swift
//  Contract
//
//  Created by April on 12/22/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

protocol DoOperationDelegate
{
    
    func  saveAndRewalk()
    func  saveAndClose()
}


class SendOperationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate1 : DoOperationDelegate?
    var showRewalk : Bool?
    var showClose : Bool?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var itemList : [String]?{
        didSet{
            if let _ = itemList{
                tableView.reloadData()
            }
        }
    }
    
    
    private struct constants{
        static let cellReuseIdentifier = "operationCellIdentifier"
        static let rowHeight : CGFloat = 44
        static let operationRewalk = "Finish & Rewalk"
        static let operationClose = "Finish & Close"
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if showRewalk == nil {
            showRewalk = true
        }
        if showClose == nil {
            showClose = true
        }
        itemList = [constants.operationRewalk, constants.operationClose]
//        if showRewalk! && showClose! {
//        itemList = [constants.operationRewalk, constants.operationClose]
//        }else if showRewalk! {
//        itemList = [constants.operationRewalk]
//        }else if showClose! {
//        itemList = [constants.operationClose]
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return constants.rowHeight
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellReuseIdentifier, for: indexPath)
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = itemList![indexPath.row]
        if (indexPath.row == 0 && showRewalk! ) || (indexPath.row == 1 && showClose! ) {
            cell.textLabel?.textColor = UIColor.black
        }else{
            cell.textLabel?.textColor = UIColor.darkGray
        }
        
        cell.textLabel?.textAlignment = .center
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true){
            if let delegate0 = self.delegate1{
                switch self.itemList![indexPath.row]{
                    case constants.operationRewalk:
                        if self.showRewalk! {
                            delegate0.saveAndRewalk()
                        }
                case constants.operationClose:
                    if self.showClose! {
                        delegate0.saveAndClose()
                    }
                    default:
                        break
                }
                
                
            }
        }
        
        
    }
    
    override var preferredContentSize: CGSize {
        get {
//            print(tableView.frame.width)
            return CGSize(width: tableView.frame.width
                , height: constants.rowHeight * CGFloat(itemList?.count ?? 1))
        }
        set { super.preferredContentSize = newValue }
    }
    
}
