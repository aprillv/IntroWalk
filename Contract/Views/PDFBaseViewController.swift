//
//  PDFBaseViewController.swift
//  Contract
//
//  Created by April on 12/21/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Alamofire
class PDFBaseViewController: BaseViewController {
    
    var document : PDFDocument?
    var pdfView  : PDFView?
    var spinner : UIActivityIndicatorView?
    var progressBar : UIAlertController?
    var pdfInfo0 : ContractPDFBaseModel?
    
    @IBAction func goBack(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func savePDF(sender: UIBarButtonItem) {
        
        
    }
    func dismissProgress(){
        self.progressBar?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initWithData(data: NSData){
        document = PDFDocument(data: data)
    }
    
    func initWithResource(name: String){
        document = PDFDocument(resource: name)
    }
    
    func initWithPath(path: String){
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
        
        loadPDFView()
    }
    
    
    
    func loadPDFView(){
        
        
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
    func getMargins() -> CGPoint {
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
    
    func savePDFToServer(xname: String){
        //        print(parame)
        var parame : [String : String] = ["idcia" : pdfInfo0!.idcia!
            , "idproject" : pdfInfo0!.idproject!
            , "code" : pdfInfo0!.code!
            ,"filetype" : pdfInfo0!.nproject! + "_\(xname)_FromApp"]
        
        let savedPdfData = document?.savedStaticPDFData()
        let fileBase64String = savedPdfData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
        parame["file"] = fileBase64String
        parame["username"] = NSUserDefaults.standardUserDefaults().valueForKey(CConstants.LoggedUserNameKey) as? String ?? ""
        
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
    
    //    private func addEntitiesToDictionary(fromDic fromDic: [String: String], toDic: [String: String]?) -> [String: String]{
    //        var rtnDic = toDic ?? [String: String]()
    //        for one in fromDic {
    //            rtnDic[one.0] = one.1
    //        }
    //        return rtnDic
    //    }
}
