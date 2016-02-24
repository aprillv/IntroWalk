//
//  ThirdPartyFinacingAddendum.swift
//  Contract
//
//  Created by April on 2/17/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

class ThirdPartyFinacingAddendumViewController: PDFBaseViewController {
    var pdfInfo : AddendumA?{
        didSet{
            pdfInfo0 = pdfInfo;
            pdfInfo?.nproject = pdfInfo?.nproject
        }
    }
    var sender: UIBarButtonItem?
    
    private struct PDFFields{
        static let AddressCity = "Street Address and City"
        static let PropertyAddress = "Address of Property"
        
        static let checkedField = "This contract is not subject to Buyer obtaining Buyer Approval"
        
        static let buyer2Sign = "buyer2Sign"
        static let buyer1Sign = "buyer1Sign"
        static let seller2Sign = "seller2Sign"
        static let seller1Sign = "seller1Sign"
        
    }
    
    override func loadPDFView(){
        let margins = getMargins()
        let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin:0.0) as? [PDFWidgetAnnotationView]
         for pv : PDFWidgetAnnotationView in additionViews!{
            switch pv.xname {
            case PDFFields.AddressCity,  PDFFields.PropertyAddress:
                pv.value = pdfInfo!.nproject! + " / " + pdfInfo!.city!
            case PDFFields.checkedField:
                if let radio = pv as? PDFFormButtonField {
                    radio .setValue2("1")
                }
            default:
                break
            }
        }
        let pass = document?.documentPath ?? document?.documentData
        pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
        view.addSubview(pdfView!)

    }
    
    func signature(){
        for sign0 in pdfView!.pdfWidgetAnnotationViews {
            if let sign = sign0 as? SignatureView{
                if (    sender!.tag == 1 && sign.sname.hasSuffix(PDFFields.buyer1Sign))
                    || (sender!.tag == 2 && sign.sname.hasSuffix(PDFFields.buyer2Sign))
                    || (sender!.tag == 3 && sign.sname.hasSuffix(PDFFields.seller1Sign))
                    || (sender!.tag == 4 && sign.sname.hasSuffix(PDFFields.seller2Sign)){
                        if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                            sign.toSignautre()
                            return
                        }
                }
                
            }
        }
    }
    @IBAction func BuyerSign(sender0: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sender = sender0
        
        self.pdfView!.pdfView.scrollView.scrollRectToVisible(CGRect(x: 0, y: self.pdfView!.pdfView.scrollView.contentSize.height - self.pdfView!.pdfView.scrollView.frame.size.height, width: 100, height: self.pdfView!.pdfView.scrollView.frame.size.height), animated: true)
        NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "signature", userInfo: self.sender, repeats: false)
    
        
        
    }

}
