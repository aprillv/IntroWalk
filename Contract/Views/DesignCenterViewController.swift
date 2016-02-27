//
//  DesignCenterViewController.swift
//  Contract
//
//  Created by April on 12/21/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

class DesignCenterViewController: PDFBaseViewController {

    var pdfInfo :ContractDesignCenter?{
        didSet{
            pdfInfo0 = pdfInfo;
            pdfInfo?.nproject = pdfInfo?.jobAddress
        }
    }
    
    @IBOutlet var view2: UIView!
    var sender: UIBarButtonItem?
    
    private struct PDFFields{
        static let txtCiaNm = "txtCiaNm"
        static let txtAddress = "txtAddress"
        static let txtCityStateZip = "txtCityStateZip"
        static let txtTelFax = "txtTelFax"
        static let txtDate = "txtDate"
        static let txtIdNumber = "txtIdNumber"
        static let txtContractDate = "txtContractDate"
        static let txtEstimatedCompletion = "txtEstimatedCompletion"
        static let txtEstamatedClosing = "txtEstamatedClosing"
        static let txtStageContract = "txtStageContract"
        static let txtBuilderAddress = "txtBuilderAddress"
        static let txtBuyer1 = "txtBuyer1"
        static let txtBuyer2 = "txtBuyer2"
        static let txtBuilderSubdivision = "txtBuilderSubdivision"
        static let txtConsultant = "txtConsultant"
        static let txtDesignDate = "txtDesignDate"
        static let txtBuilderAddress2 = "txtBuilderAddress2"
        static let txtNotes1 = "txtNotes1"
        static let txtNotes2 = "txtNotes2"
        static let txtNotes3 = "txtNotes3"
        static let txtNotes4 = "txtNotes4"
        static let txtMaxHourEdit = "txtMaxHourEdit"
        static let homeBuyer1Sign = "homeBuyer1Sign"
        static let homeBuyer2Sign = "homeBuyer2Sign"
        static let dcChkMaster = "dcChkMaster"
        static let dcChkMasterCountertop = "dcChkMasterCountertop"
        static let dcChkSecond = "dcChkSecond"
        static let dcChkPowder = "dcChkPowder"
        static let dcChkWood = "dcChkWood"
        static let dcChkKitchenCountertop = "dcChkKitchenCountertop"
        static let dcChkMasterBath = "dcChkMasterBath"
        static let dcChk2ndBath = "dcChk2ndBath"
        static let dcChkEntryFloor = "dcChkEntryFloor"
        static let dcChkCarpet = "dcChkCarpet"
        static let dcChkKitchenBacksplash = "dcChkKitchenBacksplash"
        static let dcChkUtility = "dcChkUtility"
        static let dcChkInterior = "dcChkInterior"
        static let dcChkPlumbing = "dcChkPlumbing"
        static let dcChkHandware = "dcChkHandware"
    }
    
