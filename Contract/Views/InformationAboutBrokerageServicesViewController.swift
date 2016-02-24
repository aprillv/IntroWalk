//
//  AddendumBViewController.swift
//  Contract
//
//  Created by April on 2/19/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import UIKit

class InformationAboutBrokerageServicesViewController: PDFBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = CConstants.ActionTitleINFORMATION_ABOUT_BROKERAGE_SERVICES
    }
    override func loadPDFView(){
        let margins = getMargins()
        let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin:0.0) as? [PDFWidgetAnnotationView]
        let pass = document?.documentPath ?? document?.documentData
        pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
        view.addSubview(pdfView!)
        
    }
}
