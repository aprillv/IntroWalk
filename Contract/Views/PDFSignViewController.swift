//
//  PDFSignViewController.swift
//  Contract
//
//  Created by April on 12/1/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class PDFSignViewController: BaseViewController {

    var document : PDFDocument?
    var pdfView  : PDFView?
    var isDownload : Bool?
    var pdfInfo : ContractSignature?
    var spinner : UIActivityIndicatorView?
    var progressBar : UIAlertController?
    
    private struct PDFFields{
        
        static let SavedMsg = "Saving to the BA Server"
        static let SavedSuccessMsg = "Saved successfully."
        static let SavedFailMsg = "Saved fail."
        
        static let Buyer1Signature = "bottom1"
        static let Buyer2Signature = "bottom2"
        static let Seller1Signature = "bottom3"
        static let Seller2Signature = "bottom4"
        
        static let CompanyName = "sellercompany"
        static let Buyer = "buyer"
        static let Lot = "lot"
        static let Block = "block1"
        static let Section = "block2"
        static let City = "city"
        static let County = "county"
        static let Address_zip = "address_zip"
        static let Address = "address"
        static let SalePrice = "saleprice"
        
        static let CompanyName1 = "cianame"
        static let Buyer1 = "client"
        static let Lot1 = "lot"
        static let Block1 = "block"
        static let Section1 = "section"
        static let City1 = "cityname"
        static let County1 = "county"
        static let Address1 = "nproject"
        static let SalePrice1 = "sold"
        
        static let cashportion  = "3a"
        
        static let financing  = "3b"
        
        static let estimatedclosing_MMdd = "9a1"
        
        static let estimatedclosing_yy = "9a2"
        
        static let tobuyer1 = "tobuyer1"
        
        static let tobuyer2 = "tobuyer2"
        
        static let tobuyer3 = "tobuyer3"
        static let tobuyer4 = "tobuyer4"
        static let tobuyer5 = "tobuyer5"
        static let tobuyer6 = "tobuyer6"
        
        static let tobuyer7 = "tobuyer7"
        
        static let executeddd = "executeddd"
        
        static let executedmm = "executedmm"
        static let executedyy = "executedyy"
        static let buyer_2 = "buyer_2"
        static let buyer_3 = "buyer_3"
        static let seller_3 = "seller_3"
        static let pdf2211 = "2211"
        static let pdf2212 = "2212"
        
        static let pdf22a15 = "22a15"
        static let pdf22a3 = "22a3"
        static let pdf22a10 = "22a10"
        
        static let buyer2Sign = "buyer2Sign"
        static let buyer3Sign = "buyer3Sign"
        static let seller2Sign = "seller2Sign"
        static let seller3Sign = "seller3Sign"
        
    }
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func BuyerSign(sender: UIBarButtonItem) {
    
        for sign0 in pdfView!.pdfWidgetAnnotationViews {
            if let sign = sign0 as? SignatureView{
                if (    sender.tag == 1 && sign.sname.hasSuffix(PDFFields.Buyer1Signature))
                    || (sender.tag == 2 && sign.sname.hasSuffix(PDFFields.Buyer2Signature))
                    || (sender.tag == 3 && sign.sname.hasSuffix(PDFFields.Seller1Signature))
                    || (sender.tag == 4 && sign.sname.hasSuffix(PDFFields.Seller2Signature)){
                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                            sign.toSignautre()
                            return
                        }
                }
                
            }
        }
        for sign0 in pdfView!.pdfWidgetAnnotationViews {
            if let sign = sign0 as? SignatureView{
                if (    sender.tag == 1 && sign.sname == PDFFields.buyer2Sign)
                    || (sender.tag == 2 && sign.sname == PDFFields.buyer3Sign)
                    || (sender.tag == 3 && sign.sname == PDFFields.seller2Sign)
                    || (sender.tag == 4 && sign.sname == PDFFields.seller3Sign){
                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                            sign.toSignautre()
                            return
                        }
                }
                
            }
        }
    }
    @IBAction func savePDF(sender: UIBarButtonItem) {
        
        let savedPdfData = document?.savedStaticPDFData()
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let parame : [String : String] = ["idcia" : pdfInfo!.idcia!
            , "idproject" : pdfInfo!.idproject!
            , "username" : NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
            , "code" : pdfInfo!.code!
            , "file" : fileBase64String!]
        
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
        let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y) as? [PDFWidgetAnnotationView]
        
        if let filedsFromTxt = readContractFieldsFromTxt(getFileName()) {
            
            
            let na = filedsFromTxt.keys
            for pv : PDFWidgetAnnotationView in additionViews!{
                if na.contains(pv.xname){
                    pv.value = filedsFromTxt[pv.xname]
                }
            }
            
        }
        
        var tobuyer3 : String
        var tobuyer4 : String
        if let b = pdfInfo?.bmobile1 == "" ? pdfInfo?.boffice1! : pdfInfo?.bmobile1! {
            let a = b.componentsSeparatedByString("-")
            if a.count > 2 {
                tobuyer3 = a[0]
                if tobuyer3.characters.count != 3 {
                    tobuyer3 = ""
                    tobuyer4 = b
                }else{
                    let index1 = b.startIndex.advancedBy(4)
                    tobuyer4 = b.substringFromIndex(index1)
                }
                
                
            }else{
                tobuyer3 = ""
                tobuyer4 = ""
            }
        }else{
            tobuyer3 = ""
            tobuyer4 = ""
        }
        
        
        var tobuyer5 : String
        var tobuyer6 : String
        if let b = pdfInfo?.bfax1! {
            let a = b.componentsSeparatedByString("-")
            if a.count > 2 {
                tobuyer5 = a[0]
                let index1 = b.startIndex.advancedBy(4)
                tobuyer6 = b.substringFromIndex(index1)
            }else{
                tobuyer5 = ""
                tobuyer6 = ""
            }
        }else{
            tobuyer5 = ""
            tobuyer6 = ""
        }
        
        
        var overrideFields : [String: String]
        overrideFields = [PDFFields.CompanyName : PDFFields.CompanyName1
            , PDFFields.Buyer : PDFFields.Buyer1
            , PDFFields.Lot: PDFFields.Lot1
            , PDFFields.Block : PDFFields.Block1
            , PDFFields.Section : PDFFields.Section1
            , PDFFields.City : PDFFields.City1
            , PDFFields.County : PDFFields.County1
            , PDFFields.Address : PDFFields.Address1
            , PDFFields.Address_zip : PDFFields.Address1
            , PDFFields.SalePrice : PDFFields.SalePrice1]
        
        pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
        let na = overrideFields.keys
        for pv : PDFWidgetAnnotationView in additionViews!{
            if na.contains(pv.xname){
                if PDFFields.Address_zip == pv.xname{
                    
                    if pdfInfo!.zipcode! != "" {
                        pv.value = "\(pdfInfo!.nproject!)/\(pdfInfo!.zipcode!)"
                    }else{
                        pv.value = pdfInfo!.nproject!
                    }
                }else if PDFFields.Address == pv.xname{
                    pv.value = pdfInfo!.nproject
                }else if(PDFFields.Buyer == pv.xname){
                    if (pdfInfo!.client2 != ""){
                        pv.value = pdfInfo!.client! + " and " + pdfInfo!.client2!
                    }else{
                        pv.value = pdfInfo!.client!
                    }
                
                }else{
                    if let a = overrideFields[pv.xname!]{
                        pv.value = pdfInfo!.valueForKey(a) as! String
                    }
                    
                }
            }else {
                
                switch pv.xname {
                case PDFFields.cashportion:
                    pv.value = pdfInfo?.cashportion! == "" ? "0.00" : pdfInfo?.cashportion!
                    
                case PDFFields.financing:
                    pv.value = pdfInfo?.financing!
                case PDFFields.estimatedclosing_MMdd:
                    pv.value = pdfInfo?.estimatedclosing_MMdd!
                case PDFFields.estimatedclosing_yy:
                    pv.value = pdfInfo?.estimatedclosing_yy!
                case PDFFields.tobuyer1:
                    pv.value = pdfInfo?.client!
                case PDFFields.tobuyer2:
                    pv.value = pdfInfo?.tobuyer2!
                case PDFFields.tobuyer3:
                    pv.value = tobuyer3
                case PDFFields.tobuyer4:
                    pv.value = tobuyer4
                case PDFFields.tobuyer5:
                    pv.value = tobuyer5
                case PDFFields.tobuyer6:
                    pv.value = tobuyer6
                case PDFFields.tobuyer7:
                    pv.value = pdfInfo?.bemail1!
                case PDFFields.executeddd:
                    pv.value = pdfInfo?.executeddd!
                case PDFFields.executedmm:
                    pv.value = pdfInfo?.executedmm!
                case PDFFields.executedyy:
                    pv.value = pdfInfo?.executedyy!
                case PDFFields.buyer_2:
                    pv.value = pdfInfo?.client!
                case PDFFields.buyer_3:
                    pv.value = pdfInfo?.client2!
                case PDFFields.seller_3:
                    pv.value = pdfInfo?.cianame!
                case PDFFields.pdf2211:
                    pv.value = pdfInfo?.trec1!
                case PDFFields.pdf2212:
                    pv.value = pdfInfo?.trec2!
                case PDFFields.pdf22a15:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == pv.xname + "2" {
                            radio.value = pdfInfo?.other! == "1" ? pv.xname + "2" : ""
                        }
                    }
                case PDFFields.pdf22a3:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == pv.xname + "2" {
                            radio.value = pdfInfo?.hoa! == "1" ? pv.xname + "2" : ""
                        }
                    }
                case PDFFields.pdf22a10:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == pv.xname + "2" {
                            radio.value = pdfInfo?.environment! == "1" ? pv.xname + "2" : ""
                        }
                    }
//                case "buyer_2", "buyer_3", "seller_2", "seller_3":
//                case "buyer_2":
                    
                    
                default:
                    break
                }
            }
            if let sign = pv as? SignatureView{
                sign.pdfViewsssss = pdfView
            }
        }
        
        
        view.addSubview(pdfView!)
        
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
    
}