    override func loadPDFView(){
        let pass = document?.documentPath ?? document?.documentData
        let margins = getMargins()
        if let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin:0.0) as? [PDFWidgetAnnotationView] {
            
            var itemList1 = [String]()
            let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
            textView.scrollEnabled = false
            textView.font = UIFont(name: "Verdana", size: 11.0)
            textView.text = pdfInfo!.notes!
            textView.sizeToFit()
            textView.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, pdfInfo!.notes!.characters.count), usingBlock: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
                if  let a : NSString = self.pdfInfo!.notes! as NSString {
                    itemList1.append(a.substringWithRange(glyphRange))
                }
            })
            
            for pv : PDFWidgetAnnotationView in additionViews{
                switch pv.xname{
                    //left top
                case PDFFields.txtCiaNm:
                    pv.value = pdfInfo?.cianame!
                case PDFFields.txtAddress:
                    pv.value = pdfInfo?.ciaaddress!
                case PDFFields.txtCityStateZip:
                    pv.value = pdfInfo?.ciacityzip!
                case PDFFields.txtTelFax:
                    pv.value = pdfInfo?.ciatelfax!
                    //right top
                case PDFFields.txtIdNumber:
                    pv.value = pdfInfo?.designNo!
                case PDFFields.txtDesignDate:
                    pv.value = pdfInfo?.designDate!
                case PDFFields.txtDate:
                    pv.value = pdfInfo?.txtDate!
                    //pending sele
                case PDFFields.txtContractDate:
                    pv.value = pdfInfo?.contractDate!
                case PDFFields.txtEstimatedCompletion:
                    pv.value = pdfInfo?.estimatedcompletion!
                case PDFFields.txtEstamatedClosing:
                    pv.value = pdfInfo?.estimatedclosing!
                case PDFFields.txtStageContract:
                    pv.value = pdfInfo?.stage!
                  
                case PDFFields.txtMaxHourEdit:
                    pv.value = ""
                    //Checkbox
                case PDFFields.txtBuyer1:
                    pv.value = pdfInfo?.buyer1!
                case PDFFields.txtBuyer2:
                    pv.value = pdfInfo?.buyer2!
                case PDFFields.txtConsultant:
                    pv.value = pdfInfo?.consultant!
                case PDFFields.txtBuilderAddress:
                    pv.value = pdfInfo?.jobAddress!
                case PDFFields.txtBuilderSubdivision:
                    pv.value = pdfInfo?.subdivision!
                case PDFFields.txtNotes1:
                    if (itemList1.count > 0){
                        pv.value = itemList1[0]
                    }
                case PDFFields.txtNotes2:
                    if (itemList1.count > 1){
                        pv.value = itemList1[1]
                    }
                case PDFFields.txtNotes3:
                    if (itemList1.count > 2){
                        pv.value = itemList1[2]
                    }
                case PDFFields.txtNotes4:
                    if (itemList1.count > 3){
                        pv.value = itemList1[3]
                    }
                case PDFFields.dcChkMaster:
                    pv.value = String(pdfInfo!.dcChkMaster!)
                case PDFFields.dcChkMasterCountertop:
                    pv.value = String(pdfInfo!.dcChkMasterCountertop!)
                case PDFFields.dcChkSecond:
                    pv.value = String(pdfInfo!.dcChkSecond!)
                case PDFFields.dcChkPowder:
                    pv.value = String(pdfInfo!.dcChkPowder!)
                case PDFFields.dcChkWood:
                    pv.value = String(pdfInfo!.dcChkWood!)
                case PDFFields.dcChkKitchenCountertop:
                    pv.value = String(pdfInfo!.dcChkKitchenCountertop!)
                case PDFFields.dcChkMasterBath:
                    pv.value = String(pdfInfo!.dcChkMasterBath!)
                case PDFFields.dcChk2ndBath:
                    pv.value = String(pdfInfo!.dcChk2ndBath!)
                case PDFFields.dcChkEntryFloor:
                    pv.value = String(pdfInfo!.dcChkEntryFloor!)
                case PDFFields.dcChkCarpet:
                    pv.value = String(pdfInfo!.dcChkCarpet!)
                case PDFFields.dcChkKitchenBacksplash:
                    pv.value = String(pdfInfo!.dcChkKitchenBacksplash!)
                case PDFFields.dcChkUtility:
                    pv.value = String(pdfInfo!.dcChkUtility!)
                case PDFFields.dcChkInterior:
                    pv.value = String(pdfInfo!.dcChkInterior!)
                case PDFFields.dcChkPlumbing:
                    pv.value = String(pdfInfo!.dcChkPlumbing!)
                case PDFFields.dcChkHandware:
                    pv.value = String(pdfInfo!.dcChkHandware!)
                default:
                    break
                }
            }
            
            
            
            
            pdfView = PDFView(frame: view2.bounds, dataOrPath: pass, additionViews: additionViews)
            view2.addSubview(pdfView!)
        }
    }
    
    @IBAction func BuyerSign(sender0: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sender = sender0;
        if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation)){
            self.pdfView!.pdfView.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.pdfView!.pdfView.scrollView.contentSize.height - self.pdfView!.pdfView.scrollView.frame.size.height, width: 100, height: self.pdfView!.pdfView.scrollView.frame.size.height), animated: true)
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "signature", userInfo: self.sender, repeats: false)
        }else{
            self.signature()
        }
        
        
        
    }
    
    func signature(){
        for sign0 in self.pdfView!.pdfWidgetAnnotationViews {
            if let sign = sign0 as? SignatureView{
                if (    sender!.tag == 1 && sign.xname.hasSuffix("1Sign"))
                    || (sender!.tag == 2 && sign.xname.hasSuffix("2Sign")) {
                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                            sign.toSignautre()
                            return
                        }
                }
                
            }
        }

        
    }
}
