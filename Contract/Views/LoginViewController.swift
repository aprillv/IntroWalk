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

    // MARK: - Page constants
    private struct constants{
        static let PasswordEmptyMsg : String = "Password Required."
        static let EmailEmptyMsg :  String = "Email Required."
        static let WrongEmailOrPwdMsg :  String = "Email or password is incorrect."
        
        static let BorderColor : UIColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        
        static let UserInfoRememberMe :  String = "Login Remember Me"
        static let UserInfoEmail :  String = "Login Email"
        static let UserInfoPwd :  String = "Login Password"
        
        static let SegueToAddressList :  String = "adressList"
        
        static let LoginServiceURL: String = "bacontract_login.json"
    }
    
    // MARK: Outlets
    @IBOutlet weak var emailTxt: UITextField!{
        didSet{
            emailTxt.returnKeyType = .Next
            emailTxt.delegate = self
            let userInfo = NSUserDefaults.standardUserDefaults()
            emailTxt.text = userInfo.objectForKey(constants.UserInfoEmail) as? String
        }
    }
    @IBOutlet weak var passwordTxt: UITextField!{
        didSet{
            passwordTxt.returnKeyType = .Go
            passwordTxt.enablesReturnKeyAutomatically = true
            passwordTxt.delegate = self
            let userInfo = NSUserDefaults.standardUserDefaults()
            if let isRemembered = userInfo.objectForKey(constants.UserInfoRememberMe) as? Bool{
                if isRemembered {
                    passwordTxt.text = userInfo.objectForKey(constants.UserInfoPwd) as? String
                }
                
            }
        }
    }
    
    @IBOutlet weak var rememberMeSwitch: UISwitch!{
        didSet {
            rememberMeSwitch.transform = CGAffineTransformMakeScale(0.9, 0.9)
            let userInfo = NSUserDefaults.standardUserDefaults()
            if let isRemembered = userInfo.objectForKey(constants.UserInfoRememberMe) as? Bool{
                rememberMeSwitch.on = isRemembered
            }else{
                rememberMeSwitch.on = true
            }
        }
    }
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            backView.backgroundColor = UIColor.whiteColor()
            backView.layer.borderColor = constants.BorderColor.CGColor
            backView.layer.borderWidth = 1.0
            backView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        setSignInBtn()
    }
    
    private func setSignInBtn(){
        signInBtn.enabled = !self.IsNilOrEmpty(passwordTxt.text)
            && !self.IsNilOrEmpty(emailTxt.text)
    }
    
    
    // MARK: Outlet Action
    @IBAction func rememberChanged(sender: UISwitch) {
        let userInfo = NSUserDefaults.standardUserDefaults()
        userInfo.setObject(rememberMeSwitch.on, forKey: constants.UserInfoRememberMe)
        if !rememberMeSwitch.on {
            userInfo.setObject("", forKey: constants.UserInfoPwd)
        }
    }
    
    @IBAction func Login(sender: UIButton) {
        emailTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        
        let email = emailTxt.text
        let password = passwordTxt.text
        
        if IsNilOrEmpty(email) {
            self.PopMsgWithJustOK(msg: constants.EmailEmptyMsg, txtField: emailTxt)
        }else{
            if IsNilOrEmpty(password) {
                self.PopMsgWithJustOK(msg: constants.PasswordEmptyMsg, txtField: passwordTxt)
            }else {
                // do login
                signInBtn.hidden = true
                emailTxt.enabled = false
                passwordTxt.enabled = false
                rememberMeSwitch.enabled = false
                emailTxt.textColor = UIColor.darkGrayColor()
                passwordTxt.textColor = UIColor.darkGrayColor()
                spinner.startAnimating()
            
                let loginUserInfo = LoginUser(email: email!, password: password!)
                
                let a = loginUserInfo.DictionaryFromObject()
                Alamofire.request(.POST, ProjectOpenConstants.ServerURL + constants.LoginServiceURL, parameters: a).responseJSON{ (response) -> Void in
                    if response.result.isSuccess {
                        if let rtnValue = response.result.value as? [String: AnyObject]{
                            let rtn = Contract(dicInfo: rtnValue)
                            
                            self.toEablePageControl()
                            
                            if rtn.activeyn == 1{
                                self.saveEmailAndPwdToDisk(email: email!, password: password!)
                                self.loginResult = rtn
                                self.performSegueWithIdentifier(constants.SegueToAddressList, sender: self)
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
                
////                request(method: Alamofire.Method, _ URLString: URLStringConvertible, parameters: [String : AnyObject]? = default, encoding: Alamofire.ParameterEncoding = default, headers: [String : String]? = default) -> Alamofire.Request
                
                
            }
        }
        
    }
    
   private func toEablePageControl(){
    self.signInBtn.hidden = false
    self.emailTxt.enabled = true
    self.passwordTxt.enabled = true
    self.rememberMeSwitch.enabled = true
    self.emailTxt.textColor = UIColor.blackColor()
    self.passwordTxt.textColor = UIColor.blackColor()
    self.spinner.stopAnimating()
    }
    
    func saveEmailAndPwdToDisk(email email: String, password: String){
        let userInfo = NSUserDefaults.standardUserDefaults()
        if rememberMeSwitch.on {
            userInfo.setObject(true, forKey: constants.UserInfoRememberMe)
            userInfo.setObject(email, forKey: constants.UserInfoEmail)
            userInfo.setObject(password, forKey: constants.UserInfoPwd)
        }else{
            userInfo.setObject(false, forKey: constants.UserInfoRememberMe)
            userInfo.setObject(email, forKey: constants.UserInfoEmail)
            userInfo.setObject("", forKey: constants.UserInfoPwd)
        }
    }
    
    
    // MARK: PrepareForSegue
    private var loginResult : Contract?{
        didSet{
            if loginResult != nil{
                let userInfo = NSUserDefaults.standardUserDefaults()
                userInfo.setObject(loginResult!.username, forKey: ProjectOpenConstants.LoggedUserNameKey)
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case constants.SegueToAddressList:
                    if let addressListView = segue.destinationViewController as? AddressListViewController{
                        addressListView.AddressList = loginResult?.contracts
                    }
                break
            default:
                break
            }
        }
        
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSignInBtn()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
}
