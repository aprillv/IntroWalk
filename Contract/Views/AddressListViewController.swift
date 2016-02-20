//
//  AdressListViewController.swift
//  Contract
//
//  Created by April on 11/19/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class AddressListViewController: UITableViewController, UISearchBarDelegate, ToDoPrintDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBAction func doLogout(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    var head : AddressListViewHeadView?
    var AddressListOrigin : [ContractsItem]?{
        didSet{
            AddressList = AddressListOrigin
        }
    }
    private var AddressList : [ContractsItem]? {
        didSet{
            AddressList?.sortInPlace(){$0.idcia < $1.idcia}
//            AddressList?
            
            if AddressList != nil{
                CiaNmArray = [String : [ContractsItem]]()
                var citems = [ContractsItem]()
                CiaNm = [String]()
                if let first = AddressList?.first{
                    var thetmp = first
                    for item in AddressList!{
                        
                        if thetmp.idcia != item.idcia {
                            CiaNmArray![thetmp.idcia!] = citems
                            CiaNm?.append(thetmp.idcia!)
                            thetmp = item
                            citems = [ContractsItem]()
                        }
                        citems.append(item)
                    }
                    
                    if citems.count > 0 {
                        CiaNmArray![thetmp.idcia!] = citems
                        CiaNm?.append(thetmp.idcia!)
                    }
                }
            }
            
            self.tableView?.reloadData()
        }
    }
    private var CiaNm : [String]?
    private var CiaNmArray : [String : [ContractsItem]]?
    
    
    @IBOutlet weak var LoginUserName: UIBarButtonItem!{
        didSet{
            let userInfo = NSUserDefaults.standardUserDefaults()
            LoginUserName.title = userInfo.objectForKey(CConstants.LoggedUserNameKey) as? String
        }
    }
    // MARK: - Constanse
    private struct constants{
        static let Title : String = "Address List"
        static let CellIdentifier : String = "Address Cell Identifier"
        static let ActionTitleAddendumC : String = "Addendum C"
        static let ActionTitleClosingMemo : String = "Closing Memo"
        static let ActionTitleDesignCenter : String = "Design Center"
        static let ActionTitleContract : String = "Contract"
        static let ActionThirdPartyFinancingAddendum : String = "Third Party Financing Addendum"
    }
    
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.title = constants.Title
        
        self.tableView.reloadData()
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    

    
    // MARK: - Search Bar Deleagte
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if let txt = searchBar.text?.lowercaseString{
            if txt.isEmpty{
                AddressList = AddressListOrigin
            }else{
                AddressList = AddressListOrigin?.filter(){
                    return $0.cianame!.lowercaseString.containsString(txt)
                        || $0.assignsales1name!.lowercaseString.containsString(txt)
                        || $0.nproject!.lowercaseString.containsString(txt)
                        || $0.client!.lowercaseString.containsString(txt)
                }
            }
        }else{
            AddressList = AddressListOrigin
        }
        
    }

    // MARK: - Table view data source
    override func tableView(tableView1: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  heada = AddressListViewHeadView(frame: CGRect(x: 0, y: 0, width: tableView1.frame.width, height: 44))
        let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
        heada.CiaNmLbl.text = ddd?.first?.cianame ?? ""
        return heada
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CiaNm?.count ?? 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CiaNmArray?[CiaNm?[section] ?? ""]!.count ?? 0
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        if let cellitem = cell as? AddressListViewCell {
            let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
            cellitem.contractInfo = ddd![indexPath.row]
            
        }
        
        return cell
    }
    
    private func getLongString(originStr : String) -> String{
        if originStr.characters.count < 16 {
            let tmp = "                "
            return originStr.stringByAppendingString(tmp.substringFromIndex(originStr.endIndex))
        }else{
            return originStr
        }
    }
    
    func GoToPrint(modelNm: String) {
        callService(modelNm)
        
        

    }
    
    // go to print Addendum C signature
    private func doAddendumCAction(_ : UIAlertAction) -> Void {
        callService(CConstants.AddendumCServiceURL)
    }
    // go to print ClosingMemo
    private func doClosingMemoAction(_ : UIAlertAction) -> Void {
        callService(CConstants.ClosingMemoServiceURL)
    }
    // go to print DesignCenter
    private func doDesignCenterAction(_ : UIAlertAction) -> Void {
        callService(CConstants.DesignCenterServiceURL)
    }
    // go to print Contract signature
    private func doContractAction(_ : UIAlertAction) -> Void {
        callService(CConstants.ContractServiceURL)
    }
    private func doThirdPartyFinancingAddendumAction(_: UIAlertAction) -> Void{
        callService(CConstants.AddendumAServiceURL)
    }
    
    private func callService(printModelNm: String){
        var serviceUrl: String?
        switch printModelNm{
        case CConstants.ActionTitleDesignCenter:
            serviceUrl = CConstants.DesignCenterServiceURL
//        case CConstants.ActionTitleAddendumA:
//            serviceUrl = CConstants.AddendumAServiceURL
        case CConstants.ActionTitleAddendumC:
            serviceUrl = CConstants.AddendumCServiceURL
        case CConstants.ActionTitleClosingMemo:
            serviceUrl = CConstants.ClosingMemoServiceURL
        case CConstants.ActionTitleContract:
            serviceUrl = CConstants.ContractServiceURL
//        case CConstants.ActionTitleThirdPartyFinancingAddendum:
//            serviceUrl = CConstants.AddendumAServiceURL
        case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
            self.performSegueWithIdentifier(CConstants.SegueToInformationAboutBrokerageServices, sender: nil)
            return
        default:
            serviceUrl = CConstants.AddendumAServiceURL
        }
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
           
            
            let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
            let item: ContractsItem = ddd![indexPath.row]
            
//            print(ContractRequestItem(contractInfo: item).DictionaryFromObject())
           self.noticeOnlyText(CConstants.RequestMsg)
            Alamofire.request(.POST,
                CConstants.ServerURL + serviceUrl!,
                parameters: ContractRequestItem(contractInfo: item).DictionaryFromObject()).responseJSON{ (response) -> Void in
                    self.clearNotice()
                        if response.result.isSuccess {
                            
                            if let rtnValue = response.result.value as? [String: AnyObject]{
                                if let msg = rtnValue["message"] as? String{
                                    if msg.isEmpty{
                                        switch printModelNm {
                                        case CConstants.ActionTitleAddendumC:
                                            let rtn = ContractAddendumC(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToAddendumC, sender: rtn)
                                        case CConstants.ActionTitleAddendumA:
                                            let rtn = AddendumA(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToAddendumA, sender: rtn)
                                        case CConstants.ActionTitleClosingMemo:
                                            let rtn = ContractClosingMemo(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToClosingMemo, sender: rtn)
                                        case CConstants.ActionTitleDesignCenter:
                                            let rtn = ContractDesignCenter(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToDesignCenter, sender: rtn)
                                        case CConstants.ActionTitleContract:
                                            let rtn = ContractSignature(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToSignaturePdf, sender: rtn)
                                        case CConstants.ActionTitleThirdPartyFinancingAddendum:
                                            let rtn = AddendumA(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToThridPartyFinacingAddendumPdf, sender: rtn)
                                        case CConstants.ActionTitleEXHIBIT_A:
                                            let rtn = AddendumA(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToExhibitA, sender: rtn)
                                        case CConstants.ActionTitleEXHIBIT_B:
                                            let rtn = AddendumA(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToExhibitB, sender: rtn)
                                        case CConstants.ActionTitleEXHIBIT_C:
                                            let rtn = AddendumA(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToExhibitC, sender: rtn)
                                        default:
                                            break;
                                        }
                                        
                                        
                                    }else{
                                        self.PopMsgWithJustOK(msg: msg)
                                    }
                                }else{
                                    self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                                }
                            }else{
                                self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                            }
                        }else{
//                            self.spinner?.stopAnimating()
                            self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                        }
                    }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let myCell = tableView.cellForRowAtIndexPath(indexPath) {
//            //Make the rect you want the popover to point at.
//            let  displayFrom = CGRectMake(myCell.frame.origin.x + myCell.frame.size.width, myCell.center.y + self.tableView.frame.origin.y - self.tableView.contentOffset.y, 1, 1)
//            
//            //Now move your anchor button to this location (again, make sure you made your constraints allow this)
//            self.popOverAnchorButton.frame = displayFrom;
//            self.performSegueWithIdentifier(CConstants.SegueToPrintModel, sender: myCell)
//        }
        
        
        
//        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
//        let contractAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionTitleContract), style: .Default, handler: doContractAction)
//        let ThirdPartyFinancingAddendumAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionThirdPartyFinancingAddendum), style: .Default, handler: doThirdPartyFinancingAddendumAction)
//        let addendumCAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionTitleAddendumC), style: .Default, handler: doAddendumCAction)
//        let closingMemoAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionTitleClosingMemo), style: .Default, handler: doClosingMemoAction)
//        let designCenterAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionTitleDesignCenter), style: .Default, handler: doDesignCenterAction)
//        
//        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        
//        alert.addAction(contractAction)
//        alert.addAction(ThirdPartyFinancingAddendumAction)
//        alert.addAction(addendumCAction)
//        alert.addAction(closingMemoAction)
//        alert.addAction(designCenterAction)
//        alert.addAction(cancelAction)
//        self.presentViewController(alert, animated: true, completion: nil)
       self.searchBar.resignFirstResponder()
        
        self.performSegueWithIdentifier(CConstants.SegueToPrintModel, sender: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case CConstants.SegueToPrintModel:
                
                if let controller = segue.destinationViewController as? PrintModelTableViewController {
                   controller.delegate = self
                }
                break
            case CConstants.SegueToSignaturePdf:
                    if let controller = segue.destinationViewController as? SignContractViewController {
                        controller.pdfInfo = sender as? ContractSignature
                        controller.AddressList = self.AddressListOrigin
                        controller.initWithResource(CConstants.PdfFileNameContract)
                    }
            case CConstants.SegueToClosingMemo:
                if let controller = segue.destinationViewController as? ClosingMemoViewController {
                    controller.AddressList = self.AddressListOrigin
                    controller.pdfInfo = sender as? ContractClosingMemo
                    controller.initWithResource(CConstants.PdfFileNameClosingMemo)
                }
            case CConstants.SegueToDesignCenter:
                if let controller = segue.destinationViewController as? DesignCenterViewController {
                    controller.AddressList = self.AddressListOrigin
                    controller.pdfInfo = sender as? ContractDesignCenter
                    controller.initWithResource(CConstants.PdfFileNameDesignCenter)
                }
            case CConstants.SegueToThridPartyFinacingAddendumPdf:
                if let controller = segue.destinationViewController as? ThirdPartyFinacingAddendumViewController {
                    controller.pdfInfo = sender as? AddendumA
                    controller.AddressList = self.AddressListOrigin
                    controller.initWithResource(CConstants.PdfFileNameThirdPartyFinancingAddendum)
                }
            case CConstants.SegueToAddendumA:
                if let controller = segue.destinationViewController as? AddendumAViewController {
                    controller.pdfInfo = sender as? AddendumA
                    controller.AddressList = self.AddressListOrigin
                    controller.initWithResource(CConstants.PdfFileNameAddendumA)
                }
            case CConstants.SegueToExhibitA:
                if let controller = segue.destinationViewController as? ExhibitAViewController {
                    controller.pdfInfo = sender as? AddendumA
                    controller.AddressList = self.AddressListOrigin
                    controller.initWithResource(CConstants.PdfFileNameEXHIBIT_A)
                }
            case CConstants.SegueToExhibitB:
                if let controller = segue.destinationViewController as? ExhibitBViewController {
                    controller.pdfInfo = sender as? AddendumA
                    controller.AddressList = self.AddressListOrigin
                    controller.initWithResource(CConstants.PdfFileNameEXHIBIT_B)
                }
            case CConstants.SegueToExhibitC:
                if let controller = segue.destinationViewController as? ExhibitCGeneralViewController {
//                    print(sender as? AddendumA)
//                    print(controller)
                    controller.AddressList = self.AddressListOrigin
                    controller.pdfInfo = sender as? AddendumA
                    controller.initWithResource(CConstants.PdfFileNameEXHIBIT_C)
                }
            case CConstants.SegueToInformationAboutBrokerageServices:
                if let controller = segue.destinationViewController as? InformationAboutBrokerageServicesViewController {
//                    controller.pdfInfo = sender as? AddendumA
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
                        let item: ContractsItem = ddd![indexPath.row]
                        let info = ContractPDFBaseModel(dicInfo: nil)
                        info.code = item.code
                        info.idcia = item.idcia
                        info.idproject = item.idproject
                        info.idnumber = item.idnumber
                        info.idcity = item.idcity
                        info.nproject = item.nproject
                        controller.pdfInfo0 = info
                        controller.AddressList = self.AddressListOrigin
                        controller.initWithResource(CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES)
                    }
                    
                }
            case CConstants.SegueToAddendumC:
                if let controller = segue.destinationViewController as? AddendumCViewController {
                    controller.pdfInfo = sender as? ContractAddendumC
                    var itemList = [[String]]()
                    var i = 0
                    if let list = controller.pdfInfo?.itemlist {
                        for items in list {
                            
                            var itemList1 = [String]()
                            let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
                            textView.scrollEnabled = false
                            textView.font = UIFont(name: "Verdana", size: 11.0)
                            textView.text = items.xdescription!
                            textView.sizeToFit()
                            textView.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, items.xdescription!.characters.count), usingBlock: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
                                if  let a : NSString = items.xdescription! as NSString {
                                    
                                    i++
                                    itemList1.append(a.substringWithRange(glyphRange))
                                }
                            })
//                            itemList1.append("april test")
                            itemList.append(itemList1)
                        }
                    }
                    controller.pdfInfo!.itemlistStr = itemList
                    controller.AddressList = self.AddressListOrigin
                    
                    let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
                    
                    controller.initWithResource(pass)
                }
            default:
                break;
            }
        }
    }

    @IBAction func refreshAddressList(sender: UIRefreshControl) {
        let userInfo = NSUserDefaults.standardUserDefaults()
        let email = userInfo.valueForKey(CConstants.UserInfoEmail) as? String
        let password = userInfo.valueForKey(CConstants.UserInfoPwd) as? String
        let loginUserInfo = LoginUser(email: email!, password: password!)
        
        let a = loginUserInfo.DictionaryFromObject()
        Alamofire.request(.POST, CConstants.ServerURL + CConstants.LoginServiceURL, parameters: a).responseJSON{ (response) -> Void in
            if response.result.isSuccess {
                if let rtnValue = response.result.value as? [String: AnyObject]{
                    let rtn = Contract(dicInfo: rtnValue)
                    
                    if rtn.activeyn == 1{
                        self.AddressListOrigin = rtn.contracts
                        sender.endRefreshing()
                    }else{
                        sender.endRefreshing()
                    }
                }else{
                    sender.endRefreshing()
                }
            }else{
                sender.endRefreshing()
            }
        }
        
    }
    
    private func PopMsgWithJustOK(msg msg1: String){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .Cancel) { Void in
            
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
}
