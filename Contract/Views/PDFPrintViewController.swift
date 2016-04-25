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
import MBProgressHUD

class PDFPrintViewController: PDFBaseViewController, UIScrollViewDelegate, PDFViewDelegate{
    
//    var currentlyEditingView : SPUserResizableView?
//    var lastEditedView : SPUserResizableView?
//    
//    func userResizableViewDidBeginEditing(userResizableView: SPUserResizableView!) {
//        currentlyEditingView?.hideEditingHandles()
//        currentlyEditingView = userResizableView;
//    }
//    func userResizableViewDidEndEditing(userResizableView: SPUserResizableView!) {
//         lastEditedView = userResizableView;
//    }
//    @IBAction func draw(sender: AnyObject) {
////        let b = MyView()
////        b.frame = CGRect(x: 0, y: 64, width: view.frame.size.width, height: view.frame.size.height - 113)
////        b.backgroundColor = UIColor.clearColor()
////        self.view.addSubview(b)
//        
//        let gripFrame = CGRectMake(50, 50, 200, 150)
//        let userResizableView = SPUserResizableView(frame: gripFrame)
//        let contentView = UIView(frame: gripFrame)
//        contentView.backgroundColor = UIColor.blackColor()
//        userResizableView.contentView = contentView
//        userResizableView.delegate = self
//        currentlyEditingView = userResizableView
//        lastEditedView = userResizableView
//        userResizableView.showEditingHandles()
//        self.pdfView?.pdfView.scrollView.addSubview(userResizableView)
//        
//        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideEditingHandles))
//        gestureRecognizer.delegate = self
//        self.pdfView?.pdfView.scrollView.addGestureRecognizer(gestureRecognizer)
//        
//        
//    }
//    
//    func hideEditingHandles()  {
//        lastEditedView?.hideEditingHandles()
//    }
//    
//    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
//        
//        if let c = currentlyEditingView {
//        return c.hitTest(touch.locationInView(currentlyEditingView), withEvent: nil) == nil
//        }
//        return true
//        
//    }
    
