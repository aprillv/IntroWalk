//
//  SetDotValue.swift
//  Contract
//
//  Created by April on 2/23/16.
//  Copyright © 2016 HapApp. All rights reserved.
//

import Foundation

class SetDotValue : NSObject {
    
    // MARK: Sign Contract
    private struct SignContractPDFFields{
        
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
        static let page7e2 = "page7e2"
        
        static let executeddd = "executeddd"
        
        static let executedmm = "executedmm"
        static let executedyy = "executedyy"
        static let buyer_2 = "buyer_2"
        static let buyer_3 = "buyer_3"
        static let seller_2 = "seller_2"
        //        static let seller_3 = "seller_3"
        static let pdf2211 = "2211"
        static let pdf2212 = "2212"
        
        static let pdf22a1 = "22a1"
        static let pdf22a15 = "22a15"
        static let pdf22a3 = "22a3"
        static let pdf22a10 = "22a10"
        
        static let buyer2Sign = "buyer2Sign"
        static let buyer3Sign = "buyer3Sign"
        static let seller2Sign = "seller2Sign"
        static let seller3Sign = "seller3Sign"
        
        static let p9Broker = "Other Broker Firm"
        static let p9represents = "Buyer only as Buyers agent"
        static let p9AssociatesName = "Associates Name"
        static let p9AssociatesEmailAddress = "Associates Email Address"
        
        // checkbox
        static let chkfinancing = "financing"
        static let chk6c = "6c"
        static let chk10a = "10a"
        static let chk7g = "7g"
        static let chk6e2 = "6e2"
        static let chk6a83 = "6a83"
        static let chk6a8 = "6a8"
        static let chk6a = "6a"
        
        
        
    }
    
    private func getFileName(pdfInfo: ContractSignature?) -> String{
        return "contract1pdf_" + pdfInfo!.idcity! + "_" + pdfInfo!.idcia!
    }
    
