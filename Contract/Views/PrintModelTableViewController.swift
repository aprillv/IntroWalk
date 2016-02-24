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
    func GoToPrint(modelNm: [String])
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
    @IBOutlet var tableHeight: NSLayoutConstraint!
    
    @IBOutlet var tablex: NSLayoutConstraint!
    @IBOutlet var tabley: NSLayoutConstraint!
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
        static let Title : String = "Select"
        static let CellIdentifier : String = "Address Cell Identifier"
        
        static let cellReuseIdentifier = "cellIdentifier"
        static let cellHeight = 44.0
    }
    var printList: [String] = [
        CConstants.ActionTitleContract
        , CConstants.ActionTitleThirdPartyFinancingAddendum
        , CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES
        , CConstants.ActionTitleAddendumA
        , CConstants.ActionTitleAddendumC
        , CConstants.ActionTitleEXHIBIT_A
        , CConstants.ActionTitleEXHIBIT_B
        , CConstants.ActionTitleEXHIBIT_C
        , CConstants.ActionTitleClosingMemo
        , CConstants.ActionTitleDesignCenter
        , CConstants.ActionTitleGo
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableHeight.constant = CGFloat(Double(printList.count) * constants.cellHeight)
        tableview.updateConstraintsIfNeeded()
        
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
         return 1
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return printList.count
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return constants.Title
//    }
//     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.textLabel?.text = printList[indexPath.row]
        if indexPath.row == (printList.count - 1) {
            cell.textLabel?.textAlignment = .Center
        }else{
            cell.textLabel?.textAlignment = .Left
        }
        
//        if self.modalPresentationStyle != .Popover {
//            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        }
        
        
        return cell
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < (printList.count - 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            cell?.accessoryType = cell?.accessoryType == UITableViewCellAccessoryType.None ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
            
        }else{
            var selectedCellArray = [NSIndexPath]()
            
            for i in 0...printList.count-1 {
                let index = NSIndexPath(forRow: i, inSection: 0)
                if let cell = tableView.cellForRowAtIndexPath(index) {
                    if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                        selectedCellArray.append(index)
                    }
                }
            }
            if selectedCellArray.count == 0 {
                return
            }else{
                self.dismissViewControllerAnimated(true){
                    if let delegate1 = self.delegate {
                        var filesNames = [String]()
                        for indexPath0 in selectedCellArray {
                            let title = self.printList[indexPath0.row]
                            filesNames.append(title)
                            
                            
//
                        }
                        
                        delegate1.GoToPrint(filesNames)
                    }
                }
            }
            

        }
    }
    
    override var preferredContentSize: CGSize {
        
        get {
            return CGSize(width: tableview.frame.width, height: CGFloat(constants.cellHeight * Double(printList.count)))
        }
        set { super.preferredContentSize = newValue }
    }
    
    

}