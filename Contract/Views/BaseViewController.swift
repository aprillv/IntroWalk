//
//  BaseViewController.swift
//  Contract
//
//  Created by April on 11/18/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func IsNilOrEmpty(str : String?) -> Bool{
        if str == nil || str!.isEmpty {
            return true
        }else {
            return false
        }
    }
    
    func PopMsgWithJustOK(msg msg1: String, txtField : UITextField?){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: msg1, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .Cancel) { action -> Void in
            //Do some stuff
            txtField?.becomeFirstResponder()
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func PopServerError(){
        self.PopMsgWithJustOK(msg: CConstants.MsgServerError, txtField: nil)
    }
    func PopNetworkError(){
        self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError, txtField: nil)
    }
    
    func PopMsgValidationWithJustOK(msg msg1: String, txtField : UITextField?){
        
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgValidationTitle, message: msg1, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: CConstants.MsgOKTitle, style: .Cancel) { action -> Void in
            //Do some stuff
            txtField?.becomeFirstResponder()
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func MD5(str tmp : String) -> String! {
        let str = tmp.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(tmp.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
            
            result.dealloc(digestLen)
            
            return String(format: hash.stringByAppendingString(""))
        }
        return ""
    }
    
    
    
        
}