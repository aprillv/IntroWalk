//
//  AddendumAViewController.swift
//  Contract
//
//  Created by April on 2/19/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

class AddendumAViewController: PDFBaseViewController {
    
    @IBOutlet var view2: UIView!
    var pdfInfo : AddendumA?{
        didSet{
            pdfInfo0 = pdfInfo;
//            pdfInfo?.nproject = pdfInfo?.jobaddress
        }
    }
    var sender: UIBarButtonItem?
    
    private struct PDFFields{
        static let Nonrefundable = "Nonrefundable"
        static let CompanyName = "CompanyName"
        static let delayfees_word = "delayfees_word"
        static let delayfees_amount = "delayfees_amount"
        static let ExcutedDay = "ExcutedDay"
        static let GeneralPartner = "GeneralPartner"
        static let Signature = "SignatureSign"
    }
    
    override func loadPDFView(){
        
        let margins = getMargins()
        let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin:0.0) as? [PDFWidgetAnnotationView]
        
        for pv : PDFWidgetAnnotationView in additionViews!{
            switch pv.xname {
            case PDFFields.Nonrefundable:
                pv.value = pdfInfo?.Nonrefundable!
            case PDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case PDFFields.delayfees_word:
                pv.value = pdfInfo?.delayfees_word!
            case PDFFields.delayfees_amount:
                pv.value = pdfInfo?.delayfees_amount!
            case PDFFields.GeneralPartner:
                pv.value = pdfInfo?.GeneralPartner!
            case PDFFields.ExcutedDay:
                pv.value = pdfInfo?.ExcutedDay!
            default:
                break
            }
        }
        let pass = document?.documentPath ?? document?.documentData
        pdfView = PDFView(frame: view2.bounds, dataOrPath: pass, additionViews: additionViews)
        view2.addSubview(pdfView!)
        
    }
    
//    func signature(){
//        for sign0 in pdfView!.pdfWidgetAnnotationViews {
//            if let sign = sign0 as? SignatureView{
//                if (    sender!.tag == 1 && sign.sname.hasSuffix(PDFFields.buyer1Sign))
//                    || (sender!.tag == 2 && sign.sname.hasSuffix(PDFFields.buyer2Sign))
//                    || (sender!.tag == 3 && sign.sname.hasSuffix(PDFFields.seller1Sign))
//                    || (sender!.tag == 4 && sign.sname.hasSuffix(PDFFields.seller2Sign)){
//                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
//                            sign.toSignautre()
//                            return
//                        }
//                }
//                
//            }
//        }
//    }
//    @IBAction func BuyerSign(sender0: UIBarButtonItem) {
//        
//        sender = sender0
//        
//        self.pdfView!.pdfView.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.pdfView!.pdfView.scrollView.contentSize.height - self.pdfView!.pdfView.scrollView.frame.size.height, width: 100, height: self.pdfView!.pdfView.scrollView.frame.size.height), animated: true)
//        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "signature", userInfo: sender, repeats: false)
//        
//    }
    
}
