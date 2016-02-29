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
class PrintModelTableViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{
    // MARK: - Constanse
    
    
    @IBOutlet var printBtn: UIButton!{
        didSet{
            printBtn.layer.cornerRadius = 5.0
            printBtn.hidden = true
        }
    }
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
        , CConstants.ActionTitleEXHIBIT_A
        , CConstants.ActionTitleEXHIBIT_B
        , CConstants.ActionTitleEXHIBIT_C
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userInfo = NSUserDefaults.standardUserDefaults()
        if userInfo.boolForKey(CConstants.UserInfoIsContract) {
            printList.append(CConstants.ActionTitleAddendumC)
            printList.append(CConstants.ActionTitleDesignCenter)
            printList.append(CConstants.ActionTitleClosingMemo)
            printList.append(CConstants.ActionTitleGoContract)
        }else{
            printList.append(CConstants.ActionTitleGoDraft)
        }
        
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
    
    private func isAllCellSelected(){
        var cnt = 0
        for i in 0...printList.count-2 {
            let indexa = NSIndexPath(forRow: i, inSection: 0)
            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
                
                if cell.contentView.tag == 1 {
                    cnt+=1
                }
            }
        }
        if cnt == printList.count-1 {
            let indexa = NSIndexPath(forRow: printList.count-1, inSection: 0)
            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
                cell.imageBtn.image =  UIImage(named: CConstants.CheckedImgNm)
                cell.tag = 1
            }
        }else {
            let indexa = NSIndexPath(forRow: printList.count-1, inSection: 0)
            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
                cell.imageBtn.image =  UIImage(named: CConstants.CheckImgNm)
                cell.tag = 0
            }

        }
        
    }
    
    func touched(tap : UITapGestureRecognizer){
         let indexa = NSIndexPath(forRow: printList.count-1, inSection: 0)
        if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
            let point = tap.locationInView(tap.view)
            if (cell.contentLbl.frame.contains(point)){
                var selectedCellArray = [NSIndexPath]()
                
                for i in 0...printList.count-1 {
                    let index = NSIndexPath(forRow: i, inSection: 0)
                    if let cell = tableview.cellForRowAtIndexPath(index) {
                        if cell.contentView.tag == 1 {
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
                            }
                            let userinfo = NSUserDefaults.standardUserDefaults()
                            userinfo.setValue(filesNames, forKey: CConstants.UserInfoPrintModel)
                            delegate1.GoToPrint(filesNames)
                        }
                    }
                }
            }else if cell.imageBtn.frame.contains(point) {
                tap.view!.tag = 1 - tap.view!.tag
                for cell in tableview.visibleCells {
                    if let cell3 = cell as? PrintModelTableViewCell {
                        if tap.view?.tag == 0 {
                            cell3.contentView.tag = 0
                            cell3.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
                        }else{
                            cell3.contentView.tag = 1
                            cell3.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
                        }
                    }
                }
            }
        }
        
//        tap.view!.tag = 1 - tap.view!.tag

        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath) as! PrintModelTableViewCell
//        let a = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height:  cell.frame.size.height))
//        a.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
//        cell.selectedBackgroundView = a
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.contentLbl?.text = printList[indexPath.row]
        if indexPath.row == (printList.count - 1) {
            cell.contentLbl?.textAlignment = .Center
            cell.contentLbl?.textColor = UIColor.whiteColor()
//            cell.contentView.backgroundColor = CConstants.ApplicationColor
            cell.contentLbl?.backgroundColor = CConstants.ApplicationColor
            cell.contentLbl?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
            cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
            
            let tab = UITapGestureRecognizer(target: self, action: "touched:")
            tab.numberOfTapsRequired = 1
//            tab.delegate = self
            cell.tag = 0
            cell.addGestureRecognizer(tab)
            let userinfo = NSUserDefaults.standardUserDefaults()
            if let filesNames = userinfo.valueForKey(CConstants.UserInfoPrintModel) as? [String] {
                if filesNames.count == printList.count{
                    cell.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
                    cell.tag = 1
                }
            }
            
            cell.leadingtoLeft.constant = -8
            cell.updateConstraintsIfNeeded()
        }else{
            cell.textLabel?.textAlignment = .Left
            
            let userinfo = NSUserDefaults.standardUserDefaults()
            if let filesNames = userinfo.valueForKey(CConstants.UserInfoPrintModel) as? [String] {
                if filesNames.contains(printList[indexPath.row]) {
                    cell.contentView.tag = 1
                    cell.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
                }else{
                    cell.contentView.tag = 0
                    cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
                }
            }else{
                cell.contentView.tag = 0
                cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
            }
           

        }
        
        
        
        //        if self.modalPresentationStyle != .Popover {
        //            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row < (printList.count - 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? PrintModelTableViewCell
            cell?.contentView.tag = 1 - cell!.contentView.tag
            let iv :UIImage?
            if cell?.contentView.tag == 1 {
                iv = UIImage(named: CConstants.CheckedImgNm)
            }else{
                iv = UIImage(named: CConstants.CheckImgNm)
            }
            
            cell?.imageBtn?.image = iv
            isAllCellSelected()
            
        }else{
            
            var selectedCellArray = [NSIndexPath]()
            
            for i in 0...printList.count-1 {
                let index = NSIndexPath(forRow: i, inSection: 0)
                if let cell = tableView.cellForRowAtIndexPath(index) {
                    if cell.contentView.tag == 1 {
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
                        }
                        let userinfo = NSUserDefaults.standardUserDefaults()
                        userinfo.setValue(filesNames, forKey: CConstants.UserInfoPrintModel)
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
