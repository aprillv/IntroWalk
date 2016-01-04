//
//  PDFBaseViewController.swift
//  Contract
//
//  Created by April on 12/21/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Alamofire
import MessageUI

class PDFBaseViewController: BaseViewController, DoOperationDelegate, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate, UIPrintInteractionControllerDelegate {
    
    var document : PDFDocument?
    var pdfView  : PDFView?
    var spinner : UIActivityIndicatorView?
//    var spinner : UIActivityIndicatorView? = UIActivityIndicatorView(frame: CGRect(x: 0, y: 4, width: 50, height: 50)){
//        didSet{
//            
//            spinner!.hidesWhenStopped = true
//            spinner!.activityIndicatorViewStyle = .Gray
//        }
//    }
    var progressBar : UIAlertController?
    
    
    var pdfInfo0 : ContractPDFBaseModel?
    
    var fileName: String?
    
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func savePDF(sender: UIBarButtonItem) {
        
        
    }
    func dismissProgress(){
        self.progressBar?.dismissViewControllerAnimated(true, completion: nil)
    }
    func dismissProgress(controller : UIViewController){
        self.progressBar?.dismissViewControllerAnimated(true){
            if controller.isKindOfClass(UIPrintInteractionController){
                //            if let c = controller as? UIPrintInteractionController {
                //                c.dismissAnimated(true)
                //            }
            }else{
                controller.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
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
        
      
        if (spinner == nil){
            spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 4, width: 50, height: 50))
            spinner?.hidesWhenStopped = true
            spinner?.activityIndicatorViewStyle = .Gray
        }
        
        progressBar = UIAlertController(title: nil, message: CConstants.SavedMsg, preferredStyle: .Alert)
        progressBar?.view.addSubview(spinner!)
        
        spinner?.startAnimating()
        self.presentViewController(progressBar!, animated: true, completion: nil)
        
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.ContractUploadPdfURL,
            parameters: parame).responseJSON{ (response) -> Void in
                self.spinner?.stopAnimating()
                self.spinner?.removeFromSuperview()
                if response.result.isSuccess {
                    if let rtnValue = response.result.value as? [String: String]{
                        if rtnValue["status"] == "success" {
                            self.progressBar?.message = CConstants.SavedSuccessMsg
                        }else{
                            self.progressBar?.message = CConstants.SavedFailMsg
                        }
                    }else{
                        self.progressBar?.message = CConstants.MsgServerError
                    }
                }else{
                    self.progressBar?.message = CConstants.MsgNetworkError
                }
                self.performSelector("dismissProgress", withObject: nil, afterDelay: 0.5)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Operations":
                if let tvc = segue.destinationViewController as? SendOperationViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                        tvc.delegate1 = self
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
                self.progressBar = UIAlertController(title: nil, message: CConstants.SendEmailSuccessfullMsg, preferredStyle: .Alert)
                self.presentViewController(self.progressBar!, animated: true, completion: nil)
                self.performSelector("dismissProgress", withObject: nil, afterDelay: 0.5)
            }
        }else {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
//        func  printInteractionControllerDidFinishJob(printInteractionController: UIPrintInteractionController){
//        printInteractionController.dismissAnimated(true)
//        }
//    func printInteractionControllerDidFinishJob(printInteractionController: UIPrintInteractionController) {
//        progressBar?.message = CConstants.PrintSuccessfullMsg
//        self.presentViewController(progressBar!, animated: true, completion: nil)
//        self.performSelector("dismissProgress:", withObject: printInteractionController, afterDelay: 0.5)
//    }
    
    
    
    
    
    //    private func addEntitiesToDictionary(fromDic fromDic: [String: String], toDic: [String: String]?) -> [String: String]{
    //        var rtnDic = toDic ?? [String: String]()
    //        for one in fromDic {
    //            rtnDic[one.0] = one.1
    //        }
    //        return rtnDic
    //    }
}
