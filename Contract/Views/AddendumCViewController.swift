//
//  AddendumCViewController.swift
//  Contract
//
//  Created by April on 12/10/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class AddendumCViewController: BaseViewController {

    var document : PDFDocument?
    var pdfView  : PDFView?
    var isDownload : Bool?
    var pdfInfo : ContractAddendumC?
    var spinner : UIActivityIndicatorView?
    var progressBar : UIAlertController?
    
    private struct PDFFields{
        
        static let SavedMsg = "Saving to the BA Server"
        static let SavedSuccessMsg = "Saved successfully."
        static let SavedFailMsg = "Saved fail."
        
        
        
        static let CompanyName = "txtCiaNm"
        static let Address = "txtAddress"
        static let CityStateZip = "txtCityStateZip"
        static let TelFax = "txtTelFax"
        static let DateL = "txtDate"
        static let IdNo = "txtIdNumber"
        static let ContractDate = "txtContractDate"
        static let EstimatedCompletion = "txtEstimatedCompletion"
        static let EstamatedClosing = "txtEstamatedClosing"
        static let StageContract = "txtStageContract"
        static let JobAddress = "txtJobAddress"
        static let Buyer = "txtBuyer"
        static let Consultant = "txtConsultant"
        static let SubDivision  = "txtSubDivision"
        static let Price  = "txtPrice"
        
        static let SignArray : [String] = [
              "Homebuyer # 1 - Sign"
            , "Homebuyer # 2 - Sign"
            , "Consultant - Sign"
            , "Homebuyer # 1 - Date"
            , "Homebuyer # 1 - Date"
            , "Consultant - Date"]
        
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func BuyerSign(sender: UIBarButtonItem) {
        
//        for sign0 in pdfView!.pdfWidgetAnnotationViews {
//            if let sign = sign0 as? SignatureView{
//                if (    sender.tag == 1 && sign.sname.hasSuffix(PDFFields.Buyer1Signature))
//                    || (sender.tag == 2 && sign.sname.hasSuffix(PDFFields.Buyer2Signature))
//                    || (sender.tag == 3 && sign.sname.hasSuffix(PDFFields.Seller1Signature))
//                    || (sender.tag == 4 && sign.sname.hasSuffix(PDFFields.Seller2Signature)){
//                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
//                            sign.toSignautre()
//                            return
//                        }
//                }
//                
//            }
//        }
//        for sign0 in pdfView!.pdfWidgetAnnotationViews {
//            if let sign = sign0 as? SignatureView{
//                if (    sender.tag == 1 && sign.sname == PDFFields.buyer2Sign)
//                    || (sender.tag == 2 && sign.sname == PDFFields.buyer3Sign)
//                    || (sender.tag == 3 && sign.sname == PDFFields.seller2Sign)
//                    || (sender.tag == 4 && sign.sname == PDFFields.seller3Sign){
//                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
//                            sign.toSignautre()
//                            return
//                        }
//                }
//                
//            }
//        }
    }
    @IBAction func savePDF(sender: UIBarButtonItem) {
//        return
        let savedPdfData = document?.savedStaticPDFData(pdfView?.addedAnnotationViews)
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let parame : [String : String] = ["idcia" : pdfInfo!.idcia!
            , "idproject" : pdfInfo!.idproject!
            , "username" : NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
            , "code" : pdfInfo!.code!
            , "file" : fileBase64String!]
//        print(parame)
        if (spinner == nil){
            spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 4, width: 50, height: 50))
            spinner?.hidesWhenStopped = true
            spinner?.activityIndicatorViewStyle = .Gray
        }
        
        progressBar = UIAlertController(title: nil, message: PDFFields.SavedMsg, preferredStyle: .Alert)
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
                            self.progressBar?.message = PDFFields.SavedSuccessMsg
                        }else{
                            self.progressBar?.message = PDFFields.SavedFailMsg
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
    func dismissProgress(){
        self.progressBar?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initWithData(data: NSData){
        isDownload = true
        document = PDFDocument(data: data)
    }
    
    func initWithResource(name: String){
        isDownload = false
        document = PDFDocument(resource: name)
    }
    
    func initWithPath(path: String){
        isDownload = false
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
        navigationItem.hidesBackButton = true
        loadPDFView()
    }
    
    private func addEntitiesToDictionary(fromDic fromDic: [String: String], toDic: [String: String]?) -> [String: String]{
        var rtnDic = toDic ?? [String: String]()
        for one in fromDic {
            rtnDic[one.0] = one.1
        }
        return rtnDic
    }
    
    private func getFileName() -> String{
        return "contract1pdf_" + self.pdfInfo!.idcity! + "_" + self.pdfInfo!.idcia!
    }
    
    private func loadPDFView(){
        let pass = document?.documentPath ?? document?.documentData
        let margins = getMargins()
        var additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y) as? [PDFWidgetAnnotationView]
        var aPrice : PDFFormTextField?
        var aCiaName : PDFWidgetAnnotationView?
        var aStage : PDFWidgetAnnotationView?
        for pv : PDFWidgetAnnotationView in additionViews!{
                switch pv.xname {
                case PDFFields.CompanyName:
                    aCiaName = pv
                    pv.value = pdfInfo?.cianame!
                case PDFFields.Address:
                    pv.value = pdfInfo?.ciaaddress!
                case PDFFields.CityStateZip:
                    pv.value = pdfInfo?.ciacityzip!
                case PDFFields.TelFax:
                    pv.value = pdfInfo?.ciatelfax!
                case PDFFields.IdNo:
                    pv.value = pdfInfo?.addendumNo!
                case PDFFields.DateL:
                    pv.value = pdfInfo?.addendumDate!
                case PDFFields.ContractDate:
                    pv.value = pdfInfo?.contractdate!
                case PDFFields.EstimatedCompletion:
                    pv.value = pdfInfo?.estimatedcompletion!
                case PDFFields.EstamatedClosing:
                    pv.value = pdfInfo?.estimatedclosing!
                case PDFFields.StageContract:
                    pv.value = pdfInfo?.stage!
                    aStage = pv
                case PDFFields.JobAddress:
                    pv.value = pdfInfo?.jobaddress!
                case PDFFields.Buyer:
                    pv.value = pdfInfo?.buyer!
                case PDFFields.Consultant:
                    pv.value = pdfInfo?.consultant!
                case PDFFields.SubDivision:
                    pv.value = pdfInfo?.subdivision!
                case PDFFields.Price:
                    aPrice = pv as? PDFFormTextField
                    pv.value = pdfInfo?.price!
                default:
                    break
                }
           
        }
        
        var addedAnnotationViews : [PDFWidgetAnnotationView] = [PDFWidgetAnnotationView]()
        if let price = aPrice {
            var pf : PDFFormTextField?
            var line : PDFWidgetAnnotationView?
            var x : CGFloat = aCiaName!.frame.origin.x
            var y : CGFloat = price.frame.origin.y + price.frame.size.height + 20
            let w : CGFloat = (aStage!.frame.width + aStage!.frame.origin.x - aCiaName!.frame.origin.x)
            var h : CGFloat = price.frame.height
            if let list = pdfInfo?.itemlist {
                for items in list {
//                    UIFont *font = [UIFont fontWithName:@"Verdana" size:floor()];
                    let font = floor(aPrice!.currentFontSize())
                    let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: w-30, height: h));
                    lbl.font = UIFont(name: "Verdana", size: font)
                    lbl.numberOfLines = 0
                    lbl.text = items.xdescription!
                    lbl.sizeToFit()
                    print(lbl.frame)
                    pf = PDFFormTextField(frame: CGRect(x: x, y: y+3, width: 20, height: h), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true, withFont: font)
                    pf?.xname = "april"
                    pf?.value = items.xitem!
                    addedAnnotationViews.append(pf!)
                    
                    pf = PDFFormTextField(frame: CGRect(x: x+20, y: y, width: w-20, height: h), multiline: true, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true, withFont: font)
                    
                    pf?.xname = "april"
                    
                    pf?.value = items.xdescription!
                    addedAnnotationViews.append(pf!)
//                    print(pf?.frame)
                    pf?.sizeToFit()
//                    print(pf?.frame)
//                    pf = PDFFormTextField(frame: pf!.frame, multiline: true, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true, withFont: font)
                    y = y + pf!.frame.height + 2
                    line = PDFWidgetAnnotationView(frame: CGRect(x: x, y: y, width: w, height: 0.5))
                    line?.backgroundColor = UIColor.lightGrayColor()
                    addedAnnotationViews.append(line!)
                    
                    y = y + 5.5
                }
            }
            
            y = y + 22
            pf = PDFFormTextField(frame: CGRect(x: x, y: y, width: w, height: h), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true)
            pf?.xname = "april"
            y = y + price.frame.size.height + 2
            pf?.value = pdfInfo?.agree!
            addedAnnotationViews.append(pf!)
            
            y = y + h
            h = w * 0.0521
            var sign : SignatureView?
            for i: Int in 0...5 {
                
                sign = SignatureView(frame: CGRect(x: x, y: y, width: w * 0.28, height: h))
                sign?.xname = "aprilSign"
                addedAnnotationViews.append(sign!)
                
                
                line = PDFWidgetAnnotationView(frame: CGRect(x: x, y: y + h, width: w * 0.28, height: 0.5))
                line?.backgroundColor = UIColor.lightGrayColor()
                addedAnnotationViews.append(line!)
                
                pf = PDFFormTextField(frame: CGRect(x: x, y: y + h + 5 , width: w * 0.28, height: price.frame.height), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true)
                pf?.xname = "april"
                pf?.value = PDFFields.SignArray[i]
                addedAnnotationViews.append(pf!)
                x += w * 0.36
                
                if (i == 2) {
                    x = aCiaName!.frame.origin.x
                    y = y + w * 0.1
                }
                
            }
            
            additionViews?.appendContentsOf(addedAnnotationViews)
            pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
            pdfView?.addedAnnotationViews = addedAnnotationViews
            view.addSubview(pdfView!)
        }
        
        
        
        
        
        
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
    private func getMargins() -> CGPoint {
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

//    @IBAction func savePDF(sender: UIBarButtonItem) {
//        
//        let savedPdfData = toPDF([cianame])
//        let s = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
//        let parame = ["username": "April for test", "code": "655443546", "file": s!,"idcia": "9999", "idproject": "100005"]
//        print(parame)
//        Alamofire.request(.POST,
//            CConstants.ServerURL + CConstants.ContractUploadPdfURL,
//            parameters: parame).responseJSON{ (response) -> Void in
////                self.spinner?.stopAnimating()
////                self.spinner?.removeFromSuperview()
//                if response.result.isSuccess {
//                    if let rtnValue = response.result.value as? [String: String]{
//                        if rtnValue["status"] == "success" {
//                            print("aaa")
////                            self.progressBar?.message = PDFFields.SavedSuccessMsg
//                        }else{
////                            self.progressBar?.message = PDFFields.SavedFailMsg
//                        }
//                    }else{
////                        self.progressBar?.message = CConstants.MsgServerError
//                    }
//                }else{
////                    self.progressBar?.message = CConstants.MsgNetworkError
//                }
////                self.performSelector("dismissProgress", withObject: nil, afterDelay: 0.5)
//        }
//        
//    }

    
}
