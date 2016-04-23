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
    
    var projectInfo: ContractsItem?
    
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
        static let cellLastReuseIndentifier = "lastCell"
        static let cellFirstReuseIndentifier = "firstCell"
        static let cellHeight: CGFloat = 44.0
        
         static let selectAllTitle = "Select All"
        static let printBtnTitle = "Continue"
        static let cancelBtnTitle = "Cancel"
    }
    var printList: [String] = [
        constants.selectAllTitle
        , CConstants.ActionTitleContract
        , CConstants.ActionTitleThirdPartyFinancingAddendum
        , CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES
        , CConstants.ActionTitleAddendumA
        , CConstants.ActionTitleEXHIBIT_A
        , CConstants.ActionTitleEXHIBIT_B
        , CConstants.ActionTitleEXHIBIT_C
    ]
    
    var selected : [Bool]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        filesNames = [String]()
        let userInfo = NSUserDefaults.standardUserDefaults()
        if userInfo.boolForKey(CConstants.UserInfoIsContract) {
            printList.append(CConstants.ActionTitleBuyersExpect)
            printList.append(CConstants.ActionTitleAddendumC)
            printList.append(CConstants.ActionTitleAddendumD)
            printList.append(CConstants.ActionTitleAddendumE)
            printList.append(CConstants.ActionTitleFloodPlainAck)
            
            printList.append(CConstants.ActionTitleWarrantyAcknowledgement)
            printList.append(CConstants.ActionTitleDesignCenter)
//            printList.append(CConstants.ActionTitleClosingMemo)
            if let tmp = self.projectInfo?.hoa {
                if tmp == 1 {
                    printList.append(CConstants.ActionTitleHoaChecklist)
                    printList.append(CConstants.ActionTitleAddendumHOA)
                }
            }
            printList.append(CConstants.ActionTitleGoContract)
        }else{
            printList[0] = CConstants.ActionTitleDraftContract
            printList.append(CConstants.ActionTitleBuyersExpect)
            printList.append(CConstants.ActionTitleAddendumD)
            printList.append(CConstants.ActionTitleAddendumE)
            printList.append(CConstants.ActionTitleFloodPlainAck)
            
            printList.append(CConstants.ActionTitleWarrantyAcknowledgement)
            if let tmp = self.projectInfo?.hoa {
                if tmp == 1 {
                    printList.append(CConstants.ActionTitleHoaChecklist)
                    printList.append(CConstants.ActionTitleAddendumHOA)
                }
            }
            printList.append(CConstants.ActionTitleGoDraft)
        }
        
        selected = [Bool]()
        for _ in printList {
            selected?.append(false)
        }
        
        
        
        tableHeight.constant = getTableHight()
        tableview.updateConstraintsIfNeeded()
        
    }
    
   
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return constants.cellHeight
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return constants.cellHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellFirstReuseIndentifier)
        cell!.textLabel!.text = "Select Form"
        cell?.textLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        cell?.textLabel?.textColor =  UIColor.whiteColor()
        cell?.textLabel?.backgroundColor = CConstants.ApplicationColor
        cell!.textLabel!.textAlignment = NSTextAlignment.Center
        return cell
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellLastReuseIndentifier) as! AddressListModelLastCell
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.print?.text = constants.printBtnTitle
        
        cell.print?.textAlignment = .Center
        cell.print?.textColor = UIColor.whiteColor()
        cell.print?.backgroundColor = CConstants.ApplicationColor
        cell.print?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        cell.cancel?.text = constants.cancelBtnTitle
        
        cell.cancel?.textAlignment = .Center
        cell.cancel?.textColor = UIColor.whiteColor()
        cell.cancel?.backgroundColor = CConstants.ApplicationColor
        cell.cancel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
        
        let tab = UITapGestureRecognizer(target: self, action: #selector(PrintModelTableViewController.touched(_:)))
        tab.numberOfTapsRequired = 1
        cell.tag = 0
        cell.addGestureRecognizer(tab)
        let userinfo = NSUserDefaults.standardUserDefaults()
        if let filesNames = userinfo.valueForKey(CConstants.UserInfoPrintModel) as? [String] {
            if filesNames.count == printList.count{
                cell.tag = 1
            }
        }
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return printList.count - 1
    }
    
    //    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return constants.Title
    //    }
    //     func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 44
    //    }
    private func isAllCellSelected(){
        var selectedh = 0;
        for i in 1...selected!.count-1 {
//            let index1 = NSIndexPath(forRow: i, inSection: 0)
            if selected![i] {
                selectedh+=1
            }
        }
        
            let index1 = NSIndexPath(forRow: 0, inSection: 0)
            if let cell = tableview.cellForRowAtIndexPath(index1) as? PrintModelTableViewCell{
                if selectedh == selected!.count-1 {
                    selected![0] = true
                    cell.imageBtn.image = UIImage(named: CConstants.CheckedImgNm)
                }else{
                    selected![0] = false
                    cell.imageBtn.image = UIImage(named: CConstants.CheckImgNm)
                }
            }
            
        
    }
