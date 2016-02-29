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
    
    var lastSelectedIndexPath : NSIndexPath?
   
    @IBOutlet var switchItem: UIBarButtonItem!
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
    
    var AddressListOrigin2 : [ContractsItem]?
    
    
    private var filesNms : [String]?
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
            }else{
                CiaNmArray = nil
                CiaNm = nil
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
        static let DraftCellIdentifier : String = "AddressDraft Cell Identifier"
        static let ActionTitleAddendumC : String = "Addendum C"
        static let ActionTitleClosingMemo : String = "Closing Memo"
        static let ActionTitleDesignCenter : String = "Design Center"
        static let ActionTitleContract : String = "Contract"
        static let ActionThirdPartyFinancingAddendum : String = "Third Party Financing Addendum"
    }
    
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tag = 2
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
                    if tableView.tag == 2 {
                        return $0.cianame!.lowercaseString.containsString(txt)
                            || $0.assignsales1name!.lowercaseString.containsString(txt)
                            || $0.nproject!.lowercaseString.containsString(txt)
                            || $0.client!.lowercaseString.containsString(txt)
                    }else{
                        return $0.cianame!.lowercaseString.containsString(txt)
                            || $0.nproject!.lowercaseString.containsString(txt)
                    }
                    
                }
            }
        }else{
            AddressList = AddressListOrigin
        }
        
    }

    // MARK: - Table view data source
    override func tableView(tableView1: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView.tag == 2 {
            let  heada = AddressListViewHeadView(frame: CGRect(x: 0, y: 0, width: tableView1.frame.width, height: 44))
            let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
            heada.CiaNmLbl.text = ddd?.first?.cianame ?? ""
            return heada
        }else{
            return nil
        }
       
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1 {
            let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
            return ddd?.first?.cianame ?? ""
        }else{
            return nil
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CiaNm?.count ?? 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CiaNmArray?[CiaNm?[section] ?? ""]!.count ?? 0
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.tag == 2 ? 66 : 30
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
        if tableView.tag == 2{
             cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            if let cellitem = cell as? AddressListViewCell {
                let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
                cellitem.contractInfo = ddd![indexPath.row]
                
            }
            
            
            
            
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier(constants.DraftCellIdentifier, forIndexPath: indexPath)
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            if let cellitem = cell as? AddressDraftListViewCell {
                let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
                cellitem.contractInfo = ddd![indexPath.row]
            }
        }
        if let indexa = tableView.indexPathForSelectedRow{
            if indexa == indexPath{
                cell.contentView.backgroundColor = CConstants.SearchBarBackColor
            }else{
                cell.contentView.backgroundColor = UIColor.whiteColor()
            }
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
    
    func GoToPrint(modelNm: [String]) {
         self.filesNms = modelNm
//        if modelNm.count == 1 {
//            callService(modelNm)
//        }else{
            if modelNm.contains(CConstants.ActionTitleAddendumC){
                callService(modelNm)
            }else{
                self.performSegueWithIdentifier(CConstants.SegueToPrintPdf, sender: modelNm)
            }
//        }
        
        

    }
    
    // go to print Addendum C signature
//    private func doAddendumCAction(_ : UIAlertAction) -> Void {
//        callService(CConstants.AddendumCServiceURL)
//    }
//    // go to print ClosingMemo
//    private func doClosingMemoAction(_ : UIAlertAction) -> Void {
//        callService(CConstants.ClosingMemoServiceURL)
//    }
//    // go to print DesignCenter
//    private func doDesignCenterAction(_ : UIAlertAction) -> Void {
//        callService(CConstants.DesignCenterServiceURL)
//    }
//    // go to print Contract signature
//    private func doContractAction(_ : UIAlertAction) -> Void {
//        callService(CConstants.ContractServiceURL)
//    }
//    private func doThirdPartyFinancingAddendumAction(_: UIAlertAction) -> Void{
//        callService(CConstants.AddendumAServiceURL)
//    }
    
    private func callService(printModelNms: [String]){
        var serviceUrl: String?
        var printModelNm : String
        if printModelNms.count == 1 {
            printModelNm = printModelNms[0]
        }else{
            printModelNm = constants.ActionTitleAddendumC
        }
        switch printModelNm{
        case CConstants.ActionTitleAddendumC:
            serviceUrl = CConstants.AddendumCServiceURL
       
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
//                                            if printModelNms.count == 1 {
//                                                let rtn = ContractAddendumC(dicInfo: rtnValue)
//                                                self.performSegueWithIdentifier(CConstants.SegueToAddendumC, sender: rtn)
//                                            }else{
                                                let rtn = ContractAddendumC(dicInfo: rtnValue)
                                                self.performSegueWithIdentifier(CConstants.SegueToPrintPdf, sender: rtn)
//                                            }
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
    
    
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        removebackFromCell()
        if let cell  = tableView.cellForRowAtIndexPath(indexPath) {
        cell.contentView.backgroundColor = CConstants.SearchBarBackColor
        }
        
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        if let cell  = tableView.cellForRowAtIndexPath(indexPath) {
            lastSelectedIndexPath = indexPath
            cell.contentView.backgroundColor = .clearColor()
        }
        
    }

    private func removebackFromCell(){
        if let _ = lastSelectedIndexPath {
            if let cell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath!){
                cell.contentView.backgroundColor = .clearColor()
            }
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        removebackFromCell()
    }
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        removebackFromCell()
        if let selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath){
            lastSelectedIndexPath = indexPath
            selectedCell.contentView.backgroundColor = CConstants.SearchBarBackColor
        }
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
           
            case CConstants.SegueToPrintPdf:
                if let controller = segue.destinationViewController as? PDFPrintViewController {
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
                        controller.filesArray = self.filesNms
                        controller.page2 = false
//                        controller.initWithResource(CConstants.PdfFileNameContract)
                        return
                    }
                    if let info = sender as? ContractAddendumC {
                        controller.pdfInfo0 = info
                        controller.addendumCpdfInfo = info
                        var itemList = [[String]]()
                        var i = 0
                        if let list = info.itemlist {
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
                        controller.addendumCpdfInfo!.itemlistStr = itemList
                        controller.AddressList = self.AddressListOrigin
                        controller.filesArray = self.filesNms
//                        let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
                        
                        controller.page2 = i > 19
//                        controller.initWithResource(pass)
                        
                    }
                    
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
        
        
        let loginUserInfo = LoginUser(email: email!, password: password!, iscontract:  (self.tableView.tag == 2 ? "1" : "0"))
        
        let a = loginUserInfo.DictionaryFromObject()
        Alamofire.request(.POST, CConstants.ServerURL + CConstants.LoginServiceURL, parameters: a).responseJSON{ (response) -> Void in
            if response.result.isSuccess {
                if let rtnValue = response.result.value as? [String: AnyObject]{
                    let rtn = Contract(dicInfo: rtnValue)
                    
                    if rtn.activeyn == 1{
                        if (self.tableView.tag == 2 && userInfo.boolForKey(CConstants.UserInfoIsContract)) || (self.tableView.tag == 1 && !userInfo.boolForKey(CConstants.UserInfoIsContract) ){
                            self.AddressListOrigin = rtn.contracts
                        }
                        
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
            self.switchItem.enabled = true
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
    @IBAction func toSwitch(sender: UIBarButtonItem){
//        self.view.backgroundColor = UIColor.whiteColor()
        //to print draft
        sender.enabled = false
        if sender.tag == 2 {
            sender.tag = 1
            self.tableView.tag = 1
            sender.title = "Print Contract"
            
        }else{
            sender.tag = 2
            self.tableView.tag = 2
            sender.title = "Print Draft"
        }
        let tmp = AddressListOrigin2
        AddressListOrigin2 = AddressListOrigin
        AddressListOrigin = tmp
        self.refreshControl?.endRefreshing()
        NSUserDefaults.standardUserDefaults().setBool(self.tableView.tag == 2, forKey: CConstants.UserInfoIsContract)
        UIView.transitionFromView(tableView, toView: tableView, duration: 0.8, options: [.TransitionFlipFromRight, .ShowHideTransitionViews], completion: { (_) -> Void in
            //                self.getTrackList()
            
            self.tableView.reloadData()
            if tmp == nil {
                self.tableView.setContentOffset(CGPoint(x: 0, y: -self.refreshControl!.frame.height*2), animated: true)
                self.refreshAddressList(self.refreshControl!)
            }else{
                sender.enabled = true
            }
            
        })
        
    }
        
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.hidesBarsOnSwipe = true
        let userinfo = NSUserDefaults.standardUserDefaults()
        userinfo.setValue(nil, forKey: CConstants.UserInfoPrintModel)
        
//        self.extendedLayoutIncludesOpaqueBars = true
//        self.edgesForExtendedLayout = .None
//        self.automaticallyAdjustsScrollViewInsets = true
        
    }
    
    

}
