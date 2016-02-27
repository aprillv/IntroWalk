//
//  ExhibitCGeneralViewController.swift
//  Contract
//
//  Created by April on 2/20/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

class ExhibitCGeneralViewController: PDFBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = CConstants.ActionTitleEXHIBIT_C
    }
    var pdfInfo : AddendumA?{
        didSet{
            pdfInfo0 = pdfInfo;
            //            pdfInfo?.nproject = pdfInfo?.jobaddress
        }
    }
    
    private struct PDFFields{
        static let GeneralPartner = "GeneralPartner"
        static let Date = "SignatureDate"
        static let CompanyName = "CompanyName"
    }
    @IBOutlet var view2: UIView!
    
    override func loadPDFView(){
        
        let margins = getMargins()
        let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin:0.0) as? [PDFWidgetAnnotationView]
        
        for pv : PDFWidgetAnnotationView in additionViews!{
            switch pv.xname {
            case PDFFields.GeneralPartner:
                pv.value = pdfInfo?.GeneralPartner!
            case PDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case PDFFields.Date:
                pv.value = pdfInfo?.exhibitCSignatureDate!
            default:
                break
            }
        }
        let pass = document?.documentPath ?? document?.documentData
        pdfView = PDFView(frame: view2.bounds, dataOrPath: pass, additionViews: additionViews)
        view2.addSubview(pdfView!)
        
    }
    
}
