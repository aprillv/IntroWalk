//
//  SetDotValue.swift
//  Contract
//
//  Created by April on 2/23/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import Foundation

class SetDotValue : NSObject {
    private struct ExhibitAPDFFields{
        static let To = "1"
        static let Property = "PROPERTY 1"
        static let Date = "PROPERTY 2"
        static let CompanyName = "CompanyName"
    }
    
    func setExhibitADots(pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case ExhibitAPDFFields.To:
                pv.value = pdfInfo?.Client!
            case ExhibitAPDFFields.Property:
                pv.value = pdfInfo?.nproject!
            case ExhibitAPDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case ExhibitAPDFFields.Date:
                pv.value = pdfInfo?.exhibitABDate!
            default:
                break
            }
        }
    }
}
