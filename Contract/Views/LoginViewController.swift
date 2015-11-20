//
//  LoginViewController.swift
//  Contract
//
//  Created by April on 11/18/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    private struct constants{
        static let PasswordEmptyMsg : String = "Password Required."
        static let EmailEmptyMsg :  String = "Email Required."
        static let WrongEmailOrPwdMsg :  String = "Your Email or password is incorrect."
        
        static let BorderColor : UIColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        
        static let UserInfoRememberMe :  String = "Login Remember Me"
        static let UserInfoEmail :  String = "Login Email"
        static let UserInfoPwd :  String = "Login Password"
        
        static let SegueToAddressList :  String = "adressList"
    }
    
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
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
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
                emailTxt.textColor = UIColor.darkGrayColor()
                passwordTxt.textColor = UIColor.darkGrayColor()
                spinner.startAnimating()
                saveEmailAndPwdToDisk(email: email!, password: password!)
                self.performSegueWithIdentifier(constants.SegueToAddressList, sender: self)
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case constants.SegueToAddressList:
                    print("go to address list")
                break
            default:
                break
            }
        }
        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
       setSignInBtn()
        
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
