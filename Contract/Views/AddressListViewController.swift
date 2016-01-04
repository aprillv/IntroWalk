//
//  AdressListViewController.swift
//  Contract
//
//  Created by April on 11/19/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class AddressListViewController: UITableViewController, UISearchBarDelegate {
    
    private  var spinner : UIActivityIndicatorView?
    private var progressBar: UIAlertController?
    
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

        if let cellitem = cell as? AddressListViewCell {
            let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
            cellitem.contractInfo = ddd![indexPath.row]
            cell.separatorInset = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 8)
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
    
    private func callService(serviceUrl: String){
        if let indexPath = tableView.indexPathForSelectedRow {
            
            if (spinner == nil){
                spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 4, width: 50, height: 50))
                spinner?.hidesWhenStopped = true
                spinner?.activityIndicatorViewStyle = .Gray
            }
            
            progressBar = UIAlertController(title: nil, message: CConstants.RequestMsg, preferredStyle: .Alert)
            progressBar?.view.addSubview(spinner!)
            spinner?.startAnimating()
            self.presentViewController(progressBar!, animated: true, completion: nil)
            
            let ddd = self.CiaNmArray?[self.CiaNm?[indexPath.section] ?? ""]
            let item: ContractsItem = ddd![indexPath.row]
            
            
            self.spinner?.startAnimating()
            Alamofire.request(.POST,
                CConstants.ServerURL + serviceUrl,
                parameters: ContractRequestItem(contractInfo: item).DictionaryFromObject()).responseJSON{ (response) -> Void in
                    self.progressBar?.dismissViewControllerAnimated(true){ () -> Void in
                        self.spinner?.stopAnimating()
                        if response.result.isSuccess {
                            
                            if let rtnValue = response.result.value as? [String: AnyObject]{
                                if let msg = rtnValue["message"] as? String{
                                    if msg.isEmpty{
                                        switch serviceUrl {
                                        case CConstants.AddendumCServiceURL:
                                            let rtn = ContractAddendumC(dicInfo: rtnValue)
                                            rtn.code = item.code
                                            self.performSegueWithIdentifier(CConstants.SegueToAddendumC, sender: rtn)
                                        case CConstants.ClosingMemoServiceURL:
                                            let rtn = ContractClosingMemo(dicInfo: rtnValue)
                                            rtn.code = item.code
                                            self.performSegueWithIdentifier(CConstants.SegueToClosingMemo, sender: rtn)
                                        case CConstants.DesignCenterServiceURL:
                                            let rtn = ContractDesignCenter(dicInfo: rtnValue)
                                            rtn.code = item.code
                                            self.performSegueWithIdentifier(CConstants.SegueToDesignCenter, sender: rtn)
                                        case CConstants.ContractServiceURL:
                                            let rtn = ContractSignature(dicInfo: rtnValue)
                                            self.performSegueWithIdentifier(CConstants.SegueToSignaturePdf, sender: rtn)
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
                            self.spinner?.stopAnimating()
                            self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                        }
                    }
            }
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        
        let addendumCAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionTitleAddendumC), style: .Default, handler: doAddendumCAction)
        let closingMemoAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionTitleClosingMemo), style: .Default, handler: doClosingMemoAction)
        let designCenterAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionTitleDesignCenter), style: .Default, handler: doDesignCenterAction)
        let contractAction: UIAlertAction = UIAlertAction(title: getLongString(constants.ActionTitleContract), style: .Default, handler: doContractAction)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(addendumCAction)
        alert.addAction(closingMemoAction)
        alert.addAction(designCenterAction)
        alert.addAction(contractAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case CConstants.SegueToSignaturePdf:
                    if let controller = segue.destinationViewController as? PDFSignViewController {
                        controller.pdfInfo = sender as? ContractSignature
                        controller.initWithResource("BaseContract.pdf")
                    }
            case CConstants.SegueToClosingMemo:
                if let controller = segue.destinationViewController as? ClosingMemoViewController {
                    controller.pdfInfo = sender as? ContractClosingMemo
                    controller.initWithResource("ClosingMemo.pdf")
                }
            case CConstants.SegueToDesignCenter:
                if let controller = segue.destinationViewController as? DesignCenterViewController {
                    controller.pdfInfo = sender as? ContractDesignCenter
                    controller.initWithResource("DesignCenter.pdf")
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
                    
                    let pass = i > 19 ? "AddendumC2.pdf" : "AddendumC.pdf"
                    
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
    
}