//    private func isAllCellSelected(){
//        var cnt = 0
//        for i in 0...printList.count-2 {
//            let indexa = NSIndexPath(forRow: i, inSection: 0)
//            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
//                
//                if cell.contentView.tag == 1 {
//                    cnt+=1
//                }
//            }
//        }
//        if cnt == printList.count-1 {
//            let indexa = NSIndexPath(forRow: printList.count-1, inSection: 0)
//            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
//                cell.imageBtn.image =  UIImage(named: CConstants.CheckedImgNm)
//                cell.tag = 1
//            }
//        }else {
//            let indexa = NSIndexPath(forRow: printList.count-1, inSection: 0)
//            if let cell = tableview.cellForRowAtIndexPath(indexa) as? PrintModelTableViewCell {
//                cell.imageBtn.image =  UIImage(named: CConstants.CheckImgNm)
//                cell.tag = 0
//            }
//
//        }
//        
//    }
    
    func touched(tap : UITapGestureRecognizer){

        if let cell = tap.view as? AddressListModelLastCell {
            let point = tap.locationInView(tap.view)
            if (cell.print.frame.contains(point)){
                var selectedCellArray = [NSIndexPath]()
                
                for i in 1...printList.count-2 {
                    let index = NSIndexPath(forRow: i, inSection: 0)
//                    if let cell = tableview.cellForRowAtIndexPath(index) {
//                        if cell.contentView.tag == 1 {
//                            selectedCellArray.append(index)
//                        }
//                        
//                        
//                    }
                    let c = selected![i]
                    if c {
                        selectedCellArray.append(index)
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
            }else if cell.cancel.frame.contains(point){
                self.dismissViewControllerAnimated(true){}
            
//            }else if cell.imageBtn.frame.contains(point) {
//                tap.view!.tag = 1 - tap.view!.tag
//                for cell in tableview.visibleCells {
//                    if let cell3 = cell as? PrintModelTableViewCell {
//                        if tap.view?.tag == 0 {
//                            cell3.contentView.tag = 0
//                            cell3.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
//                        }else{
//                            cell3.contentView.tag = 1
//                            cell3.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
//                        }
//                    }
//                }
            }
        }
        
//        tap.view!.tag = 1 - tap.view!.tag

        
    }
    
//    var filesNames : [String]?
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.cellReuseIdentifier, forIndexPath: indexPath) as! PrintModelTableViewCell
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
            cell.contentLbl?.text = printList[indexPath.row]
            cell.textLabel?.textAlignment = .Left
            
//            let userinfo = NSUserDefaults.standardUserDefaults()
//            if let filesNames = userinfo.valueForKey(CConstants.UserInfoPrintModel) as? [String] {
//                if filesNames!.contains(printList[indexPath.row]) {
//                    cell.contentView.tag = 1
//                    cell.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
//                }else{
//                    cell.contentView.tag = 0
//                    cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
//                }
        
        if let a = selected {
        let c = a[indexPath.row]
            if c {
            cell.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
            }else{
            cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
            }
        }else{
            cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
        }
//        if cell.contentView.tag == 1 {
//            cell.imageBtn?.image = UIImage(named: CConstants.CheckedImgNm)
//        }else{
//            cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
//        }
//            }else{
//                cell.contentView.tag = 0
//                cell.imageBtn?.image = UIImage(named: CConstants.CheckImgNm)
//            }

        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? PrintModelTableViewCell
            //            cell?.contentView.tag = 1 - cell!.contentView.tag
            let iv :UIImage?
            let c = selected![indexPath.row]
            if !c {
                iv = UIImage(named: CConstants.CheckedImgNm)
            }else{
                iv = UIImage(named: CConstants.CheckImgNm)
            }
            selected![indexPath.row] = !c
//
            cell?.imageBtn?.image = iv
            
            
                for i in 1...(selected!.count-1) {
                    selected![i] = !c
                    let indexother = NSIndexPath(forRow: i, inSection: 0)
                    if let cell = tableView.cellForRowAtIndexPath(indexother) as? PrintModelTableViewCell {
                        cell.imageBtn?.image =  iv
                    }
                }
            
        }else if indexPath.row < (printList.count - 1) {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? PrintModelTableViewCell
//            cell?.contentView.tag = 1 - cell!.contentView.tag
            let iv :UIImage?
            let c = selected![indexPath.row]
            if !c {
                iv = UIImage(named: CConstants.CheckedImgNm)
            }else{
                iv = UIImage(named: CConstants.CheckImgNm)
            }
            selected![indexPath.row] = !c
            
            cell?.imageBtn?.image = iv
            isAllCellSelected()
            
        }else{
            
            var selectedCellArray = [NSIndexPath]()
            
            for i in 0...printList.count-1 {
//                let index = NSIndexPath(forRow: i, inSection: 0)
//                if let cell = tableView.cellForRowAtIndexPath(index) {
//                    if cell.contentView.tag == 1 {
//                        selectedCellArray.append(index)
//                    }
//                    
//                    
//                }
                let c = selected![i]
                let index = NSIndexPath(forRow: i, inSection: 0)
                if c {
                    selectedCellArray.append(index)
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
            return CGSize(width: tableview.frame.width, height:getTableHight())
        }
        set { super.preferredContentSize = newValue }
    }
    
    private func getTableHight() -> CGFloat{
//        print(constants.cellHeight * CGFloat(printList.count + 1), 680, (min(view.frame.height, view.frame.width) - 40))
//        print(min(CGFloat(constants.cellHeight * CGFloat(printList.count + 1)), 680, (min(view.frame.height, view.frame.width) - 40)))
       return min(CGFloat(constants.cellHeight * CGFloat(printList.count + 1)), 680, (min(view.frame.height, view.frame.width) - 40))
    }
    
    
}
