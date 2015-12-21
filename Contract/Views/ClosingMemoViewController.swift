//
//  ClosingMemoViewController.swift
//  Contract
//
//  Created by April on 12/21/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Alamofire

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
    
    
    
    @IBAction override func savePDF(sender: UIBarButtonItem) {
        //        return
        let savedPdfData = document?.savedStaticPDFData(pdfView?.addedAnnotationViews)
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let parame : [String : String] = ["idcia" : pdfInfo!.idcia!
            , "idproject" : pdfInfo!.idproject!
            , "username" : NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
            , "code" : pdfInfo!.code!
            , "file" : fileBase64String!
            , "filetype" : pdfInfo!.jobAddress! + "_ClosingMemo_FromApp"]
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
        let margins = getMargins()
        if let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y) as? [PDFWidgetAnnotationView] {
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
                    if let item = pdfInfo?.memoItemlist?.first{
                        pv.value = item.bankName!
                    }
                case PDFFields.Check:
                    if let item = pdfInfo?.memoItemlist?.first{
                        pv.value = item.check!
                    }
                case PDFFields.XType:
                    if let item = pdfInfo?.memoItemlist?.first{
                        pv.value = item.type!
                    }
                case PDFFields.Amount:
                    if let item = pdfInfo?.memoItemlist?.first{
                        pv.value = item.amount!
                    }
                default:
                    break
                    
                    
                }
            }
            
            print(pdfInfo?.memoItemlist!.count)
            
            pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
//            pdfView?.addedAnnotationViews = addedAnnotationViews
            view.addSubview(pdfView!)
            view.addSubview(pdfView!)
        }
        
        
        
        
        
        
    }
    
    
    
}
