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
    func sendEmail2()
    func clearDraftInfo()
    func fillDraftInfo()
    func save_Email()
    func startover()
    func submit()
    func saveFinish()
    func saveEmail()
    func attachPhoto()
    func viewAttachPhoto()
    func emailContractToBuyer()
    
    func submitBuyer1Sign()
    func submitBuyer2Sign()
    
}

class SendOperationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    var contractInfo : ContractSignature?
//        {
//        didSet{
//        print(contractInfo?.verify_code, contractInfo?.verify_code2, contractInfo?.buyer1SignFinishedyn, contractInfo?.buyer2SignFinishedyn)
//        }
//    }
    
    @IBOutlet weak var tableView: UITableView!
    var delegate1 : DoOperationDelegate?
    var showSave : Bool?
    var FromWebSide : Bool?
    var showSubmit : Bool?
    var isapproved : Bool?
    var justShowEmail : Bool?
    var hasCheckedPhoto : String?
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
        static let operationSavetoServer = "Save Contract"
        static let operationSubmit = "Submit for Approve"
        static let operationStartOver = "Start Over"
        static let operationSaveFinish = "Save & Finish"
        static let operationSaveEmail = "Save & Email"
        static let operationEmail = "Email"
//        static let operationSaveEmail = "Save & Email"
        static let operationClearDraftInfo = "Clear Buyer's Fields"
        static let operationFillDraftInfo = "Fill Buyer's Fields"
        static let operationAttatchPhoto = "Attach Photo Check"
        static let operationViewAttatchPhoto = "View Photo Check"
        static let operationEmailToBuyer = "Email Contract to Buyers"
        
        static let operationSubmitBuyer1 = "Submit Buyer1's sign"
        static let operationSubmitBuyer2 = "Submit Buyer2's sign"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userinfo = NSUserDefaults.standardUserDefaults()
        if userinfo.boolForKey(CConstants.UserInfoIsContract){
            if justShowEmail! {
//            itemList = [constants.operationEmail, constants.operationViewAttatchPhoto]
                
                itemList = [constants.operationEmail]
            }else{
                if FromWebSide ?? false {
                    itemList = [constants.operationSubmit]
                }else{
                    if isapproved! {
                        itemList = [constants.operationSaveFinish, constants.operationSaveEmail, constants.operationStartOver]
                    }else{
                        itemList = [constants.operationSavetoServer, constants.operationSubmit, constants.operationStartOver]
                        itemList?.append(constants.operationAttatchPhoto)
                        if let info = self.contractInfo {
                            if info.client2 != "" {
                                itemList?.append(constants.operationSubmitBuyer1)
                                itemList?.append(constants.operationSubmitBuyer2)
                            }
                        }
                        itemList?.append(constants.operationEmailToBuyer)
                        
                    }
                }
                
//                itemList?.append(constants.operationEmailToBuyer)
            }
            
            
            
        }else{
            if userinfo.integerForKey("ClearDraftInfo") == 0 {
                itemList = [constants.operationEmail, constants.operationClearDraftInfo]
            }else {
                itemList = [constants.operationEmail, constants.operationFillDraftInfo]
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
        if (cell.textLabel?.text == constants.operationStartOver || cell.textLabel?.text == constants.operationSavetoServer) {
            if (!showSave!){
                cell.textLabel?.textColor = UIColor.darkGrayColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
        }
        
        if (cell.textLabel?.text == constants.operationSubmit || cell.textLabel?.text == constants.operationSaveFinish || cell.textLabel?.text == constants.operationSaveEmail) {
            if (!showSubmit!) {
                cell.textLabel?.textColor = UIColor.darkGrayColor()
            }else{
                cell.textLabel?.textColor = UIColor.blackColor()
            }
        }
        cell.accessoryType = .None
        if cell.textLabel?.text == constants.operationAttatchPhoto{
            if let c = self.hasCheckedPhoto {
                if c == "1" {
                    cell.accessoryView = UIImageView(image: UIImage(named: "check3"))
                }
            }
        }
        
        cell.textLabel?.textAlignment = .Center
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true){
            if let delegate0 = self.delegate1{
                switch self.itemList![indexPath.row]{
                    case constants.operationSavetoServer:
                        if self.showSave! {
                            delegate0.saveToServer()
                        }
//                    case constants.operationPrint:
//                        delegate0.doPrint()
                    case constants.operationEmail:
                        let userinfo = NSUserDefaults.standardUserDefaults()
                        if userinfo.boolForKey(CConstants.UserInfoIsContract){
                            delegate0.sendEmail2()
                        }else{
                            delegate0.sendEmail()
                        }
                    
                case constants.operationFillDraftInfo:
                    delegate0.fillDraftInfo()
                case constants.operationClearDraftInfo:
                    delegate0.clearDraftInfo()
                case constants.operationStartOver:
                    if self.showSave! {
                        delegate0.startover()
                    }
                case constants.operationSubmit:
                    if self.showSubmit! {
                        delegate0.submit()
                    }
                case constants.operationSaveFinish:
                    if self.showSubmit! {
                        delegate0.saveFinish()
                    }
                case constants.operationSaveEmail:
                    if self.showSubmit! {
                        delegate0.saveEmail()
                    }
                case constants.operationAttatchPhoto:
                    delegate0.attachPhoto()
                case constants.operationViewAttatchPhoto:
                    delegate0.viewAttachPhoto()
                    
                  
                case constants.operationEmailToBuyer:
                    delegate0.emailContractToBuyer()
                case constants.operationSubmitBuyer1:
                    delegate0.submitBuyer1Sign()
                case constants.operationSubmitBuyer2:
                    delegate0.submitBuyer2Sign()
                    default:
                        break
                }
                
                
            }
        }
        
        
    }
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: tableView.frame.width
                , height: constants.rowHeight * CGFloat(itemList!.count))
        }
        set { super.preferredContentSize = newValue }
    }
    
}
