//
//  SendOperationViewController.swift
//  Contract
//
//  Created by April on 12/22/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

protocol DoOperationDelegate
{
    func saveToServer()
    func doPrint()
    func sendEmail()
}

class SendOperationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var delegate1 : DoOperationDelegate?
    
    var itemList : [String]?{
        didSet{
            if let _ = itemList{
                tableView.reloadData()
            }
        }
    }
    
    
    private struct constants{
        static let cellReuseIdentifier = "operationCellIdentifier"
        static let rowHeight : CGFloat = 44
        static let operationSavetoServer = "Save to Server"
        static let operationPrint = "Print"
        static let operationEmail = "Email"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemList = [constants.operationSavetoServer, constants.operationPrint, constants.operationEmail]
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return constants.rowHeight
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 0
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = itemList![indexPath.row]
        cell.textLabel?.textAlignment = .Center
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true){
            if let delegate0 = self.delegate1{
                switch self.itemList![indexPath.row]{
                    case constants.operationSavetoServer:
                        delegate0.saveToServer()
                    case constants.operationPrint:
                        delegate0.doPrint()
                    case constants.operationEmail:
                        delegate0.sendEmail()
                    default:
                        break
                }
                
                
            }
        }
        
        
    }
    
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: tableView.frame.width, height: constants.rowHeight * CGFloat(itemList!.count))
            
        }
        set { super.preferredContentSize = newValue }
    }
    
}
