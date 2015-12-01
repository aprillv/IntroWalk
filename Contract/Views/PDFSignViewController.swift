//
//  PDFSignViewController.swift
//  Contract
//
//  Created by April on 12/1/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class PDFSignViewController: BaseViewController {

    var document : PDFDocument?
    var pdfView  : PDFView?
    var isDownload : Bool?
    var pdfInfo : ContractSignature?
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func BuyerSign(sender: UIBarButtonItem) {
        for sign0 in pdfView!.pdfWidgetAnnotationViews {
            if let sign = sign0 as? SignatureView{
                if CGRectIntersectsRect(sign.superview!.bounds, sign.frame) {
                    if (sender.tag == 1 && sign.sname.hasSuffix(PDFFields.Buyer1Signature))
                        || (sender.tag == 2 && sign.sname.hasSuffix(PDFFields.Buyer2Signature)) {
                            sign.toSignautre()
                    }
                }
            }
        }
    }
    @IBAction func savePDF(sender: UIBarButtonItem) {
        
        let savedPdfData = document?.savedStaticPDFData()
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        let parame : [String : String] = ["idcia" : pdfInfo!.idcia!
            , "idproject" : pdfInfo!.idproject!
            , "username" : NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
            , "code" : pdfInfo!.code!
            , "file" : fileBase64String!]
        
//        print("\(parame)")
//        return;
        Alamofire.request(.POST,
            CConstants.ServerURL + CConstants.ContractUploadPdfURL,
            parameters: parame).responseJSON{ (response) -> Void in
//                self.spinner?.stopAnimating()
                if response.result.isSuccess {
                    print(response.result.value)
                    if let rtnValue = response.result.value as? [String: AnyObject]{
//                        print(rtnValue)
//                        if let msg = rtnValue["status"] as? String{
//                            print(rtnValue)
////                            if msg == "success"{
////                                
////                            }else{
////                                self.PopMsgWithJustOK(msg: msg)
////                            }
//                        }else{
//                            self.PopMsgWithJustOK(msg: CConstants.MsgServerError, txtField: nil)
//                        }
                    }else{
                        self.PopMsgWithJustOK(msg: CConstants.MsgServerError, txtField: nil)
                    }
                }else{
//                    self.spinner?.stopAnimating()
                    self.PopMsgWithJustOK(msg: CConstants.MsgNetworkError, txtField: nil)
                }
        }
        
    }
    private struct PDFFields{
        static let Buyer1Signature = "bottom1"
        static let Buyer2Signature = "bottom2"
        
        static let CompanyName = "sellercompany"
        static let Buyer = "buyer"
        static let Lot = "lot"
        static let Block = "block1"
        static let Section = "block2"
        static let City = "city"
        static let County = "county"
        static let Address = "address_1"
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
        
    }
    func initWithData(data: NSData){
        isDownload = true
        document = PDFDocument(data: data)
    }
    
    func initWithResource(name: String){
        isDownload = false
        document = PDFDocument(resource: name)
    }
    
    func initWithPath(path: String){
        isDownload = false
        document = PDFDocument(resource: path)
    }
    
    func reload(){
        document?.refresh()
        pdfView?.removeFromSuperview()
        pdfView = nil
        loadPDFView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        loadPDFView()
    }
    
    private func loadPDFView(){
        let pass = document?.documentPath ?? document?.documentData
        let margins = getMargins()
        let additionViews = document?.forms.createWidgetAnnotationViewsForSuperviewWithWidth(view.bounds.size.width, margin: margins.x, hMargin: margins.y) as? [PDFWidgetAnnotationView]
        
        let overrideFields : [String: String] = [PDFFields.CompanyName : PDFFields.CompanyName1
                    , PDFFields.Buyer : PDFFields.Buyer1
                    , PDFFields.Lot: PDFFields.Lot1
                    , PDFFields.Block : PDFFields.Block1
                    , PDFFields.Section : PDFFields.Section1
                    , PDFFields.City : PDFFields.City1
                    , PDFFields.County : PDFFields.County1
                    , PDFFields.Address : PDFFields.Address1
                    , PDFFields.SalePrice : PDFFields.SalePrice1]
        
        let na = overrideFields.keys

//        var tmp : [PDFWidgetAnnotationView] = [PDFWidgetAnnotationView]()
        for pv : PDFWidgetAnnotationView in additionViews!{
            if na.contains(pv.xname){
                if PDFFields.Address == pv.xname{
                    pv.value = "\(pdfInfo!.nproject!)/\(pdfInfo!.zipcode!)"
                }else{
                    if let a = overrideFields[pv.xname!]{
                        pv.value = pdfInfo!.valueForKey(a) as! String
                    }
                    
                }
            }
//            tmp.append(pv)
//
//            if let dic = pv.printself() {
//            
//            }
            
            
        }
        
        pdfView = PDFView(frame: view.bounds, dataOrPath: pass, additionViews: additionViews)
//        print("\(view!)")
        view.addSubview(pdfView!)
//            NSDictionary *dic = [pv printself];
//            if (dic) {
//                if ([dics.allKeys containsObject:[dic allKeys].firstObject]){
//                    [Samedics addObject:[dic allKeys].firstObject];
//                }else{
//                    [dics addEntriesFromDictionary:dic];
//                }
//            }
//        }
//        
//        for (NSString *xkey in Samedics) {
//            [dics removeObjectForKey:xkey];
//        }
//        cl_pdf *pdf = [[cl_pdf alloc] init];
//        NSString* pdfkey = [NSString stringWithFormat:@"%@_%@", self.pdfInfo[@"idcia"], self.pdfInfo[@"idcity"]];
//        if (isDownload) {
//            NSData *pdfData = [NSJSONSerialization dataWithJSONObject:dics options:kNilOptions error:nil];
//            [pdf addToPDF:pdfData withId: pdfkey];
//        }else{
//            NSData *pdfData = [pdf getPDFByKey:pdfkey];
//            
//            //        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:pdfData options:kNilOptions error:nil]);
//        }
//        
//        //    NSLog(@"%d %d %@", additionViews.count, dics.allKeys.count, dics);
//        _pdfView = [[PDFView alloc] initWithFrame:self.view.bounds dataOrPath:pass additionViews:additionViews];
//        [self.view addSubview:_pdfView];
    }
    

    private struct PDFMargin{
        static let PDFLandscapePadWMargin: CGFloat = 13.0
        static let PDFLandscapePadHMargin: CGFloat = 7.25
        static let PDFPortraitPadWMargin: CGFloat = 9.0
        static let PDFPortraitPadHMargin: CGFloat = 6.10
        static let PDFPortraitPhoneWMargin: CGFloat = 3.5
        static let PDFPortraitPhoneHMargin: CGFloat = 6.7
        static let PDFLandscapePhoneWMargin: CGFloat = 6.8
        static let PDFLandscapePhoneHMargin: CGFloat = 6.5
        
    }
    private func getMargins() -> CGPoint {
        let currentOrientation = UIApplication.sharedApplication().statusBarOrientation
        switch (UI_USER_INTERFACE_IDIOM()){
        case .Pad:
            if UIInterfaceOrientationIsPortrait(currentOrientation) {
                return CGPoint(x:PDFMargin.PDFPortraitPadWMargin, y:PDFMargin.PDFPortraitPadHMargin)
            }else{
                return CGPoint(x:PDFMargin.PDFLandscapePadWMargin, y:PDFMargin.PDFLandscapePadHMargin)
            }
            
        default:
            if UIInterfaceOrientationIsPortrait(currentOrientation) {
                return CGPoint(x:PDFMargin.PDFPortraitPhoneWMargin, y:PDFMargin.PDFPortraitPhoneHMargin)
            }else{
                return CGPoint(x:PDFMargin.PDFLandscapePhoneWMargin, y:PDFMargin.PDFLandscapePhoneHMargin)
            }
        }
    }
    
}
