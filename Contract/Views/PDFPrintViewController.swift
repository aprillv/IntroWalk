//
//  PDFPrintViewController.swift
//  Contract
//
//  Created by April on 2/23/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class PDFPrintViewController: PDFBaseViewController {
    
    
    var isDownload : Bool?
    @IBOutlet var view2: UIView!
    var addendumApdfInfo : AddendumA?{
        didSet{
            if let info = addendumApdfInfo {
                if let fDD = fileDotsDic {
                    let tool = SetDotValue()
                    
                    for (str, dots) in fDD {
//                        print(dots)
                        switch str{
                        case CConstants.ActionTitleThirdPartyFinancingAddendum:
                            tool.setThirdPartyFinacingAddendumDots(info, additionViews: dots)
                        case CConstants.ActionTitleAddendumA:
                            tool.setAddendumADots(info, additionViews: dots)
                        case CConstants.ActionTitleEXHIBIT_A:
                            tool.setExhibitADots(info, additionViews: dots)
                        case CConstants.ActionTitleEXHIBIT_B:
                            tool.setExhibitBDots(info, additionViews: dots)
                        case CConstants.ActionTitleEXHIBIT_C:
//                            print(dots)
                            tool.setExhibitCDots(info, additionViews: dots)
                        default:
                            break
                        }
                        
                    }
                }
            }
            
        }
        
    }
    
    
    var addendumCpdfInfo : ContractAddendumC?
    private func setAddendumC(){
        if let info = addendumCpdfInfo {
            if let fDD = fileDotsDic {
                let tool = SetDotValue()
                var i = 0
                for (str, dots) in fDD {
                    switch str{
                    case CConstants.ActionTitleAddendumC:
                        for doc in documents! {
                            if doc.pdfName == CConstants.ActionTitleAddendumC {
                                doc.addedviewss = tool.setAddendumCDots(info, additionViews: dots, pdfview: self.pdfView!, has2Pages0: self.page2!)
                            }
                        }
                        return
                    default:
                        i++
                    }
                    
                }
            }
        }
    }
    var contractPdfInfo : ContractSignature?{
        didSet{
            if let info = contractPdfInfo {
                if let fDD = fileDotsDic {
                    let tool = SetDotValue()
                    
                    for (str, dots) in fDD {
                        switch str{
                        case CConstants.ActionTitleContract:
                            tool.setSignContractDots(info, additionViews: dots, pdfview: self.pdfView!)
                            return
                        default:
                            break
                        }
                    }
                }
            }
            
        }

    }
    var closingMemoPdfInfo: ContractClosingMemo?{
        didSet{
            if let info = closingMemoPdfInfo {
                if let fDD = fileDotsDic {
                    let tool = SetDotValue()
                    var i = 0
                    for (str, dots) in fDD {
                        switch str{
                        case CConstants.ActionTitleClosingMemo:
                            for doc in documents! {
                                if doc.pdfName == CConstants.ActionTitleClosingMemo {
                                    doc.addedviewss = tool.setCloingMemoDots(info, additionViews: dots, pdfview: self.pdfView!)
                                }
                            }
                            return
                        default:
                            i++
                        }
                    }
                }
            }
            
        }
        
    }
    var designCenterPdfInfo : ContractDesignCenter?{
        didSet{
            if let info = designCenterPdfInfo {
                if let fDD = fileDotsDic {
                    let tool = SetDotValue()
                    
                    for (str, dots) in fDD {
                        switch str{
                        case CConstants.ActionTitleDesignCenter:
                            tool.setDesignCenterDots(info, additionViews: dots)
                            return
                        default:
                            break
                        }
                    }
                }
            }
            
        }
        
    }
    
    var page2 : Bool?
    
    var filesArray : [String]?
    var fileDotsDic : [String : [PDFWidgetAnnotationView]]?
    
    
    
    
    
    
    
    private func getFileName() -> String{
        return "contract1pdf_" + self.pdfInfo0!.idcity! + "_" + self.pdfInfo0!.idcia!
    }
    
    override func loadPDFView(){
        
        var filesNames = [String]()
        let param = ContractRequestItem(contractInfo: nil).DictionaryFromBasePdf(self.pdfInfo0!)

        
        let margins = getMargins()
        
//        var pageHeight : CGFloat = CConstants.PdfPageHeight
//        if let a  = NSUserDefaults.standardUserDefaults().valueForKey(CConstants.PdfPageMarginUserDefault) as? String{
//            if let n = NSNumberFormatter().numberFromString(a) {
//                pageHeight = CGFloat(n)
//                
//            }
//        }
        
        documents = [PDFDocument]()
        fileDotsDic = [String : [PDFWidgetAnnotationView]]()
        var allAdditionViews = [PDFWidgetAnnotationView]()
        
        var lastheight : Int
        var filePageCnt : Int = 0
        for title in filesArray! {
             self.callService(title, param: param)
            var str : String
            
            lastheight = filePageCnt
            
            switch title {
            case CConstants.ActionTitleContract:
                str = CConstants.PdfFileNameContract
                filePageCnt += CConstants.PdfFileNameContractPageCount
            case CConstants.ActionTitleThirdPartyFinancingAddendum:
                str = CConstants.PdfFileNameThirdPartyFinancingAddendum
                filePageCnt += CConstants.PdfFileNameThirdPartyFinancingAddendumPageCount
            case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
                str = CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES
                filePageCnt += CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICESPageCount
            case CConstants.ActionTitleAddendumA:
                str = CConstants.PdfFileNameAddendumA
                filePageCnt += CConstants.PdfFileNameAddendumAPageCount
            case CConstants.ActionTitleAddendumC:
                if self.page2! {
                    str = CConstants.PdfFileNameAddendumC2
                    filePageCnt += CConstants.PdfFileNameAddendumC2PageCount
                }else{
                    str = CConstants.PdfFileNameAddendumC
                    filePageCnt += CConstants.PdfFileNameAddendumCPageCount
                }
                
            case CConstants.ActionTitleEXHIBIT_A:
                str = CConstants.PdfFileNameEXHIBIT_A
                filePageCnt += CConstants.PdfFileNameEXHIBIT_APageCount
            case CConstants.ActionTitleEXHIBIT_B:
                str = CConstants.PdfFileNameEXHIBIT_B
                filePageCnt += CConstants.PdfFileNameEXHIBIT_BPageCount
            case CConstants.ActionTitleEXHIBIT_C:
                str = CConstants.PdfFileNameEXHIBIT_C
                filePageCnt += CConstants.PdfFileNameEXHIBIT_CPageCount
            case CConstants.ActionTitleClosingMemo:
                str = CConstants.PdfFileNameClosingMemo
                filePageCnt += CConstants.PdfFileNameClosingMemoPageCount
            case CConstants.ActionTitleDesignCenter:
                str = CConstants.PdfFileNameDesignCenter
                filePageCnt += CConstants.PdfFileNameDesignCenterPageCount
            default:
                str = ""
                filePageCnt += 0
            }
            
            filesNames.append(str)
            
            let document = PDFDocument.init(resource: str)
            document.pdfName = title
            documents?.append(document)
            
            
            if let additionViews = document.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin: CGFloat(lastheight)) as? [PDFWidgetAnnotationView]{
                
                
                fileDotsDic![title] = additionViews
                
                allAdditionViews.appendContentsOf( additionViews)
            }
            
        }
        
        
        pdfView = PDFView(frame: view2.bounds, dataOrPathArray: filesNames, additionViews: allAdditionViews)
        
