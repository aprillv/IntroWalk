//
//  PrintModelTableViewController.swift
//  Contract
//
//  Created by April on 2/18/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
protocol ToDoPrintDelegate
{
    func GoToPrint(modelNm: String)
}
class PrintModelTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{
    // MARK: - Constanse
    
    var delegate : ToDoPrintDelegate?
    
    @IBAction func dismissSelf(sender: UITapGestureRecognizer) {
//        print(sender)
//        let point = sender.locationInView(view)
//        if !CGRectContainsPoint(tableview.frame, point) {
            self.dismissViewControllerAnimated(true){}
//        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let point = touch.locationInView(view)
        return !CGRectContainsPoint(tableview.frame, point)
    }
    @IBOutlet var tableview: UITableView!{
        didSet{
            tableview.layer.cornerRadius = 8.0
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.title = "Print"
        view.superview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
//        view.superview?.bounds = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 44 * CGFloat(5))
    }
    
    private struct constants{
        static let Title : String = "Address List"
        static let CellIdentifier : String = "Address Cell Identifier"
        
        static let cellReuseIdentifier = "cellIdentifier"
    }
    var printList: [String] = [
        CConstants.ActionTitleContract
        , CConstants.ActionTitleThirdPartyFinancingAddendum
        , CConstants.ActionTitleAddendumC
        , CConstants.ActionTitleClosingMemo
        , CConstants.ActionTitleDesignCenter]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.reloadData()
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         return 1
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return printList.count
    }
    
//     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = printList[indexPath.row]
        cell.textLabel?.textAlignment = .Left
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.dismissViewControllerAnimated(true){
            if let delegate1 = self.delegate {
                delegate1.GoToPrint(self.printList[indexPath.row])
            }
        }
        
    }
    

}