    func setSignContractDots(pdfInfo:ContractSignature?, additionViews: [PDFWidgetAnnotationView], pdfview: PDFView){
        if let filedsFromTxt = readContractFieldsFromTxt(getFileName(pdfInfo)) {
            
            
            let na = filedsFromTxt.keys
            for pv : PDFWidgetAnnotationView in additionViews{
                if na.contains(pv.xname){
                    pv.value = filedsFromTxt[pv.xname]
                }
            }
            
        }
        
        var tobuyer3 : String
        var tobuyer4 : String
        if let b = pdfInfo!.bmobile1 == "" ? pdfInfo?.boffice1! : pdfInfo?.bmobile1! {
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
        if let b = pdfInfo!.bfax1 {
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
        overrideFields = [SignContractPDFFields.CompanyName : SignContractPDFFields.CompanyName1
            , SignContractPDFFields.Buyer : SignContractPDFFields.Buyer1
            , SignContractPDFFields.Lot: SignContractPDFFields.Lot1
            , SignContractPDFFields.Block : SignContractPDFFields.Block1
            , SignContractPDFFields.Section : SignContractPDFFields.Section1
            , SignContractPDFFields.City : SignContractPDFFields.City1
            , SignContractPDFFields.County : SignContractPDFFields.County1
            , SignContractPDFFields.Address : SignContractPDFFields.Address1
            , SignContractPDFFields.Address_zip : SignContractPDFFields.Address1
            , SignContractPDFFields.SalePrice : SignContractPDFFields.SalePrice1]
        
        //        pdfInfo?.section = "MEADOWS AT TRINITY CROSSING PHASE 2-B-1 AMENDED PL"
        
        let na = overrideFields.keys
        for pv : PDFWidgetAnnotationView in additionViews{
            if na.contains(pv.xname){
                if SignContractPDFFields.Address_zip == pv.xname{
                    
                    if pdfInfo!.zipcode! != "" {
                        pv.value = "\(pdfInfo!.nproject!)/\(pdfInfo!.zipcode!)"
                    }else{
                        pv.value = pdfInfo!.nproject!
                    }
                }else if SignContractPDFFields.Address == pv.xname{
                    pv.value = pdfInfo!.nproject
                }else if(SignContractPDFFields.Buyer == pv.xname){
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
                case SignContractPDFFields.cashportion:
                    //                    pv.value = pdfInfo!.cashportion! == "" ? "0.00" : pdfInfo!.cashportion!
                    pv.value = pdfInfo!.cashportion!
                case SignContractPDFFields.financing:
                    pv.value = pdfInfo!.financing!
                case SignContractPDFFields.estimatedclosing_MMdd:
                    pv.value = pdfInfo!.estimatedclosing_MMdd!
                case SignContractPDFFields.estimatedclosing_yy:
                    pv.value = pdfInfo!.estimatedclosing_yy!
                case SignContractPDFFields.tobuyer1:
                    pv.value = pdfInfo!.client!
                case SignContractPDFFields.tobuyer2:
                    pv.value = pdfInfo!.tobuyer2!
                case SignContractPDFFields.tobuyer3:
                    pv.value = tobuyer3
                case SignContractPDFFields.tobuyer4:
                    pv.value = tobuyer4
                case SignContractPDFFields.tobuyer5:
                    pv.value = tobuyer5
                case SignContractPDFFields.tobuyer6:
                    pv.value = tobuyer6
                case SignContractPDFFields.tobuyer7:
                    pv.value = pdfInfo!.bemail1!
                case SignContractPDFFields.executeddd:
                    pv.value = pdfInfo!.executeddd!
                case SignContractPDFFields.executedmm:
                    pv.value = pdfInfo!.executedmm!
                case SignContractPDFFields.executedyy:
                    pv.value = pdfInfo!.executedyy!
                case SignContractPDFFields.buyer_2:
                    pv.value = pdfInfo!.client!
                case SignContractPDFFields.buyer_3:
                    pv.value = pdfInfo!.client2!
                case SignContractPDFFields.seller_2:
                    pv.value = pdfInfo!.cianame!
                case SignContractPDFFields.pdf2211:
                    pv.value = pdfInfo!.trec1!
                case SignContractPDFFields.pdf2212:
                    pv.value = pdfInfo!.trec2!
                case SignContractPDFFields.pdf22a1:
                    if let radio = pv as? PDFFormButtonField {
                        radio .setValue2(pdfInfo!.page7ThirdPartyFinacingAddendum!)
                    }
                case SignContractPDFFields.pdf22a15:
                    if let radio = pv as? PDFFormButtonField {
                        radio .setValue2(pdfInfo!.other!)
                    }
                case SignContractPDFFields.pdf22a3:
                    if let radio = pv as? PDFFormButtonField {
                        radio .setValue2(pdfInfo!.hoa!)
                    }
                case SignContractPDFFields.pdf22a10:
                    if let radio = pv as? PDFFormButtonField {
                        radio.setValue2(pdfInfo!.environment!)
                    }
                case SignContractPDFFields.page7e2:
                    pv.value = pdfInfo!.page7e2!
                    //                case "buyer_2", "buyer_3", "seller_2", "seller_3":
                    //                case "buyer_2":
                    
                case SignContractPDFFields.p9Broker:
                    pv.value = pdfInfo!.page9OtherBrokerFirm
                case SignContractPDFFields.p9represents:
                    if let radio = pv as? PDFFormButtonField {
                        radio .setValue2(pdfInfo!.page9BuyeronlyasBuyersagent!)
                    }
                case SignContractPDFFields.p9AssociatesName:
                    pv.value = pdfInfo!.page9AssociatesName
                case SignContractPDFFields.p9AssociatesEmailAddress:
                    pv.value = pdfInfo!.page9AssociatesEmailAddress
                    //                    static let chkfinancing = "financing"
                    //                    static let chk6c = "6c"
                    //                    static let chkcer2 = "cer2"
                    //                    static let chkcer1 = "cer1"
                    //                    static let chk23a = "23a"
                    //                    static let chk10a = "10a"
                    //                    static let chk7g = "7g"
                    //                    static let chk6e2 = "6e2"
                    //                    static let chk6a83 = "6a83"
                    //                    static let chk6a8 = "6a8"
                    //                    static let chk6a = "6a"
                case SignContractPDFFields.chkfinancing:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "4a" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk6c:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6c2" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk10a:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "10a1" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk7g:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "7g2" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk6e2:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6e2" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk6a83:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6a831" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk6a8:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6a82" {
                            radio.setValue2("1")
                        }
                    }
                case SignContractPDFFields.chk6a:
                    if let radio = pv as? PDFFormButtonField {
                        if radio.exportValue == "6a2" {
                            radio.setValue2("1")
                        }
                    }
                default:
                    break
                }
            }
            if let sign = pv as? SignatureView{
                sign.pdfViewsssss = pdfview
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
    // MARK: Closing Memo
    private struct ClosingMemoPDFFields{
        static let CiaNm = "txtCiaNm"
        static let Address = "txtAddress"
        static let CityStateZip = "txtCityStateZip"
        static let TelFax = "txtTelFax"
        static let IdNumber = "txtIdNumber"
        static let Date = "txtDate"
        static let ContractDate = "txtContractDate"
        static let EstimatedCompletion = "txtEstimatedCompletion"
        static let EstamatedClosing = "txtEstamatedClosing"
        static let StageContract = "txtStageContract"
        static let Buyer2 = "txtBuyer2"
        static let Address1 = "txtAddress1"
        static let Address2 = "txtAddress2"
        static let Buyer1 = "txtBuyer1"
        static let Email = "txtEmail"
        static let Office = "txtOffice"
        static let Fax = "txtFax"
        static let Mobile = "txtMobile"
        static let Email2 = "txtEmail2"
        static let Office2 = "txtOffice2"
        static let Fax2 = "txtFax2"
        static let Mobile2 = "txtMobile2"
        static let Broker = "txtBroker"
        static let Per = "txtPer"
        static let Agent = "txtAgent"
        static let BrokerOffice = "txtBrokerOffice"
        static let BrokerFax = "txtBrokerFax"
        static let BrokerMobile = "txtBrokerMobile"
        static let BrokerEmail = "txtBrokerEmail"
        static let ProjectManager = "txtProjectManager"
        static let Consultant = "txtConsultant"
        static let BuilderAddress = "txtBuilderAddress"
        static let BuilderAddress2 = "txtBuilderAddress2"
        static let BuilderSubdivision2 = "txtBuilderSubdivision2"
        static let LegalDescription = "txtLegalDescription"
        static let Floorplan = "txtFloorplan"
        static let BuilderSubdivision = "txtBuilderSubdivision"
        static let ListPrice = "txtListPrice"
        static let Incl = "txtIncl"
        static let Allowance = "txtAllowance"
        static let Title = "txtTitle"
        static let Mortgage = "txtMortgage"
        static let Bank = "txtBank"
        static let SalesPrice = "txtSalesPrice"
        static let Check = "txtCheck"
        static let XType = "txtType"
        static let Amount = "txtAmount"
    }
    
    func setCloingMemoDots(pdfInfo: ContractClosingMemo?, additionViews: [PDFWidgetAnnotationView], pdfview: PDFView){
        var bankField : PDFFormTextField?
        var checkField : PDFFormTextField?
        var typeField : PDFFormTextField?
        var amountField : PDFFormTextField?
        
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname{
                //left top
            case ClosingMemoPDFFields.CiaNm:
                pv.value = pdfInfo?.cianame!
            case ClosingMemoPDFFields.Address:
                pv.value = pdfInfo?.ciaaddress!
            case ClosingMemoPDFFields.CityStateZip:
                pv.value = pdfInfo?.ciacityzip!
            case ClosingMemoPDFFields.TelFax:
                pv.value = pdfInfo?.ciatelfax!
                //right top
            case ClosingMemoPDFFields.IdNumber:
                pv.value = pdfInfo?.closingNo!
            case ClosingMemoPDFFields.Date:
                pv.value = pdfInfo?.closingDate!
                //pending sele
            case ClosingMemoPDFFields.ContractDate:
                pv.value = pdfInfo?.contractdate!
            case ClosingMemoPDFFields.EstimatedCompletion:
                pv.value = pdfInfo?.estimatedcompletion!
            case ClosingMemoPDFFields.EstamatedClosing:
                pv.value = pdfInfo?.estimatedclosing!
            case ClosingMemoPDFFields.StageContract:
                pv.value = pdfInfo?.stage!
                
                //buyer info
            case ClosingMemoPDFFields.Buyer1:
                pv.value = pdfInfo?.buyer1!
            case ClosingMemoPDFFields.Buyer2:
                pv.value = pdfInfo?.buyer2!
            case ClosingMemoPDFFields.Address1:
                pv.value = pdfInfo?.currentAddress1!
            case ClosingMemoPDFFields.Address2:
                pv.value = pdfInfo?.currentAddress2!
            case ClosingMemoPDFFields.Email:
                pv.value = pdfInfo?.email1!
            case ClosingMemoPDFFields.Email2:
                pv.value = pdfInfo?.email2!
            case ClosingMemoPDFFields.Office:
                pv.value = pdfInfo?.office1!
            case ClosingMemoPDFFields.Office2:
                pv.value = pdfInfo?.office2!
            case ClosingMemoPDFFields.Fax:
                pv.value = pdfInfo?.fax1!
            case ClosingMemoPDFFields.Fax2:
                pv.value = pdfInfo?.fax2!
            case ClosingMemoPDFFields.Mobile:
                pv.value = pdfInfo?.mobile1!
            case ClosingMemoPDFFields.Mobile2:
                pv.value = pdfInfo?.mobile2!
                
                //broker info
            case ClosingMemoPDFFields.Broker:
                pv.value = pdfInfo?.broker!
            case ClosingMemoPDFFields.Per:
                pv.value = pdfInfo?.brokerPercent!
            case ClosingMemoPDFFields.Agent:
                pv.value = pdfInfo?.brokerAgent!
            case ClosingMemoPDFFields.BrokerEmail:
                pv.value = pdfInfo?.brokerEmail!
            case ClosingMemoPDFFields.BrokerOffice:
                pv.value = pdfInfo?.brokerOffice!
            case ClosingMemoPDFFields.BrokerFax:
                pv.value = pdfInfo?.brokerFax!
            case ClosingMemoPDFFields.BrokerMobile:
                pv.value = pdfInfo?.brokerMobile!
                
                //builder info
            case ClosingMemoPDFFields.ProjectManager:
                pv.value = pdfInfo?.projectManager!
            case ClosingMemoPDFFields.Consultant:
                pv.value = pdfInfo?.salesConsultant!
            case ClosingMemoPDFFields.BuilderAddress:
                pv.value = pdfInfo?.jobAddress!
            case ClosingMemoPDFFields.BuilderSubdivision:
                pv.value = pdfInfo?.subdivision!
            case ClosingMemoPDFFields.LegalDescription:
                pv.value = pdfInfo?.cdescription!
            case ClosingMemoPDFFields.Floorplan:
                pv.value = pdfInfo?.floorplan!
                
                //financial information
            case ClosingMemoPDFFields.ListPrice:
                pv.value = pdfInfo?.listPrice!
            case ClosingMemoPDFFields.Incl:
                pv.value = pdfInfo?.UPG!
            case ClosingMemoPDFFields.SalesPrice:
                pv.value = pdfInfo?.salesPrice!
            case ClosingMemoPDFFields.Allowance:
                pv.value = pdfInfo?.allowance!
            case ClosingMemoPDFFields.Mortgage:
                pv.value = pdfInfo?.company!
            case ClosingMemoPDFFields.Title:
                pv.value = pdfInfo?.titleInsurance!
                
                // non - refundable
            case ClosingMemoPDFFields.Bank:
                bankField = pv as? PDFFormTextField
                if let item = pdfInfo?.memoItemlist?.first{
                    pv.value = item.bankName!
                }
            case ClosingMemoPDFFields.Check:
                checkField = pv as? PDFFormTextField
                if let item = pdfInfo?.memoItemlist?.first{
                    pv.value = item.check!
                }
            case ClosingMemoPDFFields.XType:
                typeField = pv as? PDFFormTextField
                if let item = pdfInfo?.memoItemlist?.first{
                    pv.value = item.type!
                }
            case ClosingMemoPDFFields.Amount:
                amountField = pv as? PDFFormTextField
                if let item = pdfInfo?.memoItemlist?.first{
                    pv.value = item.amount!
                }
            default:
                break
            }
        }
        var addedAnnotationViews : [PDFWidgetAnnotationView] = [PDFWidgetAnnotationView]()
        var originy = bankField!.frame.origin.y
        originy += bankField!.frame.size.height * 1.2
        let line = PDFWidgetAnnotationView(frame: CGRect(x: bankField!.frame.origin.x - 3, y: originy, width: amountField!.frame.size.width + amountField!.frame.origin.x + 6 - bankField!.frame.origin.x, height: 1))
        line.backgroundColor = UIColor.lightGrayColor()
        addedAnnotationViews.append(line)
        
        if pdfInfo?.memoItemlist!.count > 1 {
            var i = true
            let lastLineInfo : [PDFFormTextField] = [bankField!, checkField!, typeField!, amountField!]
            let font = floor(bankField!.currentFontSize())
            
            for item in pdfInfo!.memoItemlist!{
                
                if i {
                    i = false
                    continue
                }else{
                    originy += bankField!.frame.size.height * 0.8
                    var y = 0
                    for itemField in lastLineInfo {
                        var bankFrame = itemField.frame
                        bankFrame.origin.y = originy
                        let xvalue : String
                        var alignment : NSTextAlignment = .Left
                        switch y {
                        case 0:
                            xvalue = item.bankName!
                        case 1:
                            xvalue = item.check!
                        case 2:
                            xvalue = item.type!
                        case 3:
                            xvalue = item.amount!
                            alignment = .Right
                        default:
                            xvalue = ""
                            break
                        }
                        let bank1 = PDFFormTextField(frame: bankFrame, multiline: false, alignment: alignment, secureEntry: false, readOnly: true, withFont: font)
                        bank1.xname = "april"
                        bank1.value = xvalue
                        addedAnnotationViews.append(bank1)
                        y++
                    }
                    originy += bankField!.frame.size.height * 1.2
                    let line = PDFWidgetAnnotationView(frame: CGRect(x: bankField!.frame.origin.x - 3, y: originy, width: amountField!.frame.size.width + amountField!.frame.origin.x + 6 - bankField!.frame.origin.x, height: 1))
                    line.backgroundColor = UIColor.lightGrayColor()
                    addedAnnotationViews.append(line)
                }
            }
         
        }
        pdfview.addMoreDots(addedAnnotationViews)
    }
    // MARK: Addendum A
    private struct AddendumAPDFFields{
        static let Nonrefundable = "Nonrefundable"
        static let CompanyName = "CompanyName"
        static let delayfees_word = "delayfees_word"
        static let delayfees_amount = "delayfees_amount"
        static let ExcutedDay = "ExcutedDay"
        static let GeneralPartner = "GeneralPartner"
        static let Signature = "SignatureSign"
    }
    
    func setAddendumADots(pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case AddendumAPDFFields.Nonrefundable:
                pv.value = pdfInfo?.Nonrefundable!
            case AddendumAPDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case AddendumAPDFFields.delayfees_word:
                pv.value = pdfInfo?.delayfees_word!
            case AddendumAPDFFields.delayfees_amount:
                pv.value = pdfInfo?.delayfees_amount!
            case AddendumAPDFFields.GeneralPartner:
                pv.value = pdfInfo?.GeneralPartner!
            case AddendumAPDFFields.ExcutedDay:
                pv.value = pdfInfo?.ExcutedDay!
            default:
                break
            }
        }
    }
    
    // MARK: ADDENDUM C
    private struct AddendumCPDFFields{
        
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
    
    func setAddendumCDots(pdfInfo: ContractAddendumC?, additionViews: [PDFWidgetAnnotationView], pdfview: PDFView, has2Pages0: Bool){
        var aPrice : PDFFormTextField?
        var aPrice2 : PDFFormTextField?
        var aPrice3 : PDFFormTextField?
        var aCiaName : PDFWidgetAnnotationView?
        var aStage : PDFWidgetAnnotationView?
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case AddendumCPDFFields.CompanyName:
                aCiaName = pv
                pv.value = pdfInfo?.cianame!
            case AddendumCPDFFields.Address:
                pv.value = pdfInfo?.ciaaddress!
            case AddendumCPDFFields.CityStateZip:
                pv.value = pdfInfo?.ciacityzip!
            case AddendumCPDFFields.TelFax:
                pv.value = pdfInfo?.ciatelfax!
            case AddendumCPDFFields.IdNo:
                pv.value = pdfInfo?.addendumNo!
            case AddendumCPDFFields.DateL:
                pv.value = pdfInfo?.addendumDate!
            case AddendumCPDFFields.ContractDate:
                pv.value = pdfInfo?.contractdate!
            case AddendumCPDFFields.EstimatedCompletion:
                pv.value = pdfInfo?.estimatedcompletion!
            case AddendumCPDFFields.EstamatedClosing:
                pv.value = pdfInfo?.estimatedclosing!
            case AddendumCPDFFields.StageContract:
                pv.value = pdfInfo?.stage!
                aStage = pv
            case AddendumCPDFFields.JobAddress:
                pv.value = pdfInfo?.jobaddress!
            case AddendumCPDFFields.Buyer:
                pv.value = pdfInfo?.buyer!
            case AddendumCPDFFields.Consultant:
                pv.value = pdfInfo?.consultant!
            case AddendumCPDFFields.SubDivision:
                pv.value = pdfInfo?.subdivision!
            case AddendumCPDFFields.Price:
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
        
        var has2Pages = has2Pages0
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
            var yo = y
            var j : CGFloat = 1
            if has2Pages0 {
                while yo > aPrice2!.frame.origin.y - aPrice!.frame.origin.y {
                    yo -= aPrice2!.frame.origin.y - aPrice!.frame.origin.y
                    j++
                }
            }
            
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
                    
                    if has2Pages && y+50  > (aPrice2!.frame.origin.y - aPrice!.frame.origin.y) * j {
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
            pf = PDFFormTextField(frame: CGRect(x: x, y: y, width: w, height: h), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true, withName: nil)
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
                if i < 3 {
                    sign?.xname = "april" + "\(i)" + "Sign"
                }else{
                    sign?.xname = "april" + "\(i)" + "DateSign"
                }
                
                
                addedAnnotationViews.append(sign!)
                
                
                line = PDFWidgetAnnotationView(frame: CGRect(x: x, y: y + 2+h, width: w * 0.28, height: 1))
                line?.backgroundColor = UIColor.lightGrayColor()
                addedAnnotationViews.append(line!)
                
                pf = PDFFormTextField(frame: CGRect(x: x, y: y + h + 3 , width: w * 0.28, height: price.frame.height), multiline: false, alignment: NSTextAlignment.Left, secureEntry: false, readOnly: true, withName: nil)
                pf?.xname = "april"
                pf?.value = AddendumCPDFFields.SignArray[i]
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
        }
        pdfview.addMoreDots(addedAnnotationViews)
    }
    
    // MARK: DesignCenter
    private struct DesignCenterPDFFields{
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
    
    func setDesignCenterDots(pdfInfo: ContractDesignCenter?, additionViews: [PDFWidgetAnnotationView]){
        var itemList1 = [String]()
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 657.941, height: 13.2353))
        textView.scrollEnabled = false
        textView.font = UIFont(name: "Verdana", size: 11.0)
        textView.text = pdfInfo!.notes!
        textView.sizeToFit()
        textView.layoutManager.enumerateLineFragmentsForGlyphRange(NSMakeRange(0, pdfInfo!.notes!.characters.count), usingBlock: { (rect, usedRect, textContainer, glyphRange, _) -> Void in
            if  let a : NSString = pdfInfo!.notes! as NSString {
                itemList1.append(a.substringWithRange(glyphRange))
            }
        })
        
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname{
                //left top
            case DesignCenterPDFFields.txtCiaNm:
                pv.value = pdfInfo?.cianame!
            case DesignCenterPDFFields.txtAddress:
                pv.value = pdfInfo?.ciaaddress!
            case DesignCenterPDFFields.txtCityStateZip:
                pv.value = pdfInfo?.ciacityzip!
            case DesignCenterPDFFields.txtTelFax:
                pv.value = pdfInfo?.ciatelfax!
                //right top
            case DesignCenterPDFFields.txtIdNumber:
                pv.value = pdfInfo?.designNo!
            case DesignCenterPDFFields.txtDesignDate:
                pv.value = pdfInfo?.designDate!
            case DesignCenterPDFFields.txtDate:
                pv.value = pdfInfo?.txtDate!
                //pending sele
            case DesignCenterPDFFields.txtContractDate:
                pv.value = pdfInfo?.contractDate!
            case DesignCenterPDFFields.txtEstimatedCompletion:
                pv.value = pdfInfo?.estimatedcompletion!
            case DesignCenterPDFFields.txtEstamatedClosing:
                pv.value = pdfInfo?.estimatedclosing!
            case DesignCenterPDFFields.txtStageContract:
                pv.value = pdfInfo?.stage!
                
            case DesignCenterPDFFields.txtMaxHourEdit:
                pv.value = ""
                //Checkbox
            case DesignCenterPDFFields.txtBuyer1:
                pv.value = pdfInfo?.buyer1!
            case DesignCenterPDFFields.txtBuyer2:
                pv.value = pdfInfo?.buyer2!
            case DesignCenterPDFFields.txtConsultant:
                pv.value = pdfInfo?.consultant!
            case DesignCenterPDFFields.txtBuilderAddress:
                pv.value = pdfInfo?.jobAddress!
            case DesignCenterPDFFields.txtBuilderSubdivision:
                pv.value = pdfInfo?.subdivision!
            case DesignCenterPDFFields.txtNotes1:
                if (itemList1.count > 0){
                    pv.value = itemList1[0]
                }
            case DesignCenterPDFFields.txtNotes2:
                if (itemList1.count > 1){
                    pv.value = itemList1[1]
                }
            case DesignCenterPDFFields.txtNotes3:
                if (itemList1.count > 2){
                    pv.value = itemList1[2]
                }
            case DesignCenterPDFFields.txtNotes4:
                if (itemList1.count > 3){
                    pv.value = itemList1[3]
                }
            case DesignCenterPDFFields.dcChkMaster:
                pv.value = String(pdfInfo!.dcChkMaster!)
            case DesignCenterPDFFields.dcChkMasterCountertop:
                pv.value = String(pdfInfo!.dcChkMasterCountertop!)
            case DesignCenterPDFFields.dcChkSecond:
                pv.value = String(pdfInfo!.dcChkSecond!)
            case DesignCenterPDFFields.dcChkPowder:
                pv.value = String(pdfInfo!.dcChkPowder!)
            case DesignCenterPDFFields.dcChkWood:
                pv.value = String(pdfInfo!.dcChkWood!)
            case DesignCenterPDFFields.dcChkKitchenCountertop:
                pv.value = String(pdfInfo!.dcChkKitchenCountertop!)
            case DesignCenterPDFFields.dcChkMasterBath:
                pv.value = String(pdfInfo!.dcChkMasterBath!)
            case DesignCenterPDFFields.dcChk2ndBath:
                pv.value = String(pdfInfo!.dcChk2ndBath!)
            case DesignCenterPDFFields.dcChkEntryFloor:
                pv.value = String(pdfInfo!.dcChkEntryFloor!)
            case DesignCenterPDFFields.dcChkCarpet:
                pv.value = String(pdfInfo!.dcChkCarpet!)
            case DesignCenterPDFFields.dcChkKitchenBacksplash:
                pv.value = String(pdfInfo!.dcChkKitchenBacksplash!)
            case DesignCenterPDFFields.dcChkUtility:
                pv.value = String(pdfInfo!.dcChkUtility!)
            case DesignCenterPDFFields.dcChkInterior:
                pv.value = String(pdfInfo!.dcChkInterior!)
            case DesignCenterPDFFields.dcChkPlumbing:
                pv.value = String(pdfInfo!.dcChkPlumbing!)
            case DesignCenterPDFFields.dcChkHandware:
                pv.value = String(pdfInfo!.dcChkHandware!)
            default:
                break
            }
        }
    }
    
    
    // MARK: Third Party Finacing Addendum
    private struct ThirdPartyFinacingAddendumPDFFields{
        static let AddressCity = "Street Address and City"
        static let PropertyAddress = "Address of Property"
        
