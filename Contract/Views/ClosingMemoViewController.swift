//
//  ClosingMemoViewController.swift
//  Contract
//
//  Created by April on 12/21/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

class ClosingMemoViewController: PDFBaseViewController {
    
    var pdfInfo :ContractClosingMemo?{
        didSet{
            pdfInfo0 = pdfInfo;
            pdfInfo?.nproject = pdfInfo?.jobAddress
        }
    }
    
    private struct PDFFields{
        
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
    
    
    override func loadPDFView(){
        
        let pass = document?.documentPath ?? document?.documentData
        let margins = getMargins()
        if var additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y, pageMargin:0.0) as? [PDFWidgetAnnotationView] {
            
            var bankField : PDFFormTextField?
            var checkField : PDFFormTextField?
            var typeField : PDFFormTextField?
            var amountField : PDFFormTextField?
            
            for pv : PDFWidgetAnnotationView in additionViews{
                switch pv.xname{
                    //left top
                case PDFFields.CiaNm:
                    pv.value = pdfInfo?.cianame!
                case PDFFields.Address:
                    pv.value = pdfInfo?.ciaaddress!
                case PDFFields.CityStateZip:
                    pv.value = pdfInfo?.ciacityzip!
                case PDFFields.TelFax:
                    pv.value = pdfInfo?.ciatelfax!
                    //right top
                case PDFFields.IdNumber:
                    pv.value = pdfInfo?.closingNo!
                case PDFFields.Date:
                    pv.value = pdfInfo?.closingDate!
                //pending sele
                case PDFFields.ContractDate:
                    pv.value = pdfInfo?.contractdate!
                case PDFFields.EstimatedCompletion:
                    pv.value = pdfInfo?.estimatedcompletion!
                case PDFFields.EstamatedClosing:
                    pv.value = pdfInfo?.estimatedclosing!
                case PDFFields.StageContract:
                    pv.value = pdfInfo?.stage!
                 
                    //buyer info
                case PDFFields.Buyer1:
                    pv.value = pdfInfo?.buyer1!
                case PDFFields.Buyer2:
                    pv.value = pdfInfo?.buyer2!
                case PDFFields.Address1:
                    pv.value = pdfInfo?.currentAddress1!
                case PDFFields.Address2:
                    pv.value = pdfInfo?.currentAddress2!
                case PDFFields.Email:
                    pv.value = pdfInfo?.email1!
                case PDFFields.Email2:
                    pv.value = pdfInfo?.email2!
                case PDFFields.Office:
                    pv.value = pdfInfo?.office1!
                case PDFFields.Office2:
                    pv.value = pdfInfo?.office2!
                case PDFFields.Fax:
                    pv.value = pdfInfo?.fax1!
                case PDFFields.Fax2:
                    pv.value = pdfInfo?.fax2!
                case PDFFields.Mobile:
                    pv.value = pdfInfo?.mobile1!
                case PDFFields.Mobile2:
                    pv.value = pdfInfo?.mobile2!
                    
                    //broker info
                case PDFFields.Broker:
                    pv.value = pdfInfo?.broker!
                case PDFFields.Per:
                    pv.value = pdfInfo?.brokerPercent!
                case PDFFields.Agent:
                    pv.value = pdfInfo?.brokerAgent!
                case PDFFields.BrokerEmail:
                    pv.value = pdfInfo?.brokerEmail!
                case PDFFields.BrokerOffice:
                    pv.value = pdfInfo?.brokerOffice!
                case PDFFields.BrokerFax:
                    pv.value = pdfInfo?.brokerFax!
                case PDFFields.BrokerMobile:
                    pv.value = pdfInfo?.brokerMobile!
                    
                    //builder info
                case PDFFields.ProjectManager:
                    pv.value = pdfInfo?.projectManager!
                case PDFFields.Consultant:
                    pv.value = pdfInfo?.salesConsultant!
                case PDFFields.BuilderAddress:
                    pv.value = pdfInfo?.jobAddress!
                case PDFFields.BuilderSubdivision:
                    pv.value = pdfInfo?.subdivision!
                case PDFFields.LegalDescription:
                    pv.value = pdfInfo?.cdescription!
                case PDFFields.Floorplan:
                    pv.value = pdfInfo?.floorplan!
                    
                    //financial information
                case PDFFields.ListPrice:
                    pv.value = pdfInfo?.listPrice!
                case PDFFields.Incl:
                    pv.value = pdfInfo?.UPG!
                case PDFFields.SalesPrice:
                    pv.value = pdfInfo?.salesPrice!
                case PDFFields.Allowance:
                    pv.value = pdfInfo?.allowance!
                case PDFFields.Mortgage:
                    pv.value = pdfInfo?.company!
                case PDFFields.Title:
                    pv.value = pdfInfo?.titleInsurance!
                
                    // non - refundable
                case PDFFields.Bank:
                    bankField = pv as? PDFFormTextField
                    if let item = pdfInfo?.memoItemlist?.first{
                        pv.value = item.bankName!
                    }
                case PDFFields.Check:
                    checkField = pv as? PDFFormTextField
                    if let item = pdfInfo?.memoItemlist?.first{
                        pv.value = item.check!
                    }
                case PDFFields.XType:
                    typeField = pv as? PDFFormTextField
                    if let item = pdfInfo?.memoItemlist?.first{
                        pv.value = item.type!
                    }
                case PDFFields.Amount:
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
            
//            print(pdfInfo?.memoItemlist!.count)
            additionViews.appendContentsOf(addedAnnotationViews)
            pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
            pdfView?.addedAnnotationViews = addedAnnotationViews
            view.addSubview(pdfView!)
        }
    }
    
    
    
}
