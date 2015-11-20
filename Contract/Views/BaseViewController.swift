//
//  BaseViewController.swift
//  Contract
//
//  Created by April on 11/18/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    private struct ProjectConstants{
        static let MsgTitle : String = "BA Contract"
        static let MsgOKTitle : String = "OK"
        static let MsgValidationTitle : String = "Validation Failed"
    }
    
    func IsNilOrEmpty(str : String?) -> Bool{
        if str == nil || str == "" {
            return true
        }else {
            return false
        }
    }
    
    func PopMsgWithJustOK(msg msg1: String, txtField : UITextField?){
        
        let alert: UIAlertController = UIAlertController(title: ProjectConstants.MsgTitle, message: msg1, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: ProjectConstants.MsgOKTitle, style: .Cancel) { action -> Void in
            //Do some stuff
            txtField?.becomeFirstResponder()
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    func PopMsgValidationWithJustOK(msg msg1: String, txtField : UITextField?){
        
        let alert: UIAlertController = UIAlertController(title: ProjectConstants.MsgValidationTitle, message: msg1, preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: ProjectConstants.MsgOKTitle, style: .Cancel) { action -> Void in
            //Do some stuff
            txtField?.becomeFirstResponder()
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    

}



