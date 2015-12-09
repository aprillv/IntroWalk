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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(tableView1: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  heada = AddressListViewHeadView(frame: CGRect(x: 0, y: 0, width: tableView1.frame.width, height: 44))
        let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
        heada.CiaNmLbl.text = ddd?.first?.cianame ?? ""
        return heada
    }
    
    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return CiaNm?.count ?? 1
    }
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        let ddd = CiaNmArray?[CiaNm?[section] ?? ""]
//        return ddd?.first?.cianame ?? ""
//        
//    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
//        let a = CiaNmArray?[CiaNm?[section] ?? ""]!.count ?? 0
//        print("\(a) \(CiaNm?[section])")
        return CiaNmArray?[CiaNm?[section] ?? ""]!.count ?? 0
//        return AddressList?.count ?? 0
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
       let item: ContractsItem = ddd![indexPath.row]
        if (spinner == nil){
            spinner = UIActivityIndicatorView(frame: CGRect(x: tableView.frame.midX - 25, y: tableView.frame.midY - 25, width: 50, height: 50))
            tableView.addSubview(spinner!)
            spinner?.hidesWhenStopped = true
            spinner?.center = tableView.center
            
        }
        
        spinner?.startAnimating()
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.ContractServiceURL,
            parameters: ContractRequestItem(contractInfo: item).DictionaryFromObject()).responseJSON{ (response) -> Void in
                self.spinner?.stopAnimating()
                if response.result.isSuccess {
                
                if let rtnValue = response.result.value as? [String: AnyObject]{
                    if let msg = rtnValue["message"] as? String{
                        if msg.isEmpty{
                            let rtn = ContractSignature(dicInfo: rtnValue)
//                            let pdfData = NSData(base64EncodedString: rtn.base64pdf!, options: NSDataBase64DecodingOptions(rawValue: 0))
//                            
//                            let pdfkey = rtn.idcia! + "_" + rtn.idcity!
//                            let pdfCoreData = cl_pdf()
                            self.performSegueWithIdentifier(CConstants.SegueToSignaturePdf, sender: rtn)
//                            if let _ = pdfCoreData.getPDFByKey(pdfkey){
//                                let pdfConr = PDFViewController(resource: "BaseContract.pdf")
//                                pdfConr.pdfInfo = rtn
//                                self.navigationController?.pushViewController(pdfConr, animated: true)
                            
//                            }else{
//                                let pdfConr = PDFViewController(data: pdfData)
//                                pdfConr.pdfInfo = response.result.value as! [String: String]
//                                self.navigationController?.pushViewController(pdfConr, animated: true)
//                            }
                            
                            
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == CConstants.SegueToSignaturePdf {
                if let controller = segue.destinationViewController as? PDFSignViewController {
                    controller.pdfInfo = sender as? ContractSignature
                    controller.initWithResource("BaseContract.pdf")
                }
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
