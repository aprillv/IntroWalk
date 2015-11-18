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
    }
    func PopMsgWithJustOK(msg msg1: String, txtField : UITextField?){
        
        let alert: UIAlertController = UIAlertController(title: ProjectConstants.MsgTitle, message: msg1, preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let oKAction: UIAlertAction = UIAlertAction(title: ProjectConstants.MsgOKTitle, style: .Cancel) { action -> Void in
            //Do some stuff
            txtField?.becomeFirstResponder()
        }
        alert.addAction(oKAction)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }

}
