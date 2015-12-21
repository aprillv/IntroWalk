//
//  AddendumCViewController.swift
//  Contract
//
//  Created by April on 12/10/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class AddendumCViewController: PDFBaseViewController {
    
    var pdfInfo : ContractAddendumC?{
        didSet{
            pdfInfo0 = pdfInfo;
            pdfInfo?.nproject = pdfInfo?.jobaddress
        }
    }
    var sender: UIBarButtonItem?
    
    private struct PDFFields{
        
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
    
    
    @IBAction func BuyerSign(sender0: UIBarButtonItem) {
        sender = sender0;
        self.pdfView!.pdfView.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.pdfView!.pdfView.scrollView.contentSize.height - self.pdfView!.pdfView.scrollView.frame.size.height, width: 100, height: self.pdfView!.pdfView.scrollView.frame.size.height), animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "signature", userInfo: sender, repeats: false)
        
    }
    func signature(){
        for sign0 in pdfView!.pdfWidgetAnnotationViews {
            if let sign = sign0 as? SignatureView{
                if (    sender!.tag == 1 && sign.xname.hasSuffix("0Sign"))
                    || (sender!.tag == 2 && sign.xname.hasSuffix("1Sign"))
                    || (sender!.tag == 3 && sign.xname.hasSuffix("2Sign")) {
                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                            sign.toSignautre()
                            return
                        }
                }
                
            }
        }
    }
    @IBAction override func savePDF(sender: UIBarButtonItem) {
//        return
        let savedPdfData = document?.savedStaticPDFData(pdfView?.addedAnnotationViews)
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let parame : [String : String] = ["idcia" : pdfInfo!.idcia!
            , "idproject" : pdfInfo!.idproject!
            , "username" : NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
            , "code" : pdfInfo!.code!
            , "file" : fileBase64String!
            , "filetype" : pdfInfo!.jobaddress! + "_AddendumC_FromApp"]
//        print(parame)
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
   
    
   
    
    override func loadPDFView(){
        
        let pass = document?.documentPath ?? document?.documentData
        var has2Pages = false
        if let apass = pass as? String{
            if apass.hasSuffix("2.pdf"){
                has2Pages = true
            }
        }
        let margins = getMargins()
        var additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y) as? [PDFWidgetAnnotationView]
        var aPrice : PDFFormTextField?
        var aPrice2 : PDFFormTextField?
        var aPrice3 : PDFFormTextField?
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
                    if (aPrice3 == nil) {
                        aPrice3 = pv as? PDFFormTextField
                    }else{
                        aPrice2 = pv as? PDFFormTextField
                    }
                    pv.value = pdfInfo?.price!
                default:
                    break
                }
           
        }
        
        if has2Pages {
            if aPrice3?.frame.origin.y > aPrice2?.frame.origin.y {
                aPrice = aPrice2
                aPrice2 = aPrice3
            }else{
                aPrice = aPrice3
            }
        }else{
            aPrice = aPrice3
        }
        
        var addedAnnotationViews : [PDFWidgetAnnotationView] = [PDFWidgetAnnotationView]()
        if let price = aPrice {
            var pf : PDFFormTextField?
            var line : PDFWidgetAnnotationView?
            var x : CGFloat = aCiaName!.frame.origin.x
            var y : CGFloat = price.frame.origin.y + price.frame.size.height + 20
            let w : CGFloat = (aStage!.frame.width + aStage!.frame.origin.x - aCiaName!.frame.origin.x)
            var h : CGFloat = price.frame.height
            if let list = pdfInfo?.itemlistStr {
                var i: Int = 0
                for items in list {
                    i += 1
                    let font = floor(aPrice!.currentFontSize())
                    pf = PDFFormTextField(frame: CGRect(x: x, y: y, width: 25, height: h), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true, withFont: font)
                    pf?.xname = "april"
                    pf?.value = "\(i)"
                    addedAnnotationViews.append(pf!)
//                    print( "number \(pf?.frame) \(y)")
                    for description in items {
//                        print("----" + a.substringWithRange(glyphRange))
                        pf = PDFFormTextField(frame: CGRect(x: x+25, y: y, width: w-25, height: h), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true, withFont: font)
                        pf?.xname = "april"
                        pf?.value = description
                        addedAnnotationViews.append(pf!)
                        //                            pf?.sizeToFit()
                        y = y + pf!.frame.height
                        //                            print( "text \(pf?.frame)")
                    }
                    
                    y = y + 2
                    line = PDFWidgetAnnotationView(frame: CGRect(x: x, y: y, width: w, height: 1))
                    line?.backgroundColor = UIColor.lightGrayColor()
                    addedAnnotationViews.append(line!)
//                    print( "line \(line?.frame) \(y)")
                    y = y + 5.5
                    
                    if has2Pages && y+50 > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) {
                        has2Pages = false
                        y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
                    }
                    
                }
            }
            
            y = y + 22
            if has2Pages && y+50 > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) {
                has2Pages = false
                y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
            }
            pf = PDFFormTextField(frame: CGRect(x: x, y: y, width: w, height: h), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true)
            pf?.xname = "april"
            y = y + price.frame.size.height + 2
            pf?.value = pdfInfo?.agree!
            addedAnnotationViews.append(pf!)
            
            y = y + h
            if has2Pages && y+50 > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) {
                has2Pages = false
                y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
            }
            h = w * 0.0521
            var sign : SignatureView?
            for i: Int in 0...5 {
                
                sign = SignatureView(frame: CGRect(x: x, y: y, width: w * 0.28, height: h))
                sign?.xname = "april" + "\(i)" + "Sign"
                
                addedAnnotationViews.append(sign!)
                
                
                line = PDFWidgetAnnotationView(frame: CGRect(x: x, y: y + 2+h, width: w * 0.28, height: 1))
                line?.backgroundColor = UIColor.lightGrayColor()
                addedAnnotationViews.append(line!)
                
                pf = PDFFormTextField(frame: CGRect(x: x, y: y + h + 3 , width: w * 0.28, height: price.frame.height), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true)
                pf?.xname = "april"
                pf?.value = PDFFields.SignArray[i]
                addedAnnotationViews.append(pf!)
                x += w * 0.36
                
                if (i == 2) {
                    x = aCiaName!.frame.origin.x
                    y = y + w * 0.1
//                    if has2Pages && y+50 > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) {
//                        y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
//                    }
                    if has2Pages {
                        y = aPrice2!.frame.origin.y + aPrice2!.frame.size.height + 20
                    }
                }
                
            }
            
            additionViews?.appendContentsOf(addedAnnotationViews)
            pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
            pdfView?.addedAnnotationViews = addedAnnotationViews
            view.addSubview(pdfView!)
            
            
            pdfView?.pdfView.scrollView.contentSize = CGSizeMake(100, 900);
        }
        
        
        
        
        
        
    }
    

    
}