//        print(self.document?.forms)
        setAddendumC()
        view2.addSubview(pdfView!)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userinfo = NSUserDefaults.standardUserDefaults()
        if userinfo.boolForKey(CConstants.UserInfoIsContract) {
            self.navigationItem.title = "Contract"
        }else{
            self.navigationItem.title = "Draft"
        }
    }
    
    
    // MARK: Request Data
    private func callService(printModelNm: String, param: [String: String]){
        print(param)
        var serviceUrl: String?
        switch printModelNm{
        case CConstants.ActionTitleDesignCenter:
            serviceUrl = CConstants.DesignCenterServiceURL
        case CConstants.ActionTitleAddendumC:
            return
//            serviceUrl = CConstants.AddendumCServiceURL
        case CConstants.ActionTitleClosingMemo:
            serviceUrl = CConstants.ClosingMemoServiceURL
        case CConstants.ActionTitleContract:
            serviceUrl = CConstants.ContractServiceURL
        case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
//            self.performSegueWithIdentifier(CConstants.SegueToInformationAboutBrokerageServices, sender: nil)
            return
        default:
            serviceUrl = CConstants.AddendumAServiceURL
        }
        self.noticeOnlyText(CConstants.RequestMsg)
        Alamofire.request(.POST,
            CConstants.ServerURL + serviceUrl!,
            parameters: param).responseJSON{ (response) -> Void in
                self.clearNotice()
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? [String: AnyObject]{
                        if let msg = rtnValue["message"] as? String{
                            if msg.isEmpty{
                                var vc : PDFBaseViewController?
                                switch printModelNm {
                                case CConstants.ActionTitleAddendumC:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameAddendumC) as? PDFBaseViewController
                                    if let controller = vc as? AddendumCViewController{
                                        controller.pdfInfo = ContractAddendumC(dicInfo: rtnValue)
                                        
                                        var itemList = [[String]]()
                                        var i = 0
                                        if let list = controller.pdfInfo?.itemlist {
                                            for items in list {
                                                
                                                var itemList1 = [String]()
                                                let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
                                                textView.scrollEnabled = false
                                                textView.font = UIFont(name: "Verdana", size: 11.0)
                                                textView.text = items.xdescription!
                                                textView.sizeToFit()
                                                textView.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, items.xdescription!.characters.count), usingBlock: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
                                                    if  let a : NSString = items.xdescription! as NSString {
                                                        
                                                        i++
                                                        itemList1.append(a.substringWithRange(glyphRange))
                                                    }
                                                })
                                                //                            itemList1.append("april test")
                                                itemList.append(itemList1)
                                            }
                                        }
                                        controller.pdfInfo!.itemlistStr = itemList
                                        
                                        
                                        let pass = i > 19 ? CConstants.PdfFileNameAddendumC2 : CConstants.PdfFileNameAddendumC
                                        
                                        controller.initWithResource(pass)
                                        
                                    }
                                case CConstants.ActionTitleClosingMemo:
                                    self.closingMemoPdfInfo = ContractClosingMemo(dicInfo: rtnValue)
                                case CConstants.ActionTitleDesignCenter:
                                    self.designCenterPdfInfo = ContractDesignCenter(dicInfo: rtnValue)
                                case CConstants.ActionTitleContract:
                                    self.contractPdfInfo = ContractSignature(dicInfo: rtnValue)
                                
                                default:
//                                    print(rtnValue)
                                    self.addendumApdfInfo = AddendumA(dicInfo: rtnValue)
                                }
                                if let vcc = vc {
                                    vcc.AddressList = self.AddressList
                                    var na = self.navigationController?.viewControllers
                                    na?.removeLast()
                                    na?.append(vcc)
                                    self.navigationController?.viewControllers = na!
                                }
                                
                            }else{
                                self.PopMsgWithJustOK(msg: msg)
                            }
                        }else{
                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError)
                    }
                }else{
                    //                            self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError)
                }
        }
        
    }
    
    private func readContractFieldsFromTxt(fileName: String) ->[String: String]? {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") {
            var fieldsDic = [String : String]()
            do {
                let fieldsStr = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                let n = fieldsStr.componentsSeparatedByString("\n")
                
                for one in n{
                    let s = one.componentsSeparatedByString(":")
                    if s.count != 2 {
                        print(one)
                    }else{
                        fieldsDic[s.first!] = s.last!
                    }
                }
            }
            catch {/* error handling here */}
            return fieldsDic
        }
        
        return nil
    }
    
    @IBAction func BuyerSign(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true){}
