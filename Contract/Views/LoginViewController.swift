//
//  LoginViewController.swift
//  Contract
//
//  Created by April on 11/18/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: BaseViewController, UITextFieldDelegate {

    
    @IBOutlet var copyrightLbl: UIBarButtonItem!
//        {
//        didSet{
//            copyrightLbl.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "Futura", size: 9)!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
//            
//        }
//    }
    // MARK: - Page constants
    private struct constants{
        static let PasswordEmptyMsg : String = "Password Required."
        static let EmailEmptyMsg :  String = "Email Required."
        static let WrongEmailOrPwdMsg :  String = "Email or password is incorrect."
        
    }
    
    
    
    // MARK: Outlets
    @IBOutlet weak var emailTxt: UITextField!{
        didSet{
            emailTxt.returnKeyType = .Next
            emailTxt.delegate = self
            let userInfo = NSUserDefaults.standardUserDefaults()
            emailTxt.text = userInfo.objectForKey(CConstants.UserInfoEmail) as? String
        }
    }
    @IBOutlet weak var passwordTxt: UITextField!{
        didSet{
            passwordTxt.returnKeyType = .Go
            passwordTxt.enablesReturnKeyAutomatically = true
            passwordTxt.delegate = self
            let userInfo = NSUserDefaults.standardUserDefaults()
            if let isRemembered = userInfo.objectForKey(CConstants.UserInfoRememberMe) as? Bool{
                if isRemembered {
                    passwordTxt.text = userInfo.objectForKey(CConstants.UserInfoPwd) as? String
                }
                
            }
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
         setSignInBtn()
//        1298.943376
    }
//    func textFieldDidEndEditing(textField: UITextField) {
//        setSignInBtn()
//    }
    
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!{
        didSet {
            rememberMeSwitch.transform = CGAffineTransformMakeScale(0.9, 0.9)
            let userInfo = NSUserDefaults.standardUserDefaults()
            if let isRemembered = userInfo.objectForKey(CConstants.UserInfoRememberMe) as? Bool{
                rememberMeSwitch.on = isRemembered
            }else{
                rememberMeSwitch.on = true
            }
        }
    }
    
    @IBOutlet weak var backView: UIView!{
        didSet{
//            backView.backgroundColor = UIColor.whiteColor()
            backView.layer.borderColor = CConstants.BorderColor.CGColor
            backView.layer.borderWidth = 1.0
//            backView.layer.cornerRadius = 8
            backView.layer.shadowColor = UIColor.lightGrayColor().CGColor
            backView.layer.shadowOpacity = 1
            backView.layer.shadowRadius = 8.0
            backView.layer.shadowOffset = CGSize(width: -0.5, height: 0.0)
            
        }
    }
    
    @IBOutlet weak var signInBtn: UIButton!
//        {
//        didSet{
//            signInBtn.layer.cornerRadius = 5.0
//        }
//    }
    
    
    // MARK: UITextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField{
        case emailTxt:
            passwordTxt.becomeFirstResponder()
        case passwordTxt:
            Login(signInBtn)
        default:
            break
        }
        return true
    }
    
    @IBAction func textChanaged() {
        setSignInBtn()
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        setSignInBtn()
        return true
    }
    
    private func setSignInBtn(){
        signInBtn.enabled = !self.IsNilOrEmpty(passwordTxt.text)
            && !self.IsNilOrEmpty(emailTxt.text)
    }
    
    
    // MARK: Outlet Action
    @IBAction func rememberChanged(sender: UISwitch) {
        let userInfo = NSUserDefaults.standardUserDefaults()
        userInfo.setObject(rememberMeSwitch.on, forKey: CConstants.UserInfoRememberMe)
        if !rememberMeSwitch.on {
            userInfo.setObject("", forKey: CConstants.UserInfoPwd)
        }
    }
    
    
    func checkUpate(){
        let version = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"]
        let parameter = ["version": (version == nil ?  "" : version!)]
        
        
        
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.CheckUpdateServiceURL,
            parameters: parameter).responseJSON{ (response) -> Void in
            if response.result.isSuccess {
                if let rtnValue = response.result.value{
                    if rtnValue.integerValue == 1 {
                         self.doLogin()
                    }else{
                        if let url = NSURL(string: CConstants.InstallAppLink){
                            self.toEablePageControl()
                            UIApplication.sharedApplication().openURL(url)
                        }else{
                             self.doLogin()
                        }
                    }
                }else{
                    self.doLogin()
                }
            }else{
                self.doLogin()
            }
        }
        //     NSString*   version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    
    @IBAction func Login(sender: UIButton) {
        
        disAblePageControl()
        checkUpate()
    }
    
    private func disAblePageControl(){
        
        //        signInBtn.hidden = true
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
//        emailTxt.enabled = false
//        passwordTxt.enabled = false
//        
//        rememberMeSwitch.enabled = false
//        emailTxt.textColor = UIColor.darkGrayColor()
//        passwordTxt.textColor = UIColor.darkGrayColor()
        //        spinner.startAnimating()
//        if (spinner == nil){
//            spinner = UIActivityIndicatorView(frame: CGRect(x: 20, y: 4, width: 50, height: 50))
//            spinner?.hidesWhenStopped = true
//            spinner?.activityIndicatorViewStyle = .Gray
//        }
//        
//        progressBar = UIAlertController(title: nil, message: CConstants.LoginingMsg, preferredStyle: .Alert)
//        progressBar?.view.addSubview(spinner!)
//        spinner?.startAnimating()
//        self.presentViewController(progressBar!, animated: true, completion: nil)
    self.noticeOnlyText(CConstants.LoginingMsg)
        
    }
    private func doLogin(){
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        
        let email = emailTxt.text
        let password = passwordTxt.text
        
        if IsNilOrEmpty(email) {
            self.toEablePageControl()
            self.PopMsgWithJustOK(msg: constants.EmailEmptyMsg, txtField: emailTxt)
        }else{
            if IsNilOrEmpty(password) {
                self.toEablePageControl()
                self.PopMsgWithJustOK(msg: constants.PasswordEmptyMsg, txtField: passwordTxt)
            }else {
                // do login
                
                //                self.view.userInteractionEnabled = false
                
                
                let loginUserInfo = LoginUser(email: email!, password: password!, iscontract:  "1")
                
                let a = loginUserInfo.DictionaryFromObject()
                Alamofire.request(.POST, CConstants.ServerURL + CConstants.LoginServiceURL, parameters: a).responseJSON{ (response) -> Void in
                    self.clearNotice()
//                    self.progressBar?.dismissViewControllerAnimated(true){ () -> Void in
//                        self.spinner?.stopAnimating()
                        if response.result.isSuccess {
                            if let rtnValue = response.result.value as? [String: AnyObject]{
                                let rtn = Contract(dicInfo: rtnValue)
                                
                                self.toEablePageControl()
                                
                                if rtn.activeyn == 1{
                                    let userinfo = NSUserDefaults.standardUserDefaults()
                                    userinfo.setBool(true, forKey: CConstants.UserInfoIsContract)
                                    self.saveEmailAndPwdToDisk(email: email!, password: password!)
                                    self.loginResult = rtn
                                    self.performSegueWithIdentifier(CConstants.SegueToAddressList, sender: self)
                                }else{
                                    self.PopMsgValidationWithJustOK(msg: constants.WrongEmailOrPwdMsg, txtField: nil)
                                }
                            }else{
                                self.toEablePageControl()
                                self.PopServerError()
                            }
                        }else{
                            self.toEablePageControl()
                            self.PopNetworkError()
                        }
                    }
                    
//                }
                
                ////                request(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String : AnyObject]? = default, encoding: Alamofire.ParameterEncoding = default, headers: [String : String]? = default) -> Alamofire.Request
                
                
            }
        }
    }
   private func toEablePageControl(){
//    self.view.userInteractionEnabled = true
//    self.signInBtn.hidden = false
//    self.emailTxt.enabled = true
//    self.passwordTxt.enabled = true
//    self.rememberMeSwitch.enabled = true
//    self.emailTxt.textColor = UIColor.blackColor()
//    self.passwordTxt.textColor = UIColor.blackColor()
//    self.spinner?.stopAnimating()
    }
    
    func saveEmailAndPwdToDisk(email email: String, password: String){
        let userInfo = NSUserDefaults.standardUserDefaults()
        if rememberMeSwitch.on {
            userInfo.setObject(true, forKey: CConstants.UserInfoRememberMe)
        }else{
            userInfo.setObject(false, forKey: CConstants.UserInfoRememberMe)
        }
        userInfo.setObject(email, forKey: CConstants.UserInfoEmail)
        userInfo.setObject(password, forKey: CConstants.UserInfoPwd)
    }
    
    
    // MARK: PrepareForSegue
    private var loginResult : Contract?{
        didSet{
            if loginResult != nil{
                let userInfo = NSUserDefaults.standardUserDefaults()
                userInfo.setObject(loginResult!.username, forKey: CConstants.LoggedUserNameKey)
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case CConstants.SegueToAddressList:
                    if let addressListView = segue.destinationViewController as? AddressListViewController{
                        addressListView.AddressListOrigin = loginResult?.contracts
                    }
                break
            default:
                break
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(view.frame.size)
        setSignInBtn()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = CConstants.ApplicationColor
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSFontAttributeName : UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarFontSize)!
            
        ]
        self.navigationController?.toolbar.barTintColor = CConstants.ApplicationColor
        self.navigationController?.toolbar.barStyle = .Black
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
}
