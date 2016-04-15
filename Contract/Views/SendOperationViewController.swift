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
    func saveToServer()
    func doPrint()
    func sendEmail()
    func clearDraftInfo()
    func fillDraftInfo()
    func save_Email()
}

class SendOperationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var delegate1 : DoOperationDelegate?
    var showSave : Bool?
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
        static let operationSavetoServer = "Save to Contract"
        static let operationPrint = "Print"
        static let operationEmail = "Email"
        static let operationSaveEmail = "Save & Email"
        static let operationClearDraftInfo = "Clear Buyer's Fields"
        static let operationFillDraftInfo = "Fill Buyer's Fields"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userinfo = NSUserDefaults.standardUserDefaults()
        if userinfo.boolForKey(CConstants.UserInfoIsContract){
            if showSave! {
                itemList = [constants.operationPrint, constants.operationEmail, constants.operationSavetoServer, constants.operationSaveEmail]
            }else{
                itemList = [constants.operationPrint, constants.operationEmail]
            }
           
        }else{
            if userinfo.integerForKey("ClearDraftInfo") == 0 {
                itemList = [constants.operationPrint, constants.operationEmail, constants.operationClearDraftInfo]
            }else {
                itemList = [constants.operationPrint, constants.operationEmail, constants.operationFillDraftInfo]
            }
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return constants.rowHeight
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = itemList![indexPath.row]
        cell.textLabel?.textAlignment = .Center
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true){
            if let delegate0 = self.delegate1{
                switch self.itemList![indexPath.row]{
                    case constants.operationSavetoServer:
                        delegate0.saveToServer()
                    case constants.operationPrint:
                        delegate0.doPrint()
                    case constants.operationEmail:
                        delegate0.sendEmail()
                case constants.operationFillDraftInfo:
                    delegate0.fillDraftInfo()
                case constants.operationClearDraftInfo:
                    delegate0.clearDraftInfo()
                case constants.operationSaveEmail:
                    delegate0.save_Email()
                    default:
                        break
                }
                
                
            }
        }
        
        
    }
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: tableView.frame.width, height: constants.rowHeight * CGFloat(itemList!.count))
        }
        set { super.preferredContentSize = newValue }
    }
    
}
