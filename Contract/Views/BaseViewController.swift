//
//  BaseViewController.swift
//  Contract
//
//  Created by April on 11/18/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        navigationItem.hidesBackButton = true
//        UIApplication.sharedApplication().statusBarStyle = .LightContent
//        edgesForExtendedLayout = .None
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    func setBtnStyle(_ signInBtn: UIButton){
        signInBtn.layer.cornerRadius = 5.0
        signInBtn.titleLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
    }
    
    func IsNilOrEmpty(_ str : String?) -> Bool{
        return str == nil || str!.isEmpty
    }
    
    func PopMsgWithJustOK(msg msg1: String, txtField : UITextField?){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .cancel) { action -> Void in
            //Do some stuff
            txtField?.becomeFirstResponder()
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func PopMsgWithJustOK(msg msg1: String, action1 : @escaping (_ action : UIAlertAction) -> Void){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .cancel, handler:action1)
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func PopErrorMsgWithJustOK(msg msg1: String, action1 : @escaping (_ action : UIAlertAction) -> Void){
        
        let alert: UIAlertController = UIAlertController(title: "Message", message: msg1, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .cancel, handler:action1)
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func PopConfirmMsg(msg msg1: String, action1 : @escaping (_ action : UIAlertAction) -> Void){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .default, handler:action1)
        alert.addAction(oKAction)
        
        let canc: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(canc)
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    func PopServerError(){
        self.PopMsgWithJustOK(msg: CConstants.MsgServerError, txtField: nil)
    }
    func PopNetworkError(){
        self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError, txtField: nil)
    }
    
    func PopMsgValidationWithJustOK(msg msg1: String, txtField : UITextField?){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgValidationTitle, message: msg1, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .cancel) { action -> Void in
            //Do some stuff
            txtField?.becomeFirstResponder()
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func MD5(str tmp : String) -> String! {
    let tool = util()
        return tool.MD5(string: tmp)
    }
    
//
//        let str = tmp.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(tmp.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        
//        CC_MD5(str!, strLen, result)
//        
//        let hash = NSMutableString()
//        for i in 0..<digestLen {
//            hash.appendFormat("%02x", result[i])
//            
//            result.dealloc(digestLen)
//            
//            return String(format: hash.stringByAppendingString(""))
//        }
//        return ""
//    }
    
    func PopMsgWithJustOK(msg msg1: String){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .cancel) { Void in
            
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    
    
    
        
}
