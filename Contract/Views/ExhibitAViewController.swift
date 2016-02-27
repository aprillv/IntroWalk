//
//  ExhibitAViewController.swift
//  Contract
//
//  Created by April on 2/20/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

class ExhibitAViewController: PDFBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = CConstants.ActionTitleEXHIBIT_A
    }
    @IBOutlet var view2: UIView!
    private struct PDFFields{
        static let To = "1"
//        static let From = "CompanyName"
        static let Property = "PROPERTY 1"
        static let Date = "PROPERTY 2"
        static let CompanyName = "CompanyName"
    }
    
    var pdfInfo : AddendumA?{
        didSet{
            pdfInfo0 = pdfInfo;
        }
    }
    
    override func loadPDFView(){
        
        let margins = getMargins()
        let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin:0.0) as? [PDFWidgetAnnotationView]
        
        for pv : PDFWidgetAnnotationView in additionViews!{
            switch pv.xname {
            case PDFFields.To:
                pv.value = pdfInfo?.Client!
            case PDFFields.Property:
                pv.value = pdfInfo?.nproject!
            case PDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case PDFFields.Date:
                pv.value = pdfInfo?.exhibitABDate!
            default:
                break
            }
        }
        let pass = document?.documentPath ?? document?.documentData
        pdfView = PDFView(frame: view2.bounds, dataOrPath: pass, additionViews: additionViews)
        view2.addSubview(pdfView!)
        
    }
    
}
