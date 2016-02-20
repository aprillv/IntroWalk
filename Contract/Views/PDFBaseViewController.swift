//
//  PDFBaseViewController.swift
//  Contract
//
//  Created by April on 12/21/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Alamofire
import MessageUI

class PDFBaseViewController: BaseViewController, DoOperationDelegate, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate, ToDoPrintDelegate, ToSwitchAddressDelegate {
    
    var document : PDFDocument?
    var pdfView  : PDFView?
    var AddressList : [ContractsItem]? 
//    var spinner : UIActivityIndicatorView?
//    var spinner : UIActivityIndicatorView? = UIActivityIndicatorView(frame: CGRect(x: 0, y: 4, width: 50, height: 50)){
//        didSet{
//            
//            spinner!.hidesWhenStopped = true
//            spinner!.activityIndicatorViewStyle = .Gray
//        }
//    }
  
    
    
    var pdfInfo0 : ContractPDFBaseModel?
    
    var fileName: String?
    
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }
    
    @IBAction func savePDF(sender: UIBarButtonItem) {
        
        
    }
    func dismissProgress(){
        self.clearNotice()
    }
    func dismissProgress(controller : UIViewController){
        self.clearNotice()
//        self.progressBar?.dismissViewControllerAnimated(true){
            if controller.isKindOfClass(UIPrintInteractionController){
                //            if let c = controller as? UIPrintInteractionController {
                //                c.dismissAnimated(true)
                //            }
            }else{
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
//        }
        
    }
    
    func initWithData(data: NSData){
        document = PDFDocument(data: data)
    }
    
    func initWithResource(name: String){
        document = PDFDocument(resource: name)
    }
    
    func initWithPath(path: String){
        document = PDFDocument(resource: path)
    }
    
    func reload(){
        document?.refresh()
        pdfView?.removeFromSuperview()
        pdfView = nil
        loadPDFView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileName = self.navigationItem.title!
        loadPDFView()
    }
    
    
    
    func loadPDFView(){
        
        
    }
    
    
    private struct PDFMargin{
        static let PDFLandscapePadWMargin: CGFloat = 13.0
        static let PDFLandscapePadHMargin: CGFloat = 7.25
        static let PDFPortraitPadWMargin: CGFloat = 9.0
        static let PDFPortraitPadHMargin: CGFloat = 6.10
        static let PDFPortraitPhoneWMargin: CGFloat = 3.5
        static let PDFPortraitPhoneHMargin: CGFloat = 6.7
        static let PDFLandscapePhoneWMargin: CGFloat = 6.8
        static let PDFLandscapePhoneHMargin: CGFloat = 6.5
        
    }
    func getMargins() -> CGPoint {
        let currentOrientation = UIApplication.sharedApplication().statusBarOrientation
        switch (UI_USER_INTERFACE_IDIOM()){
        case .Pad:
            if UIInterfaceOrientationIsPortrait(currentOrientation) {
                return CGPoint(x:PDFMargin.PDFPortraitPadWMargin, y:PDFMargin.PDFPortraitPadHMargin)
            }else{
                return CGPoint(x:PDFMargin.PDFLandscapePadWMargin, y:PDFMargin.PDFLandscapePadHMargin)
            }
            
        default:
            if UIInterfaceOrientationIsPortrait(currentOrientation) {
                return CGPoint(x:PDFMargin.PDFPortraitPhoneWMargin, y:PDFMargin.PDFPortraitPhoneHMargin)
            }else{
                return CGPoint(x:PDFMargin.PDFLandscapePhoneWMargin, y:PDFMargin.PDFLandscapePhoneHMargin)
            }
        }
    }
    
    func savePDFToServer(xname: String){
        //        print(parame)
        var parame : [String : String] = ["idcia" : pdfInfo0!.idcia!
            , "idproject" : pdfInfo0!.idproject!
            , "code" : pdfInfo0!.code!
            ,"filetype" : pdfInfo0!.nproject! + "_\(xname)_FromApp"]
        
        var savedPdfData: NSData?
        if let added = pdfView?.addedAnnotationViews{
            savedPdfData = document?.savedStaticPDFData(added)
        }else{
            savedPdfData = document?.savedStaticPDFData()
        }
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        parame["file"] = fileBase64String
        parame["username"] = NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
        
      self.noticeOnlyText(CConstants.SavedMsg)
        
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.ContractUploadPdfURL,
            parameters: parame).responseJSON{ (response) -> Void in
                self.clearNotice()
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? [String: String]{
                        if rtnValue["status"] == "success" {
                            self.noticeOnlyTextNoSpinner(CConstants.SavedSuccessMsg)
                        }else{
                            self.noticeOnlyTextNoSpinner(CConstants.SavedFailMsg)
                        }
                    }else{
                        self.noticeOnlyTextNoSpinner(CConstants.MsgServerError)
                    }
                }else{
                    self.noticeOnlyTextNoSpinner(CConstants.MsgNetworkError)
                }
                self.performSelector("dismissProgress", withObject: nil, afterDelay: 0.5)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        print(segue.identifier)
        if let identifier = segue.identifier {
            switch identifier {
            case CConstants.SegueToOperationsPopover:
                self.dismissViewControllerAnimated(true, completion: nil)
                if let tvc = segue.destinationViewController as? SendOperationViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                        tvc.delegate1 = self
                    }
                    //                    tvc.text = "april"
                }
            case CConstants.SegueToPrintModelPopover:
                self.dismissViewControllerAnimated(true, completion: nil)
                if let tvc = segue.destinationViewController as? PrintModelTableViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                        tvc.delegate = self
                    }
                    //                    tvc.text = "april"
                }
            case CConstants.SegueToAddressModelPopover:
                self.dismissViewControllerAnimated(true, completion: nil)
                if let tvc = segue.destinationViewController as? AddressListModelViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                        tvc.AddressListOrigin = self.AddressList
                        tvc.delegate = self
                    }
                    //                    tvc.text = "april"
                }
            default: break
            }
        }
    }
    
    
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func saveToServer() {
        savePDFToServer(fileName!)
    }
    
    func doPrint() {
        var savedPdfData : NSData?
        if let added = pdfView?.addedAnnotationViews{
            savedPdfData = document?.savedStaticPDFData(added)
        }else{
            savedPdfData = document?.savedStaticPDFData()
        }
        if UIPrintInteractionController.canPrintData(savedPdfData!) {
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = fileName!
            printInfo.outputType = .Photo
            
            let printController = UIPrintInteractionController.sharedPrintController()
            printController.printInfo = printInfo
            printController.showsNumberOfCopies = false
            
            printController.printingItem = savedPdfData!
            
            printController.presentAnimated(true, completionHandler: nil)
            printController.delegate = self
        }
    }
    
    private func getFileName() -> String{
        return pdfInfo0!.nproject! + "_\(fileName!)_FromApp"
    }
    func sendEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            
            var savedPdfData: NSData?
            if let added = pdfView?.addedAnnotationViews{
                savedPdfData = document?.savedStaticPDFData(added)
            }else{
                savedPdfData = document?.savedStaticPDFData()
            }
            mailComposeViewController.addAttachmentData(savedPdfData!, mimeType: "application/pdf", fileName: getFileName())
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        let userInfo = NSUserDefaults.standardUserDefaults()
        let userEmail = userInfo.objectForKey(CConstants.UserInfoEmail) as? String
        mailComposerVC.setToRecipients([userEmail ?? ""])
        mailComposerVC.setSubject(getFileName())
        mailComposerVC.setMessageBody("This is the \(pdfInfo0!.nproject!)'s contract document of \(fileName!)", isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//        controller.dismissViewControllerAnimated(true, completion: nil)
    
        if let error1 = error{
            self.PopMsgWithJustOK(msg: error1.localizedDescription){ (action) -> Void in
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
        }else if result.rawValue == 2 {
            controller.dismissViewControllerAnimated(true){
                self.noticeOnlyText(CConstants.SendEmailSuccessfullMsg)
                self.performSelector("dismissProgress", withObject: nil, afterDelay: 0.5)
            }
        }else {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func GoToPrint(modelNm: String) {
        if modelNm == CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES {
           if let vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameINFORMATION_ABOUT_BROKERAGE_SERVICES) as? PDFBaseViewController{
            
                    vc.pdfInfo0 = self.pdfInfo0
                    vc.initWithResource(CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES)
            
                vc.AddressList = self.AddressList
                var na = self.navigationController?.viewControllers
                na?.removeLast()
                na?.append(vc)
                self.navigationController?.viewControllers = na!
            }
            
            return
        }
        
        let addendumAAll = [CConstants.ActionTitleAddendumA, CConstants.ActionTitleEXHIBIT_A, CConstants.ActionTitleEXHIBIT_B, CConstants.ActionTitleEXHIBIT_C, CConstants.ActionTitleThirdPartyFinancingAddendum]
//        print(self.navigationItem.title)
        if addendumAAll.contains(self.navigationItem.title!)
            && addendumAAll.contains(modelNm){
            var vc : UIViewController?
            switch modelNm {
            case CConstants.ActionTitleAddendumA:
                vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameAddendumA)
//                print(self.pdfInfo0)
                
                if let ad = vc as? AddendumAViewController{
                    ad.pdfInfo = self.pdfInfo0 as? AddendumA
                     ad.AddressList = self.AddressList
                    ad.initWithResource(CConstants.PdfFileNameAddendumA)
                    
                }
            case CConstants.ActionTitleEXHIBIT_A:
                vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameExhibitA)
                if let ad = vc as? ExhibitAViewController{
                    ad.pdfInfo = self.pdfInfo0 as? AddendumA
                    ad.AddressList = self.AddressList
                    ad.initWithResource(CConstants.PdfFileNameEXHIBIT_A)
                    
                }
            case CConstants.ActionTitleEXHIBIT_B:
                vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameExhibitB)
                if let ad = vc as? ExhibitBViewController{
                    ad.pdfInfo = self.pdfInfo0 as? AddendumA
                    ad.AddressList = self.AddressList
                    ad.initWithResource(CConstants.PdfFileNameEXHIBIT_B)
                    
                }
            case CConstants.ActionTitleEXHIBIT_C:
                vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameExhibitC)
                if let ad = vc as? ExhibitCGeneralViewController{
                    ad.pdfInfo = self.pdfInfo0 as? AddendumA
                    ad.AddressList = self.AddressList
                    ad.initWithResource(CConstants.PdfFileNameEXHIBIT_C)
                    
                }
            case CConstants.ActionTitleThirdPartyFinancingAddendum:
                vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameThirdPartyFinancingAddendum)
                if let ad = vc as? ThirdPartyFinacingAddendumViewController{
                    ad.pdfInfo = self.pdfInfo0 as? AddendumA
                    ad.AddressList = self.AddressList
                    ad.initWithResource(CConstants.PdfFileNameThirdPartyFinancingAddendum)
                    
                }
            default:
                break
            }
            if let vcc = vc {
                var na = self.navigationController?.viewControllers
                na?.removeLast()
                na?.append(vcc)
                self.navigationController?.viewControllers = na!
            }
        }else{
            callService(modelNm, param: ContractRequestItem(contractInfo: nil).DictionaryFromBasePdf(self.pdfInfo0!))
        }
        
        
    }
    
    private func callService(printModelNm: String, param: [String: String]){
        var serviceUrl: String?
        switch printModelNm{
        case CConstants.ActionTitleDesignCenter:
            serviceUrl = CConstants.DesignCenterServiceURL
        case CConstants.ActionTitleAddendumC:
            serviceUrl = CConstants.AddendumCServiceURL
        case CConstants.ActionTitleClosingMemo:
            serviceUrl = CConstants.ClosingMemoServiceURL
        case CConstants.ActionTitleContract:
            serviceUrl = CConstants.ContractServiceURL
        case CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES:
            self.performSegueWithIdentifier(CConstants.SegueToInformationAboutBrokerageServices, sender: nil)
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
                                case CConstants.ActionTitleAddendumA:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameAddendumA)  as? PDFBaseViewController
                                    if let controller = vc as? AddendumAViewController{
                                        controller.pdfInfo = AddendumA(dicInfo: rtnValue)
                                        controller.initWithResource(CConstants.PdfFileNameAddendumA)
                                    }
                                    
                                case CConstants.ActionTitleClosingMemo:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameClosingMemo) as? PDFBaseViewController
                                    if let controller = vc as? ClosingMemoViewController{
                                        controller.pdfInfo = ContractClosingMemo(dicInfo: rtnValue)
                                        controller.initWithResource(CConstants.PdfFileNameClosingMemo)
                                    }
                                case CConstants.ActionTitleDesignCenter:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameDesignCenter) as? PDFBaseViewController
                                    if let controller = vc as? DesignCenterViewController{
                                        controller.pdfInfo = ContractDesignCenter(dicInfo: rtnValue)
                                        controller.initWithResource(CConstants.PdfFileNameDesignCenter)
                                    }
                                case CConstants.ActionTitleContract:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameContract) as? PDFBaseViewController
                                    if let controller = vc as? SignContractViewController{
                                        controller.pdfInfo = ContractSignature(dicInfo: rtnValue)
                                        controller.initWithResource(CConstants.PdfFileNameContract)
                                    }
                                case CConstants.ActionTitleThirdPartyFinancingAddendum:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameThirdPartyFinancingAddendum) as? PDFBaseViewController
                                    if let controller = vc as? ThirdPartyFinacingAddendumViewController{
                                        controller.pdfInfo = AddendumA(dicInfo: rtnValue)
                                        controller.initWithResource(CConstants.PdfFileNameThirdPartyFinancingAddendum)
                                    }
                                case CConstants.ActionTitleEXHIBIT_A:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameExhibitA) as? PDFBaseViewController
                                    if let controller = vc as? ExhibitAViewController{
                                        controller.pdfInfo = AddendumA(dicInfo: rtnValue)
                                        controller.initWithResource(CConstants.PdfFileNameEXHIBIT_A)
                                    }
                                case CConstants.ActionTitleEXHIBIT_B:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameExhibitB) as? PDFBaseViewController
                                    if let controller = vc as? ExhibitBViewController{
                                        controller.pdfInfo = AddendumA(dicInfo: rtnValue)
                                        controller.initWithResource(CConstants.PdfFileNameEXHIBIT_B)
                                    }
                                case CConstants.ActionTitleEXHIBIT_C:
                                    vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameExhibitC) as? PDFBaseViewController
                                    if let controller = vc as? ExhibitCGeneralViewController{
                                        controller.pdfInfo = AddendumA(dicInfo: rtnValue)
                                        controller.initWithResource(CConstants.PdfFileNameEXHIBIT_C)
                                    }
                                default:
                                    break;
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
    
    func GoToAddress(item : ContractsItem) {
        if self.navigationItem.title! == CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES {
            if let vc = UIStoryboard(name: CConstants.StoryboardName, bundle: nil).instantiateViewControllerWithIdentifier(CConstants.ControllerNameINFORMATION_ABOUT_BROKERAGE_SERVICES) as? PDFBaseViewController{
                
                vc.pdfInfo0 = self.pdfInfo0
                vc.pdfInfo0?.nproject = item.nproject
                vc.pdfInfo0?.idcia = item.idcia
                vc.pdfInfo0?.idcity = item.idcity
                vc.pdfInfo0?.idnumber = item.idnumber
                vc.pdfInfo0?.idproject = item.idproject
                vc.pdfInfo0?.code = item.code
                vc.initWithResource(CConstants.PdfFileNameINFORMATION_ABOUT_BROKERAGE_SERVICES)
                
                vc.AddressList = self.AddressList
                var na = self.navigationController?.viewControllers
                na?.removeLast()
                na?.append(vc)
                self.navigationController?.viewControllers = na!
            }
            
            return
        }
        
        self.callService(self.navigationItem.title!, param: ContractRequestItem(contractInfo: item).DictionaryFromObject())
    }
    
    
}