        static let checkedField = "This contract is not subject to Buyer obtaining Buyer Approval"
        
        static let buyer2Sign = "buyer2Sign"
        static let buyer1Sign = "buyer1Sign"
        static let seller2Sign = "seller2Sign"
        static let seller1Sign = "seller1Sign"
    }
    
    func setThirdPartyFinacingAddendumDots(pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case ThirdPartyFinacingAddendumPDFFields.AddressCity,  ThirdPartyFinacingAddendumPDFFields.PropertyAddress:
                pv.value = pdfInfo!.nproject! + " / " + pdfInfo!.city!
            case ThirdPartyFinacingAddendumPDFFields.checkedField:
                if let radio = pv as? PDFFormButtonField {
                    radio .setValue2("1")
                }
            default:
                break
            }
        }
    }
    
    
    // MARK: Exhibit A
    private struct ExhibitAPDFFields{
        static let To = "1"
        static let Property = "PROPERTY 1"
        static let Date = "PROPERTY 2"
        static let CompanyName = "CompanyName"
    }
    
    func setExhibitADots(pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
//        print(additionViews)
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
//            print(pv.value)
        }
    }
    
    // MARK: Exhibit B
    private struct ExhibitBPDFFields{
        static let To = "1"
        //        static let From = "CompanyName"
        static let Property = "PROPERTY 1"
        static let Date = "PROPERTY 2"
        static let CompanyName = "CompanyName"
    }
    
    func setExhibitBDots(pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case ExhibitBPDFFields.To:
                pv.value = pdfInfo?.Client!
            case ExhibitBPDFFields.Property:
                pv.value = pdfInfo?.nproject!
            case ExhibitBPDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case ExhibitBPDFFields.Date:
                pv.value = pdfInfo?.exhibitABDate!
            default:
                break
            }
        }
    }
    
    // MARK: Exhibit C
    private struct ExhibitCPDFFields{
        static let GeneralPartner = "GeneralPartner"
        static let Date = "SignatureDate"
        static let CompanyName = "CompanyName"
    }
    
    func setExhibitCDots(pdfInfo: AddendumA?, additionViews: [PDFWidgetAnnotationView]){
        for pv : PDFWidgetAnnotationView in additionViews{
            switch pv.xname {
            case ExhibitCPDFFields.GeneralPartner:
                pv.value = pdfInfo?.GeneralPartner!
            case ExhibitCPDFFields.CompanyName:
                pv.value = pdfInfo?.CompanyName!
            case ExhibitCPDFFields.Date:
                pv.value = pdfInfo?.exhibitCSignatureDate!
            default:
                break
            }
        }
    }
}
