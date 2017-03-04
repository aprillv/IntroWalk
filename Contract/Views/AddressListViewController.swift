//
//  AdressListViewController.swift
//  Contract
//
//  Created by April on 11/19/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class AddressListViewController: UITableViewController, UISearchBarDelegate, UITextFieldDelegate{
    
    
    
    @IBOutlet weak var searchBtn: UIButton!{
        didSet{
            
            searchBtn.layer.cornerRadius = 5.0
            searchBtn.titleLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        }
    }
    @IBOutlet var viewHeight: NSLayoutConstraint!{
        didSet{
            viewHeight.constant = 1.0 / UIScreen.main.scale
        }
    }
    @IBAction func doSearch(_ sender: Any) {
        self.txtField.resignFirstResponder()
        self.getAddressListFromServer(nil)
    }
    
    @IBAction func goNext(_ sender: UIBarButtonItem) {
        let projectinfo = projectItem(dicInfo: nil)
        projectinfo.idcia = "9999"
        projectinfo.idproject =  "100001"
        projectinfo.name = "April for test"
        self.performSegue(withIdentifier: "goCheckList", sender: projectinfo)
    }
    var tableTag: NSInteger?
    
    
    @IBOutlet var txtField: UITextField!{
        didSet{
            txtField.layer.cornerRadius = 5.0
            txtField.placeholder = "please input address name, 4 characters at least"
            txtField.clearButtonMode = .whileEditing
            txtField.leftViewMode = .always
            txtField.delegate = self
            txtField.returnKeyType = .search
            txtField.leftView = UIImageView(image: UIImage(named: "search"))
//            NotificationCenter.default.addObserver(self, selector: #selector(AddressListViewController.textFieldDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: txtField)
            
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let txt = txtField.text?.lowercased(){
//            if txt.isEmpty {
            if txt.isEmpty || txt.characters.count < 2 {
//                
                self.PopMsgWithJustOK(msg: "Please input 4 characters at least.")
                return false
            }else{
                txtField.resignFirstResponder()
                showNOFound = false
                self.getAddressListFromServer(self.refreshControl)
//                projectlist = projectlist?.filter(){
//                    return $0.cianame!.lowercased().contains(txt)
//                        || $0.name!.lowercased().contains(txt)
//                        || $0.status!.lowercased().contains(txt)
//                    
//                }
                return true
            }
        }else{
            return false
//            self.showAllInCurrentFilter()
        }
        
        
    }
    //    var lastSelectedIndexPath : NSIndexPath?
    
    @IBOutlet var backItem: UIBarButtonItem!
    @IBOutlet var switchItem: UIBarButtonItem!
    //    @IBOutlet var searchBar: UISearchBar!
    @IBAction func doLogout(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
        let userInfo = UserDefaults.standard
        
        userInfo.set(true, forKey: CConstants.UserInfohasLogout)
    }
    var head : AddressListViewHeadView?
    
    
    fileprivate func showAllInCurrentFilter(){
        
//        projectlist = self.projectlistOrigin
        
    }
    
    
    
    fileprivate var filesNms : [String]?
//    fileprivate var CiaNm : [String]?
//    fileprivate var CiaNmArray : [String : [projectItem]]?
    
    
    @IBOutlet weak var LoginUserName: UIBarButtonItem!{
        didSet{
            let userInfo = UserDefaults.standard
            LoginUserName.title = userInfo.object(forKey: CConstants.LoggedUserNameKey) as? String
        }
    }
    // MARK: - Constanse
    fileprivate struct constants{
        static let Title : String = "Address List"
        static let CellIdentifier : String = "Address Cell Identifier"
        static let gotoChecklistTableSegue : String = "goCheckListTable"
        
    }
    
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tag = 2
        self.navigationItem.hidesBackButton = true
        self.title = constants.Title
//        if tableTag != 2 {
//            salesBtn.hidden = true
//        }
        
        let pd = cl_project()
        self.projectlist = pd.getAllProjects()  
        
    }
    
    
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        if let a = self.navigationController?.viewControllers {
            let pwd = UserDefaults.standard.string(forKey: CConstants.UserInfoPwd)
            UserDefaults.standard.set(nil, forKey: CConstants.UserInfoPwd)
             UserDefaults.standard.set(pwd, forKey: CConstants.UserInfoPwdbefore)
            
            if a.count == 1 {
                let storyboard = UIStoryboard(name: CConstants.StoryboardName, bundle: nil)
                let rootController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as UIViewController
                self.navigationController?.pushViewController(rootController, animated: true)
                //                rootController.title = "april"
                //                var tmp = a
                //                tmp.insert(rootController, atIndex: 0)
                //                self.navigationController?.viewControllers = tmp
            }else{
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
        //
    }
    
    var showNOFound = false
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var cnt = projectlist?.count ?? 0
        if showNOFound && cnt == 0 {
            cnt = 1
        }
        return cnt
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell;
       
            cell = tableView.dequeueReusableCell(withIdentifier: constants.CellIdentifier, for: indexPath)
            //            cell.separatorInset = UIEdgeInsetsZero
            //            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            if let cellitem = cell as? AddressUITableViewCell {
//                let ddd = CiaNmArray?[CiaNm?[indexPath.section] ?? ""]
//                cellitem.projectInfo = ddd![indexPath.row]
                let cnt = projectlist?.count ?? 0

                if indexPath.row == 0 && showNOFound && cnt == 0 {
                    cellitem.setCellContent(pinfo: projectItem(dicInfo: nil))
                }else{
                    cellitem.setCellContent(pinfo: projectlist![indexPath.row])
                }
                
                
            }
        
            
        
            
        
        
        return cell
        
    }
    
    fileprivate func getLongString(_ originStr : String) -> String{
        if originStr.characters.count < 16 {
            let tmp = "                "
            return originStr + tmp.substring(from: originStr.endIndex)
        }else{
            return originStr
        }
    }
    
    @IBOutlet var copyrightlbl: UIBarButtonItem!{
        didSet{
            let currentDate = Date()
            let usDateFormat = DateFormatter()
            usDateFormat.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy", options: 0, locale: Locale(identifier: "en-US"))
            
            copyrightlbl.title = "Copyright © " + usDateFormat.string(from: currentDate) + " All Rights Reserved"
        }
    }
   
    
    @IBOutlet var filterItem: UIBarButtonItem!
    
    
    
    var selectRowIndex : IndexPath?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.txtField.resignFirstResponder()
        
        if (self.projectlist?.count ?? 0) > 0 {
        
            selectRowIndex = indexPath
        
            self.performSegue(withIdentifier: constants.gotoChecklistTableSegue, sender: projectlist![indexPath.row])
        }
        
    }
    
   
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                
                case constants.gotoChecklistTableSegue:
                
                    if let checkListView = segue.destination as? IntroWalkListViewController{
                       
                        if let a = sender as? projectItem {
                            checkListView.projectInfo = a
//                            checkListView.title = a.name
                        }
                }
                
            default:
                break;
            }
        }
    }
    
    @IBAction func refreshAddressList(_ sender: UIRefreshControl) {
        let net = NetworkReachabilityManager()
        //        print(net?.isReachable)
        
        var end = true
        if  net?.isReachable ?? false {
            if let txt = self.txtField.text {
                if txt.characters.count > 3 {
                    end = false
                    self.getAddressListFromServer(sender)
                }
            }
            
        }
        if end {
            sender.endRefreshing()
        }
        
    }
    
    fileprivate func getAddressListFromServer(_ sender: UIRefreshControl?){
        //        print("getAddressListFromServer......")
        let net = NetworkReachabilityManager()
        //        print(net?.isReachable)
        
        
        if  net?.isReachable ?? false {
            
            let userInfo = UserDefaults.standard
            let email = userInfo.value(forKey: CConstants.UserInfoEmail) as? String
            let password = userInfo.value(forKey: CConstants.UserInfoPwd) as? String
            
            let tool = util()
            let loginUserInfo = LoginUser(email: email!, password: tool.MD5(string: password!)!, keyword: self.txtField.text ?? "")
            
            let a = loginUserInfo.DictionaryFromObject()
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.label.text = CConstants.RequestMsg
            
//           print(a)24
            
            Alamofire.request( CConstants.ServerURL + CConstants.ProjectListServiceURL, parameters: a).responseJSON{ (response) -> Void in
                hud.hide(animated: true)
//                print(response.result.value) 
                if response.result.isSuccess {
                    
                    var temp = [projectItem]();
                    if let rtnValue = response.result.value as? [[String: AnyObject]]{
                        for item in rtnValue {
                            let pitem = projectItem(dicInfo: item)
                            temp.append(pitem)
                        }
                    }
                    if temp.count == 0 {
                        self.showNOFound = true
                    }
                    self.projectlist = temp
                    
//                        self.PopMsgWithJustOK(msg: "No Address found with keyword \"\(self.txtField.text!)\".")
////                        var hud : MBProgressHUD?
////                        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
////                        hud?.mode = .customView
////                        hud?.label.text = "No Address found with keyword \"\(self.txtField.text)\"."
////                        hud?.hide(animated: true, afterDelay: 1)
//                    }
//                    let pd = cl_project()
//                    pd.savedProjectsToDB(temp)
                }else{
                    let pd = cl_project()
                    self.projectlist = pd.getAllProjects()
                }
//                hud.hide(animated: true)
                sender?.endRefreshing()
                self.switchItem.isEnabled = true
            }
            
        }
        else {
//            let pd = cl_project()
//            self.projectlist = pd.getAllProjects()
            //                hud?.hide(true)
            sender?.endRefreshing()
            self.switchItem.isEnabled = true
        }
        
        
        
        
        
    }
    fileprivate var projectlist : [projectItem]? {
        didSet{
            
            self.tableView?.reloadData()
        }
    }
    
    
    fileprivate func PopMsgWithJustOK(msg msg1: String){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .cancel) { Void in
            
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.txtField.resignFirstResponder()
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let pl = self.projectlist {
            let db = cl_project()
            for item in pl {
                let ai = db.getProjectByPro(pro: item)
                item.introwalk_status = ai.introwalk_status
                item.finishyn = ai.finishyn
            }
        }
       self.tableView.reloadData()
        
    }
    
    
}