    var isDownload : Bool?
    @IBOutlet var view2: UIView!
    var addendumApdfInfo : AddendumA?{
        didSet{
//            self.setBuyer2()
            if let c = contractInfo?.status {
                if c == CConstants.ApprovedStatus {
                    addendumApdfInfo?.approvedDate = contractInfo?.approvedate
                }
            }
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
                        case CConstants.ActionTitleBuyersExpect:
                            tool.setBuyersExpectDots(info, additionViews: dots, pdfview: self.pdfView!)
                        case CConstants.ActionTitleWarrantyAcknowledgement:
                            tool.setWarrantyAcknowledegeDots(info, additionViews: dots)
                        case CConstants.ActionTitleHoaChecklist:
                            tool.setHoaChecklistDots(info, additionViews: dots)
                        case CConstants.ActionTitleFloodPlainAck:
                            tool.setFloodPlainAcknowledgementDots(info, additionViews: dots)
                        case CConstants.ActionTitleAddendumHOA:
                            tool.setAddendumHoaDots(info, additionViews: dots)
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
                                if let c = contractInfo?.status {
                                    if c == CConstants.ApprovedStatus {
                                        info.addendumDate = contractInfo?.approvedate
                                    }else{
                                        info.addendumDate = ""
                                    }
                                }else{
                                    info.addendumDate = ""
                                }

                                
                                doc.addedviewss = tool.setAddendumCDots(info, additionViews: dots, pdfview: self.pdfView!, has2Pages0: self.page2!)
                                for sign in doc.addedviewss {
                                    if sign.isKindOfClass(SignatureView) {
                                        if let si = sign as? SignatureView {
                                            if contractInfo?.status != CConstants.ApprovedStatus {
                                                if si.xname.containsString("seller") || si.xname.containsString("bottom3"){
                                                    continue
                                                }
                                            }else{
                                                if si.xname.containsString("buyer")
                                                    || si.xname.containsString("bottom1")
                                                    || si.xname.containsString("bottom2"){
                                                    continue
                                                }
                                            }
                                            
                                            if  !info.buyer!.containsString(" / ")
                                                 && ( si.xname == "buyer2Sign"
                                                || si.xname == "buyer2DateSign")
                                            {
                                                if si.menubtn != nil {
                                                    si.menubtn.removeFromSuperview()
                                                    si.menubtn = nil
                                                }
                                                continue
                                            }
//                                            print(si.xname)
                                            si.pdfViewsssss = pdfView!
                                            pdfView!.addedCCCCAnnotationViews = doc.addedviewss
                                            si.addSignautre(pdfView!.pdfView!.scrollView)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        return
                    default:
                        i += 1
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
                        case CConstants.ActionTitleContract,
                         CConstants.ActionTitleDraftContract:
                            tool.setSignContractDots(info, additionViews: dots, pdfview: self.pdfView!, item: contractInfo)
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
                            i += 1
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
                            if let c = contractInfo?.status {
                                if c == CConstants.ApprovedStatus {
                                    info.txtDate = contractInfo?.approvedate
                                }else{
                                    info.txtDate = ""
                                }
                            }else{
                                info.txtDate = ""
                            }
                            
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
//print(param)
        
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
        var called = true
//        print(filesArray)
        for title in filesArray! {
            if title !=  CConstants.ActionTitleDesignCenter
            && title != CConstants.ActionTitleClosingMemo
            && title != CConstants.ActionTitleAddendumC
                && title != CConstants.ActionTitleContract
                && title != "Contract" {
                if called{
                    self.callService(title, param: param)
                    called = false;
                }
                
            }else{
                self.callService(title, param: param)
            }
            
            var str : String
            
            lastheight = filePageCnt
            
            switch title {
            case CConstants.ActionTitleContract,
            CConstants.ActionTitleDraftContract:
                str = CConstants.PdfFileNameContract
                filePageCnt += CConstants.PdfFileNameContractPageCount
            case CConstants.ActionTitleThirdPartyFinancingAddendum:
                str = CConstants.PdfFileNameThirdPartyFinancingAddendum
                filePageCnt += CConstants.PdfFileNameThirdPartyFinancingAddendumPageCount
            case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
                if contractInfo?.broker == "" {
                    str = CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES
                }else{
                    str = CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES2
                }
                
                filePageCnt += CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICESPageCount
            case CConstants.ActionTitleAddendumA:
                str = CConstants.PdfFileNameAddendumA
                filePageCnt += CConstants.PdfFileNameAddendumAPageCount
            case CConstants.ActionTitleAddendumHOA:
                str = CConstants.PdfFileNameAddendumHOA
                filePageCnt += CConstants.PdfFileNameAddendumHoaPageCount
            case CConstants.ActionTitleAddendumC:
                if self.page2! {
                    str = CConstants.PdfFileNameAddendumC2
                    filePageCnt += CConstants.PdfFileNameAddendumC2PageCount
                }else{
                    str = CConstants.PdfFileNameAddendumC
                    filePageCnt += CConstants.PdfFileNameAddendumCPageCount
                }
             
            case CConstants.ActionTitleBuyersExpect:
                str = CConstants.PdfFileNameBuyersExpect
                filePageCnt += CConstants.PdfFileNameBuyersExpectPageCount
            case CConstants.ActionTitleFloodPlainAck:
                str = CConstants.PdfFileNameFloodPlainAck
                filePageCnt += CConstants.PdfFileNameFloodPlainAckPageCount
                
            case CConstants.ActionTitleHoaChecklist:
                if let c = contractInfo?.hoa {
                    if c == 1{
                        str = CConstants.PdfFileNameHoaChecklist
                    }else{
                        str = CConstants.PdfFileNameHoaChecklist2
                    }
                }else{
                 str = CConstants.PdfFileNameHoaChecklist
                }
                
                filePageCnt += CConstants.PdfFileNameHoaChecklistPageCount
            case CConstants.ActionTitleWarrantyAcknowledgement:
                str = CConstants.PdfFileNameWarrantyAcknowledgement
                filePageCnt += CConstants.PdfFileNameWarrantyAcknowledgementPageCount
                
            case CConstants.ActionTitleAddendumD:
                str = CConstants.PdfFileNameAddendumD
                filePageCnt += CConstants.PdfFileNameAddendumDPageCount
            case CConstants.ActionTitleAddendumE:
                str = CConstants.PdfFileNameAddendumE
                filePageCnt += CConstants.PdfFileNameAddendumEPageCount
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
        pdfView?.delegate = self
        
        //        print(self.document?.forms)
        setAddendumC()
        if let c = contractInfo?.status {
            if c ==  CConstants.ApprovedStatus {
                if filesArray!.contains(CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES){
                    setBrokerDate()
                }
                if filesArray!.contains(CConstants.ActionTitleAddendumD){
                    setAddendumDDate()
                }
                if filesArray!.contains(CConstants.ActionTitleAddendumE){
                    setAddendumEDate()
                }
                if filesArray!.contains(CConstants.ActionTitleFloodPlainAck){
                    setFloodPlainAckDate()
                }
                if filesArray!.contains(CConstants.ActionTitleWarrantyAcknowledgement){
                    setWarrantyAcknowledgement()
                }
                if filesArray!.contains(CConstants.ActionTitleHoaChecklist){
                    setHoaChecklist()
                }
            }
        }
        
    
        
        
        view2.addSubview(pdfView!)
        setBuyer2()
        getAllSignature()

    }
//    static let dd = "WExecutedSign1"
//    static let yyyy = "WYearSign1"
//    static let mmm = "WDayofSign1"
    
    private func setHoaChecklist(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleHoaChecklist:
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "buyer1DateSign1"{
                                    si.value = contractInfo?.approvedate
                                }
                                
                                if let s = contractInfo?.client2 {
                                    if s != "" {
                                        if si.xname == "buyer2DateSign1"{
                                            si.value = contractInfo?.approvedate
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    private func setWarrantyAcknowledgement(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleWarrantyAcknowledgement:
                    var dd  = ""
                    var mmm  = ""
                    var yyyy  = ""
                    if let c = contractInfo?.approveMonthdate {
                        let a = c.componentsSeparatedByString(" ")
                        dd = a[0]
                        mmm = a[1]
                        yyyy = a[2]
                    }
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "WExecutedSign1"{
                                    si.value = dd
                                }
                                
                                if si.xname == "WDayofSign1"{
                                    si.value = mmm
                                }
                                if si.xname == "WYearSign1"{
                                    si.value = yyyy.substringFromIndex(yyyy.startIndex.advancedBy(2))
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    
    
    private func setFloodPlainAckDate(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleFloodPlainAck:
                    var dd  = ""
                    var mmm  = ""
                    var yyyy  = ""
                    if let c = contractInfo?.approveMonthdate {
                        let a = c.componentsSeparatedByString(" ")
                        dd = a[0]
                        mmm = a[1]
                        yyyy = a[2]
                    }
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "FloodDaySign2"{
                                    si.value = dd
                                }
                                
                                if si.xname == "FloodDayofSign2"{
                                    si.value = mmm
                                }
                                if si.xname == "year"{
                                    si.value = yyyy
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    private func setAddendumEDate(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleAddendumE:
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "buyer1DateSign1"{
                                    si.value = contractInfo?.approvedate
                                }
                                
                                if let s = contractInfo?.client2 {
                                    if s != "" {
                                        if si.xname == "buyer2DateSign1"{
                                            si.value = contractInfo?.approvedate
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    private func setAddendumDDate(){
        if let fDD = fileDotsDic {
            //            let tool = SetDotValue()
            //            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleAddendumD:
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "buyer1DateSign1"{
                                    si.value = contractInfo?.approvedate
                                }
                                
                                if let s = contractInfo?.client2 {
                                    if s != "" {
                                        if si.xname == "buyer2DateSign1"{
                                            si.value = contractInfo?.approvedate
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    return
                default:
                    break;
                    //                    i += 1
                }
                
            }
        }
    }
    
    
    private func setBrokerDate(){
        if let fDD = fileDotsDic {
//            let tool = SetDotValue()
//            var i = 0
            for (str, dots) in fDD {
                switch str{
                case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
                    for sign in dots {
                        if sign.isKindOfClass(PDFFormTextField) {
                            if let si = sign as? PDFFormTextField {
                                
                                if si.xname == "brokerbuyer1DateSign1" || si.xname == "broker2buyer1DateSign1"{
                                    si.value = contractInfo?.approvedate
                                }
                                
                                if let s = contractInfo?.client2 {
                                    if s != ""{
                                        if si.xname == "brokerbuyer2DateSign1" || si.xname == "broker2buyer1DateSign2"{
                                            si.value = contractInfo?.approvedate
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                            
                    return
                default:
                    break;
//                    i += 1
                }
                
            }
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userinfo = NSUserDefaults.standardUserDefaults()
        userinfo.setInteger(0, forKey: "ClearDraftInfo")
        if userinfo.boolForKey(CConstants.UserInfoIsContract) {
            self.navigationItem.title = "Contract"
            
            if filesArray != nil {
                switch filesArray![0]{
                case CConstants.ActionTitleAddendumC:
                    self.pageChanged( 6)
                case CConstants.ActionTitleEXHIBIT_B:
                    self.pageChanged( 3)
                case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES,
                    CConstants.ActionTitleAddendumD,
                    CConstants.ActionTitleAddendumE,
                    CConstants.ActionTitleHoaChecklist:
                    self.pageChanged( 1)
                case CConstants.ActionTitleAddendumA:
                    self.pageChanged( 2)
                case CConstants.ActionTitleEXHIBIT_C:
                    self.pageChanged( 4)
                case CConstants.ActionTitleDesignCenter:
                    self.pageChanged( 5)
                default:
                    break
                }
            }
        }else{
            self.navigationItem.title = "Draft"
            buyer1Date.title = ""
            buyer2Date.title = ""
            buyer1Item.title = ""
            buyer2Item.title = ""
            seller1Item.title = ""
            seller2Item.title = ""
        }
        
        
        if filesArray?.count == 1 {
            self.title = filesArray![0]
        }
       
    }
    
    
    // MARK: Request Data
    private func callService(printModelNm: String, param: [String: String]){
//        print(param)
        var serviceUrl: String?
        switch printModelNm{
        case CConstants.ActionTitleDesignCenter:
            serviceUrl = CConstants.DesignCenterServiceURL
        case CConstants.ActionTitleAddendumC:
            return
//            serviceUrl = CConstants.AddendumCServiceURL
        case CConstants.ActionTitleClosingMemo:
            serviceUrl = CConstants.ClosingMemoServiceURL
//        case CConstants.ActionTitleAddendumHOA:
//            return
        case CConstants.ActionTitleContract,
        CConstants.ActionTitleDraftContract:
            serviceUrl = CConstants.ContractServiceURL
      
        default:
            serviceUrl = CConstants.AddendumAServiceURL
        }
//        print(serviceUrl)
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        hud.labelText = CConstants.RequestMsg
        Alamofire.request(.POST,
            CConstants.ServerURL + serviceUrl!,
            parameters: param).responseJSON{ (response) -> Void in
                hud.hide(true)
                if response.result.isSuccess {
                    
                    if let rtnValue = response.result.value as? [String: AnyObject]{
//                        print(rtnValue);
                        if let msg = rtnValue["message"] as? String{
                            if msg.isEmpty{
//                                var vc : PDFBaseViewController?
                                switch printModelNm {
                                
                                case CConstants.ActionTitleClosingMemo:
                                    self.closingMemoPdfInfo = ContractClosingMemo(dicInfo: rtnValue)
                                case CConstants.ActionTitleDesignCenter:
                                    self.designCenterPdfInfo = ContractDesignCenter(dicInfo: rtnValue)
                                case CConstants.ActionTitleContract,
                                CConstants.ActionTitleDraftContract:
                                    self.contractPdfInfo = ContractSignature(dicInfo: rtnValue)
                                
                                default:
//                                    print(rtnValue)
                                    self.addendumApdfInfo = AddendumA(dicInfo: rtnValue)
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
//                        print(one)
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
    
    var senderItem : UIBarButtonItem?
    
    @IBAction func BuyerSign(sender: UIBarButtonItem) {
        return
        if sender.title == "" {
            return;
        }
        self.dismissViewControllerAnimated(true){}
//        print(self.pdfView?.pdfView.scrollView.contentSize.height)
        senderItem = sender
        
        getAllSignature()
        if selfSignatureViews != nil && selfSignatureViews?.count > 0 {
        
            let currentPoint = self.pdfView?.pdfView.scrollView.contentOffset
            for sign in selfSignatureViews! {
                if sender.tag == 3 || sender.tag == 4 {
                    
                    if currentPoint?.y < sign.frame.origin.y {
                        if sign.xname.containsString("bottom")
                            || sign.xname.containsString("eller")
                            || sign.xname.containsString("TitleSign")
                            || sign.xname.containsString("april2Sign"){
                            var frame = sign.frame
                            frame.size.height += 150
                            self.pdfView?.pdfView.scrollView.scrollRectToVisible(frame, animated: false)
                            break;
                        }
                        
                    }
                }else{
                    if currentPoint?.y < sign.frame.origin.y {
                        var frame = sign.frame
                        frame.size.height += 150
                        self.pdfView?.pdfView.scrollView.scrollRectToVisible(frame, animated: false)
                        break;
//                    }else if {
                    
                    }
                }
                
                
            }
            
            self.performSelector(#selector(PDFPrintViewController.afterGotofield), withObject: sender, afterDelay: 0.3)
        }
        
    }
    
    func afterGotofield(){
        if let sender = senderItem {
            if addendumCpdfInfo != nil {
                for doc in documents! {
                    if doc.pdfName == CConstants.ActionTitleAddendumC {
                        for a in doc.addedviewss {
                            if let sign = a as? SignatureView {
                                //                            print(sign.xname)
                                if !CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                    continue
                                }
                                
                                if sender.tag == 1 && sign.xname == "april0Sign"
                                    || sender.tag == 5 && sign.xname == "april1Sign"
                                    || sender.tag == 3 && sign.xname==("april2Sign")
                                    || sender.tag == 2 && sign.xname == "april3DateSign"
                                    || sender.tag == 6 && sign.xname == "april4DateSign"
                                    || sender.tag == 4 && sign.xname==("april5DateSign"){
                                        sign.toSignautre()
                                        return
                                }
                            }
                        }
                        break
                    }
                }
            }
            
            if fileDotsDic != nil {
                for (_, v) in fileDotsDic! {
                    for a in v {
                        if let sign = a as? SignatureView {
                            
                            //                        print(b.tag, b.superview)
                            if !CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                                continue
                            }
                            
                            if sender.tag==3 && sign.xname == "seller2Sign"
                                || sender.tag==4 && sign.xname == "seller3Sign" {
                                    sign.toSignautre()
                                    return
                            }
                            //                          print(sign.xname)
                            if sender.tag == 1 && sign.xname.hasSuffix("bottom1")
                                || sender.tag == 2 && sign.xname.hasSuffix("bottom2")
                                || sender.tag == 3 && sign.xname.hasSuffix("bottom3")
                                || sender.tag == 4 && sign.xname.hasSuffix("bottom4"){
                                    //buyer1
                                    sign.toSignautre()
                                    return
                            }
                            if sender.tag == 1 && sign.xname == ("buyer2Sign")
                                || sender.tag == 2  && sender.title != "Date1" && sign.xname == ("buyer3Sign")
                                || sender.tag == 2  && sender.title == "Date1" && sign.xname.hasSuffix("buyer2DateSign")
                                || sender.tag == 4 && sign.xname == ("Exhibitbp1seller3Sign"){
                                    sign.toSignautre()
                                    return
                            }
                            
                            if self.title == CConstants.ActionTitleAddendumHOA {
                                continue
                            }
                            
                            //broker
                            if addendumApdfInfo != nil{
                                if let hasrealtor = addendumApdfInfo!.hasbroker {
                                    if hasrealtor == "" {
//                                        print(sender.title)
                                        if sender.tag == 1 && sign.xname.hasSuffix("buyer2Sign")
                                            || sender.tag == 2 && sign.xname.hasSuffix("buyer2DateSign")
                                            
                                            || sender.tag == 3 && sign.xname.hasSuffix("buyer3Sign") && !sender.title!.hasPrefix("Seller")
                                            || sender.tag == 4 && sign.xname.hasSuffix("buyer3DateSign"){
                                                sign.toSignautre()
                                                return
                                        }
                                    }else{
                                        if sender.tag == 1 && sign.xname.hasSuffix("buyer2Sign")
                                            || sender.tag == 2 && sign.xname.hasSuffix("buyer2DateSign")
                                            || sender.tag == 3 && sign.xname.hasSuffix("buyer3Sign")
                                            || sender.tag == 4 && sign.xname.hasSuffix("buyer3DateSign"){
                                                sign.toSignautre()
                                                return
                                        }
                                    }
                                }
                                //exhibit c
                                if sender.tag == 1 && sign.xname == "BYSign"
                                    || sender.tag == 2 && sign.xname == "NameSign"
                                    || sender.tag == 4 && sign.xname==("TitleSign"){
                                        sign.toSignautre()
                                        return
                                }
                                
                                //Addendum A
                                if sender.tag == 4 && sign.xname==("AddendumASeller3Sign"){
                                    sign.toSignautre()
                                    return
                                }
                            }
                            
                            
                            
                            
                            if designCenterPdfInfo != nil{
                                
                                if sender.tag == 1 && sign.xname == "homeBuyer1Sign"
                                    || sender.tag == 2 && sign.xname == "homeBuyer1DateSign"
                                    || sender.tag == 3 && sign.xname == "homeBuyer2Sign"
                                    || sender.tag == 4 && sign.xname == "homeBuyer2DateSign"
                                {
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
    

    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y / scrollView.bounds.size.height)
    }
    
    
    @IBAction func  SellerSign(sender: UIBarButtonItem) {
        BuyerSign(sender)
        
    }
    
    @IBOutlet var buyer1Date: UIBarButtonItem!
    @IBOutlet var buyer2Date: UIBarButtonItem!
    @IBOutlet var buyer1Item: UIBarButtonItem!
    @IBOutlet var buyer2Item: UIBarButtonItem!
    @IBOutlet var seller2Item: UIBarButtonItem!
    @IBOutlet var seller1Item: UIBarButtonItem!
    func pageChanged(no: Int) {
        return;
        if no == 0 {
            buyer1Date.title = ""
            buyer2Date.title = ""
            buyer1Item.title = "Buyer1"
            buyer2Item.title = "Buyer2"
            seller1Item.title = "Seller1"
            seller2Item.title = "Seller2"
        } else if no == 1 {
            // broker
            buyer1Date.title = ""
            buyer2Date.title = ""
            buyer1Item.title = "Buyer1"
            buyer2Item.title = "Date1"
            seller1Item.title = "Buyer2"
            seller2Item.title = "Date2"
        } else if no == 2 {
            // addendum a
            buyer1Date.title = ""
            buyer2Date.title = ""
            buyer1Item.title = "Buyer1"
            buyer2Item.title = "Buyer2"
            seller1Item.title = "Seller"
            seller2Item.title = "Day"
        } else if no == 3 {
            // exhibit b
            buyer1Date.title = ""
            buyer2Date.title = ""
            buyer1Item.title = "Buyer1"
            buyer2Item.title = "Buyer2"
            seller1Item.title = ""
            seller2Item.title = "Initial"
        } else if no == 4 {
            // exhibit c
            buyer1Date.title = ""
            buyer2Date.title = ""
            buyer1Item.title = "BY"
            buyer2Item.title = "Name"
            seller1Item.title = ""
            seller2Item.title = "Title"
        } else if no == 5 {
            // Design center
            buyer1Date.title = ""
            buyer2Date.title = ""
            buyer1Item.title = "Buyer1"
            buyer2Item.title = "Date1"
            seller1Item.title = "Buyer2"
            seller2Item.title = "Date2"
        } else if no == 6 {
            // Addendum c
            buyer1Item.title = "Buyer1"
            buyer2Item.title = "Date1"
            buyer1Date.title = "Buyer2"
            buyer2Date.title = "Date2"
            seller1Item.title = "Seller"
            seller2Item.title = "Date"
        }
        
        
    }
    func setBuyer21() {
        
        let a = [buyer1Item, buyer2Item,buyer1Date,buyer2Date,seller1Item,seller2Item]
        for item in a {
            if item.title == "Buyer2" || item.title == "Date2" {
                item.title = ""
            }
        }
    }
    func setBuyer2(){
        
        buyer1Date.title = ""
        buyer2Date.title = ""
        buyer1Item.title = ""
        buyer2Item.title = ""
        seller1Item.title = ""
        seller2Item.title = ""
        var showBuyer2 = false;
        if let contract = self.contractInfo {
            if contract.client2! != "" {
                showBuyer2 = true;
            }
        }
        
        
        
        if let fileDotsDic1 = fileDotsDic{
            for (_,allAdditionViews) in fileDotsDic1 {
                for sign in allAdditionViews {
                    if sign.isKindOfClass(SignatureView) {
//                        print(sign.xname!)
                        if let si = sign as? SignatureView {
                            if contractInfo?.status != CConstants.ApprovedStatus {
                                if si.xname != "p1EBExhibitbp1sellerInitialSign" {
                                    if si.xname.containsString("seller")
                                        || si.xname.containsString("bottom3"){
                                        continue
                                    }
                                }
                                
                            }else{
                                if si.xname == "p1EBExhibitbp1sellerInitialSign" {
                                    continue
                                }else if (si.xname.containsString("buyer")
                                    || si.xname.containsString("bottom1")
                                    || si.xname.containsString("bottom2")
                                    || si.xname.hasSuffix("Sign3")){
                                    continue
                                }
                            }
//                            
                            // remove seller2's signature
                            if si.xname.hasSuffix("bottom4")
                                || si.xname.hasSuffix("seller2Sign")
                                || si.xname.hasSuffix("seller2DateSign")
                            {
                                if si.menubtn != nil {
                                    si.menubtn.removeFromSuperview()
                                    si.menubtn = nil
                                }
                                continue
                            }
                            
                            if !showBuyer2{
                                if si.xname.hasSuffix("bottom2")
                                    || si.xname.hasSuffix("buyer2Sign")
                                || si.xname.hasSuffix("buyer2DateSign")
                                    
                                {
                                    if si.menubtn != nil {
                                        si.menubtn.removeFromSuperview()
                                        si.menubtn = nil
                                    }
                                    continue
                                }
                            }
                           
                            si.pdfViewsssss = pdfView!
                            si.addSignautre(pdfView!.pdfView!.scrollView)
                            
                        }
                    }
                }
            }
        }
        
        let sss = "(\n        (\n        \"{5, 150}\",\n        \"{5, 150}\",\n        \"{5, 149}\",\n        \"{6.5, 143}\",\n        \"{13, 134}\",\n        \"{32, 109}\",\n        \"{80.5, 77}\",\n        \"{154.5, 49}\",\n        \"{251.5, 21.5}\",\n        \"{299, 18.5}\",\n        \"{475, 5}\"\n    )\n)"
        
        if let aaa = sss as? [[Int8]]{
            print("ss")
        }
        
//        if let fileDotsDic1 = fileDotsDic{
//            for (_,allAdditionViews) in fileDotsDic1 {
//                for sign in allAdditionViews {
//                    if sign.isKindOfClass(SignatureView) {
//                        //                        print(sign.xname!)
//                        if let si = sign as? SignatureView {
//                            si.lineArray
//                        }
//                    }
//                }
//            }
//        }
        
    }
        
    var selfSignatureViews: [SignatureView]?
    func getAllSignature(){
        if selfSignatureViews == nil {
            selfSignatureViews = [SignatureView]()
        }else {
            return
        }
        if let dots = pdfView?.pdfWidgetAnnotationViews {
            for d in dots{
                if let sign = d as? SignatureView {
//                    if let addendumaInfo = self.addendumApdfInfo {
//                        if addendumaInfo.hasbroker == "" {
////                            if sign.xname.containsString("brokerb") {
////                                continue
////                            }
//                        }else {
//                            if sign.xname.containsString("broker2") {
//                                continue
//                            }
//                        }
//                    }
                    selfSignatureViews?.append(sign)
                }
            }
        }
        for doc in documents! {
            if let dd = doc.addedviewss {
                for d in dd{
                    if let sign = d as? SignatureView {
                        selfSignatureViews?.append(sign)
                    }
                }
            }
        }
        if selfSignatureViews?.count > 0 {
            selfSignatureViews?.sortInPlace(){
                if $1.frame.origin.y != $0.frame.origin.y {
                    return $1.frame.origin.y > $0.frame.origin.y
                }else{
                    return $1.frame.origin.x > $0.frame.origin.x
                }
            }
        }
        
        
    }
    
    override func startover() {
        let alert: UIAlertController = UIAlertController(title: CConstants.MsgTitle, message: "Are you sure you want to Start Over", preferredStyle: .Alert)
        
        //Create and add the OK action
        let oKAction: UIAlertAction = UIAlertAction(title: "YES", style: .Default) { action -> Void in
            //Do some stuff
            for doc in self.documents! {
                if let dd = doc.addedviewss {
                    for d in dd{
                        if let sign = d as? SignatureView {
                            if (sign.lineArray != nil){
                                sign.lineArray = nil
                                //                sign.originWidth = 0.0
                                //                sign.originHeight = 0.0
                                sign.LineWidth = 0.0
                                sign.showornot = true
                                if sign.menubtn != nil {
                                    sign.superview?.addSubview(sign.menubtn)
                                }else{
                                    sign.addSignautre(self.pdfView!.pdfView!.scrollView)
                                }
                                
                            }
                        }
                    }
                }
                
                
            }
            if let fDD = self.fileDotsDic {
                
                
                for (_, dots) in fDD {
                    
                    for si in dots {
                        if let sign = si as? SignatureView{
                            if (sign.lineArray != nil){
                                sign.lineArray = nil
                                //                sign.originWidth = 0.0
                                //                sign.originHeight = 0.0
                                sign.LineWidth = 0.0
                                sign.showornot = true
                                if sign.menubtn != nil {
                                    sign.superview?.addSubview(sign.menubtn)
                                }else{
                                    sign.addSignautre(self.pdfView!.pdfView!.scrollView)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        alert.addAction(oKAction)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
         alert.addAction(cancelAction)
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
        
        
       
    }
    
   
    
    override func clearDraftInfo() {
        let userInfo = NSUserDefaults.standardUserDefaults()
        userInfo.setInteger(1, forKey: "ClearDraftInfo")
        if self.addendumApdfInfo != nil{
            let a = self.addendumApdfInfo?.Client
            self.addendumApdfInfo?.Client = ""
            self.addendumApdfInfo = self.addendumApdfInfo!
            self.addendumApdfInfo?.Client = a
        }
        
        if self.contractPdfInfo != nil {
            let bmobile = self.contractPdfInfo?.bmobile1!
            let bemail = self.contractPdfInfo?.bemail1
            let client = self.contractPdfInfo?.client
            let client2 = self.contractPdfInfo?.client2
            let tobuyer2 = self.contractPdfInfo?.tobuyer2
            
            self.contractPdfInfo?.bmobile1 = ""
            self.contractPdfInfo?.bemail1 = ""
            self.contractPdfInfo?.client2 = ""
            self.contractPdfInfo?.client = ""
            self.contractPdfInfo?.tobuyer2 = ""
            self.contractPdfInfo = self.contractPdfInfo!
            self.contractPdfInfo?.bmobile1 = bmobile
            self.contractPdfInfo?.bemail1 = bemail
            self.contractPdfInfo?.client2 = client2
            self.contractPdfInfo?.client = client
            self.contractPdfInfo?.tobuyer2 = tobuyer2
        }
        
    }
    
    override func fillDraftInfo() {
        let userInfo = NSUserDefaults.standardUserDefaults()
        userInfo.setInteger(0, forKey: "ClearDraftInfo")
        
        if self.addendumApdfInfo != nil{
            self.addendumApdfInfo = self.addendumApdfInfo!
        }
        
        if self.contractPdfInfo != nil {
            self.contractPdfInfo = self.contractPdfInfo!
        }
        
    }
    

    
    override func saveToServer() {
        
        var b1i : [[String]]?
        var b2i : [[String]]?
        var b1s : [[String]]?
        var b2s : [[String]]?
//        var si : String?
//        var ss : String?
        let contractP = ["p1", "p2", "p3", "p4", "p5", "p6", "p7", "p8", "p9"]
        let thirdParty = ["p1T3", "p2T3"]
        let InforBroker = ["p1I", "p2I"]
        var addendumA : [String] = [String]()
        for i in 1...6 {
            addendumA.append("p\(i)A")
        }
        let EA = ["p1EA"]
        let EB = ["p1EB"]
        let EC = ["p1EC", "p2EC", "p3EC"]
        var BuyerE : [String] = [String]()
        for i in 1...5 {
            BuyerE.append("p\(i)B")
        }
        let AC = ["p1AC", "p2AC"]
        let AD = ["p1AD", "p2AD"]
        let AE = ["p1AE", "p2AE"]
        let Flood = ["p1F", "p2F"]
        let Warraty = ["p1W", "p2W"]
        let Desgin = ["p1D"]
        let HOAC = ["p1H", "p2H"]
        let AH = ["p1AH", "p2AH"]
        
        var nameArray = [[String]]()
        nameArray.append(contractP)
        nameArray.append(thirdParty)
        nameArray.append(InforBroker)
        nameArray.append(addendumA)
        nameArray.append(EA)
        nameArray.append(EB)
        nameArray.append(EC)
        nameArray.append(BuyerE)
        nameArray.append(AC)
        nameArray.append(AD)
        nameArray.append(AE)
        nameArray.append(Flood)
        nameArray.append(Warraty)
        nameArray.append(Desgin)
        nameArray.append(HOAC)
        nameArray.append(AH)
        
        var pdfname = [String]()
        pdfname.append(CConstants.ActionTitleDraftContract)
        pdfname.append(CConstants.ActionTitleThirdPartyFinancingAddendum)
        pdfname.append(CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES)
        pdfname.append(CConstants.ActionTitleAddendumA)
        pdfname.append(CConstants.ActionTitleEXHIBIT_A)
        pdfname.append(CConstants.ActionTitleEXHIBIT_B)
        pdfname.append(CConstants.ActionTitleEXHIBIT_C)
        pdfname.append(CConstants.ActionTitleBuyersExpect)
        pdfname.append(CConstants.ActionTitleAddendumC)
        pdfname.append(CConstants.ActionTitleAddendumD)
        pdfname.append(CConstants.ActionTitleAddendumE)
        pdfname.append(CConstants.ActionTitleFloodPlainAck)
        pdfname.append(CConstants.ActionTitleWarrantyAcknowledgement)
        pdfname.append(CConstants.ActionTitleDesignCenter)
        pdfname.append(CConstants.ActionTitleHoaChecklist)
        pdfname.append(CConstants.ActionTitleAddendumHOA)
        
        let cntArray = [9, 2, 2, 6, 1, 1, 3, 5, 2, 2, 2, 1, 2, 1, 2, 1]
        var b1iynArray : [[String]] = [[String]]()
        var b2iynArray : [[String]] = [[String]]()
        var b1isnArray : [[String]] = [[String]]()
        var b2isnArray : [[String]] = [[String]]()
        for i in 0...(cntArray.count-1){
           
            b1iynArray.append([String]())
            b2iynArray.append([String]())
            b1isnArray.append([String]())
            b2isnArray.append([String]())
            for _ in 0...cntArray[i]-1 {
                b1iynArray[i].append("0")
                b2iynArray[i].append("0")
                b1isnArray[i].append("0")
                b2isnArray[i].append("0")
            }
        }
        
        var alldots = [PDFWidgetAnnotationView]()
        if let a = self.pdfView?.pdfWidgetAnnotationViews as? [PDFWidgetAnnotationView]{
             alldots.appendContentsOf(a)
        }
       
        for doc in documents!{
            if let a = doc.addedviewss as? [PDFWidgetAnnotationView]{
                alldots.appendContentsOf(a)
            }
        }
        
       
            for d in alldots{
                if let sign = d as? SignatureView {
                    if sign.lineArray != nil && sign.xname.hasSuffix("bottom1") || sign.xname.hasSuffix("Sign3") || sign.xname == "p1EBExhibitbp1sellerInitialSign" {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0{
                            if b1i == nil {
//                                b1i = "\(sign.lineArray)"
                                b1i = sign.lineArray as? [[String]]
                            }
                        
                            var cont = sign.xname.hasSuffix("bottom1")
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                        if sign.xname.hasPrefix(name) {
                                            b1iynArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    if sign.xname.hasSuffix("bottom2") {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0{
                            if b2i == nil {
//                                b2i = "\(sign.lineArray)"
                                b2i = sign.lineArray as? [[String]]
                            }
                            var cont = true
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                        if sign.xname.hasPrefix(name) {
                                            b2iynArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
//                    if sign.xname.hasSuffix("bottom3") {
//                        if sign.lineArray.count > 0 && sign.LineWidth > 0  && sign == nil{
//                            si = "\(sign.lineArray)"
//                        }
//                    }
                    if sign.xname.hasSuffix("buyer1Sign") {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0 {
                            if b1s == nil {
//                                b1s = "\(sign.lineArray)"
                                b1s = sign.lineArray as? [[String]]
                            }
                            var cont = true
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                        if sign.xname.hasPrefix(name) {
                                            b1isnArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                    if sign.xname.hasSuffix("buyer2Sign") {
                        if sign.lineArray != nil && sign.lineArray.count > 0 && sign.LineWidth > 0{
                            if b2s == nil {
//                                b2s = "\(sign.lineArray)"
                                 b2s = sign.lineArray as? [[String]]
                            }
                            
                            var cont = true
                            for j in 0...nameArray.count-1 {
                                if cont {
                                    let names = nameArray[nameArray.count-1-j]
                                    for k in 0...names.count-1 {
                                        let name = names[k]
                                        if sign.xname.hasPrefix(name) {
                                            b2isnArray[nameArray.count-1-j][k] = "1"
                                            cont = false
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        
        var param = [String: String]()
        param["idcontract1"] = contractInfo?.idnumber
        param["doc"] = "1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16"
        param["page"] = "9;2;2;6;1;1;3;5;2;2;2;1;2;1;2;1"
//        param["doc"] = "\([1 23;4;5;6;7;8;9;10;11;12;13;14;15;16])"
//        param["page"] = "\(cntArray)"
//        try{
//        let a = NSJSONSerialization.dataWithJSONObject("\(b1iynArray)", options: nil)
//        let c = String(data: a)
//            print(c)
//        }catch{}
//        return
        
//        print(getStr(b1iynArray))
//        return
        
        param["initial_b1yn"] = getStr(b1iynArray)
        
        param["initial_b2yn"] = getStr(b2iynArray)
        param["signature_b1yn"] = getStr(b1isnArray)
        param["signature_b2yn"] = getStr(b2isnArray)
        param["initial_s1yn"] = "0 0 0 0 0 0 0 0 0;0 0;0 0;0 0 0 0 0 0;0;0;0 0 0;0 0 0 0 0;0 0;0 0;0 0;0;0 0;0;0 0;0"
        param["signature_s1yn"] = "0 0 0 0 0 0 0 0 0;0 0;0 0;0 0 0 0 0 0;0;0;0 0 0;0 0 0 0 0;0 0;0 0;0 0;0;0 0;0;0 0;0"
//        param["initial_b1"] = "\(b1i ?? "")"
//        param["initial_b2"] = "\(b2i ?? "")"
//        param["signature_b1"] = "\(b1s ?? "")"
//        param["signature_b2"] = "\(b2s ?? "")"
        param["initial_b1"] = getStr(b1i)
        print(getStr(b1i))
        param["initial_b2"] = getStr(b2i)
        param["signature_b1"] = getStr(b1s)
        param["signature_b2"] = getStr(b2s)
        param["initial_s1"] = " "
        param["signature_s1"] = " "
        
      
        
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = .AnnularDeterminate
        hud?.labelText = CConstants.SavedMsg
        
        
        
//                print(param)
        Alamofire.request(.POST,
            CConstants.ServerURL + "bacontract_save_sign.json",
            parameters: param).responseJSON{ (response) -> Void in
                //                self.hud?.hide(true)
                print(response.result.value)
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? Bool{
                        print(rtnValue)
                        if rtnValue {
                            self.hud?.mode = .CustomView
                            let image = UIImage(named: CConstants.SuccessImageNm)
                            self.hud?.customView = UIImageView(image: image)
                            
                            self.hud?.labelText = CConstants.SavedSuccessMsg
                        }else{
                            self.hud?.mode = .Text
                            self.hud?.labelText = CConstants.SavedFailMsg
                        }
                    }else{
                        self.hud?.mode = .Text
                        self.hud?.labelText = CConstants.MsgServerError
                    }
                }else{
                    self.hud?.mode = .Text
                    self.hud?.labelText = CConstants.MsgNetworkError
                }
                self.performSelector(#selector(PDFBaseViewController.dismissProgress as (PDFBaseViewController) -> () -> ()), withObject: nil, afterDelay: 0.5)
                
    }
    
}

private func getStr(h : [[String]]?) -> String {
    if let a = h {
        var s : [String] = [String]()
        for n in a {
            s.append(n.joinWithSeparator(" "))
        }
        return s.joinWithSeparator(";")
    }else{
        return " "
    }
//    return "\(a)"
    
    
}

func submitLocaiton(a: AnyObject){
    
//    NSURLSessionDataTask postDataTask;
    
//    NSError *error;
//    NSData *data1;
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//    [dic setValue:[NSString stringWithFormat:@"%f", self.myLastLocation.latitude] forKey:@"Latitude"];
//    [dic setValue:[NSString stringWithFormat:@"%f", self.myLastLocation.longitude] forKey:@"Longitude"];
//    [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Token"] forKey:@"Token"];
//    [dic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"TokenScret"] forKey:@"TokenSecret"];
//    
//    if (dic) {
//        data1 =[NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
//    }else{
//        data1=nil;
//    }
    
    
    
    let configuration : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration();
    let session = NSURLSession(configuration: configuration)
    if let url = NSURL(string: CConstants.ServerURL + "bacontract_save_sign.json"){
        let request : NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "POST"
        request.timeoutInterval = 15
        let p =  try! NSJSONSerialization.dataWithJSONObject(a, options: [])
        let s =  NSString(data: p, encoding: NSUTF8StringEncoding)
        print("\(s!)")
        request.HTTPBody =  p
        
        session.dataTaskWithURL(url, completionHandler: { (data, response, error) in
//            if error
            if data != nil {
//               x let d = String(data: data!)
                let s =  NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("\(s!)")
//                print(String(data: data))
            }
        }).resume()
    }
  
    
    
        
//        [NSMutableURLRequest requestWithURL:url
//    cachePolicy:NSURLRequestUseProtocolCachePolicy
//    timeoutInterval:20];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"POST"];
//    [request setTimeoutInterval: 15];
//    [request setHTTPBody:data1];
//    //        NSLog(@"application %@", [[NSString alloc]initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
//    //    NSLog(@"Latitude(%f) Longitude(%f) Accuracy(%f)", self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
//    
//    postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    //        NSLog(@"%@", str);
//    
//    }];
//    [postDataTask resume];
    //    return postDataTask;
    
    
    }}