//        print(self.pdfView?.pdfView.scrollView.contentSize.height)
        if fileDotsDic != nil {
            for (_, v) in fileDotsDic! {
                for a in v {
                    if let sign = a as? SignatureView {
//                        print(b.xname)
//                        print(b.tag, b.superview)
                        if sender.tag == 1 && sign.xname.hasSuffix("bottom1")
                            || sender.tag == 2 && sign.xname.hasSuffix("bottom2")
                            || sender.tag == 3 && sign.xname.hasSuffix("bottom3")
                            || sender.tag == 4 && sign.xname.hasSuffix("bottom4"){
                            //buyer1
                            if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                sign.toSignautre()
                                return
                            }
                        }
                        if sender.tag == 1 && sign.xname == ("buyer2Sign")
                        || sender.tag == 2 && sign.xname == ("buyer3Sign")
                        || sender.tag == 3 && sign.xname == ("seller2Sign")
                        || sender.tag == 4 && sign.xname == ("seller3Sign"){
                            if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                sign.toSignautre()
                                return
                            }
                        }
                        
                        //broker
                        if addendumApdfInfo != nil{
                            if let hasrealtor = addendumApdfInfo!.hasbroker {
                                if hasrealtor == "" {
                                    if sender.tag == 1 && sign.xname == "broker2buyer2Sign"
                                        || sender.tag == 2 && sign.xname == "broker2buyer3Sign"
                                        || sender.tag == 3 && sign.xname==("broker2buyer2DateSign")
                                        || sender.tag == 4 && sign.xname==("broker2buyer3DateSign"){
                                            if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                                sign.toSignautre()
                                                return
                                            }
                                    }
                                }else{
                                    if sender.tag == 1 && sign.xname == "brokerbuyer2Sign"
                                        || sender.tag == 2 && sign.xname == "brokerbuyer3Sign"
                                        || sender.tag == 3 && sign.xname==("brokerbuyer2DateSign")
                                        || sender.tag == 4 && sign.xname==("brokerbuyer3DateSign"){
                                            if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                                sign.toSignautre()
                                                return
                                            }
                                    }
                                }
                                
                            }

                        }
                        
                        //broker
                        if addendumCpdfInfo != nil{
                           
                            if sender.tag == 1 && sign.xname == "april1Sign"
                                || sender.tag == 2 && sign.xname == "april2Sign"
                                || sender.tag == 3 && sign.xname==("april3Sign"){
                                    if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                        sign.toSignautre()
                                        return
                                    }
                            }
                            
                            
                        }
                        if designCenterPdfInfo != nil{
                            
                            if sender.tag == 1 && sign.xname == "homeBuyer1Sign"
                                || sender.tag == 2 && sign.xname == "homeBuyer2Sign"
                                {
                                    if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                        sign.toSignautre()
                                        return
                                    }
                            }
                            
                            
                        }
                        
                    }
                    
                }
            }
        }
    }
    

    
    
    
    @IBAction func  SellerSign(sender: UIBarButtonItem) {
        BuyerSign(sender)
        
    }
    
    
}
