//
//  checklistViewController.swift
//  CheckList
//
//  Created by April on 1/21/17.
//  Copyright © 2017 HapApp. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import Foundation
import BSImagePicker
import Photos

class IntroWalkItemViewController: BaseViewController , UICollectionViewDataSource, UICollectionViewDelegate, UIPrintInteractionControllerDelegate, UITextViewDelegate, selectionImageCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var xfrom = 1
    
    @IBOutlet weak var NoId: UIBarButtonItem!
    @IBOutlet var delEditBtn: UIButton!
    @IBAction func DoCancelDel(_ sender: AnyObject) {
        self.commentTxt.resignFirstResponder()
        
        doCancelDel2()
    }
    
    fileprivate func doCancelDel2(){
        if (self.photoList?.count ?? 0) > 0 {
            for si in 0...((self.photoList?.count ?? 0) - 1) {
                let nindex = IndexPath(row: si, section: 0)
                if let cell = self.collectionListView.cellForItem(at: nindex) as? selectionImageCell {
                    cell.delelteBtn.isHidden = true
                    cell.layer.removeAllAnimations()
                }
            }
        }
        
        self.delEditBtn.isHidden = true
    }
    @IBOutlet var commentTxt: UITextView!{
        didSet{
            commentTxt.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
            commentTxt.layer.borderWidth = 1.0 / UIScreen.main.scale
            commentTxt.layer.cornerRadius = 5
//            commentTxt.text = "Comments"
//            commentTxt.textColor = UIColor.lightGrayColor()
            commentTxt.delegate = self
        }
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
//        if commentTxt.textColor == UIColor.lightGrayColor() {
//            textView.text = ""
//            textView.textColor = UIColor.blackColor()
//        }
        doCancelDel2()
        return true
    }
//
//    func textViewDidChange(textView: UITextView) {
//        if textView.text.characters.count == 0 {
//            commentTxt.text = "Comments"
//            commentTxt.textColor = UIColor.blackColor()
//            commentTxt.textColor = UIColor.lightGrayColor()
//        }
//    }
    
    var projectInfo : projectItem?
    
    @IBAction func goLogout(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
//    @IBAction func DoPrint(sender: AnyObject) {
//        let count = (xfrom == 1 ? self.selectionList!.count : self.pricebookTemplateItemList!.count)
//        if count == 0 {
//            return;
//        }
//        
//        //        UIView* testView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
//        //        NSMutableData* pdfData = [NSMutableData data];
//        //        UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0.0f, 0.0f, 792.0f, 612.0f), nil);
//        //        UIGraphicsBeginPDFPage();
//        //        CGContextRef pdfContext = UIGraphicsGetCurrentContext();
//        //        CGContextScaleCTM(pdfContext, 0.773f, 0.773f);
//        //        [testView.layer renderInContext:pdfContext];
//        //        UIGraphicsEndPDFContext();
//        // 1: from assembily 2 from pricebook template
//        
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0.0, 0.0, 612.0, 792.0), nil)
//        
//        //        UIGraphicsBeginPDFPage()
//        //        var pdfContext = UIGraphicsGetCurrentContext()
//        //        CGContextScaleCTM(pdfContext, 0.773, 0.773)
//        
//        //        let printView = UIView(frame: CGRect(x: 0, y: 0, width: 768.0, height: 1024.0))
//        //
//        //        var upc = UILabel(frame: CGRect(x: 8, y: 10, width: 740, height: 21))
//        //
//        //        let userInfo = NSUserDefaults.standardUserDefaults()
//        //        if let cianame = userInfo.valueForKey(CConstants.UserInfoCiaName) as? String  {
//        //                upc.text = cianame
//        //        }
//        //        printView.addSubview(upc)
//        //        upc = UILabel(frame: CGRect(x: 8, y: 32, width: 740, height: 21))
//        //        upc.text = "Part Picture List"
//        //        printView.addSubview(upc)
//        //        for i in 0...self.selectionList!.count-1 {
//        //            let item = self.selectionList![i]
//        //            let view = UIView(frame: CGRectMake(CGFloat((i%3)*255)+4, CGFloat((i/3)*250) + 60, CGFloat(254), CGFloat(240)))
//        //            view.layer.borderColor = CConstants.BorderColor.CGColor
//        //            view.layer.borderWidth = 1.0
//        //            let upc = UILabel(frame: CGRect(x: 8, y: 0, width: 246, height: 21))
//        //            let name = UILabel(frame: CGRect(x: 8, y: 21, width: 246, height: 21))
//        //            let image = UIImageView(frame: CGRect(x: 8, y: 42, width: 238, height: 196))
//        //            upc.text = item.upc!
//        //            name.text = item.selectionarea
//        //            let indexpath = NSIndexPath(forItem: i, inSection: 0)
//        //            if let cell = self.collectionListView.cellForItemAtIndexPath(indexpath) as? selectionImageCell {
//        //            image.image = cell.pic.image
//        //            }
//        //
//        //            view.addSubview(upc)
//        //            view.addSubview(name)
//        //            view.addSubview(image)
//        //            printView.addSubview(view)
//        ////
//        //
//        //        }
//        var printView :UIView?
//        var pdfContext : CGContext?
//        
//        for i in 0...count-1 {
//            if i % 12 == 0 {
//                UIGraphicsBeginPDFPage()
//                pdfContext = UIGraphicsGetCurrentContext()
//                CGContextScaleCTM(pdfContext, 0.773, 0.773)
//                
//                printView = UIView(frame: CGRect(x: 0, y: 0, width: 768.0, height: 1024.0))
//                var upc1 = UILabel(frame: CGRect(x: 8, y: 10, width: 740, height: 21))
//                
//                let userInfo = NSUserDefaults.standardUserDefaults()
//                if let cianame = userInfo.valueForKey(CConstants.UserInfoCiaName) as? String  {
//                    upc1.text = cianame
//                }
//                printView!.addSubview(upc1)
//                upc1 = UILabel(frame: CGRect(x: 8, y: 32, width: 740, height: 21))
//                upc1.text = "Part Picture List"
//                printView!.addSubview(upc1)
//            }
//            
//            var strupc : String?
//            var xdescription : String?
//            var url: String
//            
//            switch xfrom {
//            case 1:
//                let item = self.selectionList![i]
//                strupc = item.upc!
//                xdescription = item.selectionarea!
//                url =  "https://contractssl.buildersaccess.com/baselection_image?idcia=\(item.idcia!)&idassembly1=\(item.idassembly1!)&upc=\(item.upc!)&isthumbnail=0"
//                
//            default:
//                let item = self.pricebookTemplateItemList![i]
//                strupc = item.part!
//                xdescription = item.xdescription!
//                url =  getImageUrl(item.part!)
//                
//                
//            }
//            
//            let view = UIView(frame: CGRectMake(CGFloat((i%3)*255)+4, CGFloat(((i%12)/3)*250) + 60, CGFloat(254), CGFloat(240)))
//            view.layer.borderColor = CConstants.BorderColor.CGColor
//            view.layer.borderWidth = 1.0
//            let upc = UILabel(frame: CGRect(x: 8, y: 0, width: 246, height: 21))
//            let name = myUILabel(frame: CGRect(x: 8, y: 21, width: 246, height: 39))
//            name.numberOfLines = 2
//            name.font = UIFont(name: ".SFUIText-Regular", size: 15.0)
//            name.verticalAlignment = VerticalAlignmentTop
//            let image = UIImageView(frame: CGRect(x: 8, y: 42, width: 238, height: 196))
//            upc.text = strupc
//            name.text = xdescription
//            
//            if SDImageCache.sharedImageCache().diskImageExistsWithKey(url) {
//                image.image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(url)
//            }else{
//                image.image = UIImage(data: NSData(contentsOfURL: NSURL(string: url)!)!)
//                SDImageCache.sharedImageCache().storeImage(image.image, forKey: url)
//            }
//            
//            view.addSubview(upc)
//            view.addSubview(image)
//            view.addSubview(name)
//            
//            //            print(view.frame)
//            printView!.addSubview(view)
//            if (i + 1) % 12 == 0 || i == count-1{
//                printView!.layer.renderInContext(pdfContext!)
//            }
//            //
//            
//        }
//        
//        //        printView.layer.renderInContext(<#T##ctx: CGContext##CGContext#>)
//        UIGraphicsEndPDFContext()
//        
//        if UIPrintInteractionController.canPrintData(pdfData) {
//            
//            let printInfo = UIPrintInfo(dictionary: nil)
//            printInfo.jobName = "Part Picture List"
//            printInfo.outputType = .Photo
//            
//            let printController = UIPrintInteractionController.sharedPrintController()
//            printController.printInfo = printInfo
//            printController.showsNumberOfCopies = false
//            
//            printController.printingItem = pdfData
//            
//            printController.presentAnimated(true, completionHandler: nil)
//            printController.delegate = self
//        }
//    }
    
    fileprivate func getImageUrl(_ ids : String) -> String{
        if let _ = idpricebooktemplate {
            return "https://contractssl.buildersaccess.com/baselection_pricebookTemplateItemPicture?idcia=1&idpricebooktemplate=\(idpricebooktemplate!)&upc=\(ids)&isthumbnail=0"
        }else if let _ = iddevelopmenttemplate {
            return "https://contractssl.buildersaccess.com/baselection_specFeatureDevelopmentItemImage?idcia=1&iddevelopmenttemplate1=\(iddevelopmenttemplate!)&upc=\(ids)&isthumbnail=0"
        }else {
            return "https://contractssl.buildersaccess.com/baselection_floorplanItemImage?idcia=1&idfloorplan=\(idfloorplantemplate!)&upc=\(ids)&isthumbnail=0"
            
        }
        
    }
    func printInteractionControllerParentViewController(_ printInteractionController: UIPrintInteractionController) -> UIViewController? {
        return self.navigationController!
    }
    func printInteractionControllerWillPresentPrinterOptions(_ printInteractionController: UIPrintInteractionController) {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 164/255.0, blue: 236/255.0, alpha: 1)
        self.navigationController?.topViewController?.navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 164/255.0, blue: 236/255.0, alpha: 1)
    }
    @IBOutlet var collectionListView: UICollectionView!{
        didSet{
            //            if let _ = selectionList {
            //                collectionListView.reloadData()
            //            }
            if let _ = photoList {
                collectionListView.reloadData()
            }
        }
    }
    
    var photoList: [AnyObject]?{
        didSet{
            
            if collectionListView != nil {
                collectionListView.reloadData()
            }
        }
    }
    
   
    
    fileprivate struct constants{
        static let cellIdentifier = "selectionImageCell"
    }
    
    var idpricebooktemplate : String?
    
    var iddevelopmenttemplate : String?
    var idfloorplantemplate : String?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: constants.cellIdentifier, for: indexPath)
        if let cell1 = cell as? selectionImageCell {
            
            cell1.selDelegate = self
            if indexPath.row < (self.photoList?.count ?? 0) {
                cell1.layer.borderColor = UIColor.clear.cgColor
                cell1.pic.contentMode = .scaleAspectFill
                
//                let img = SDImageCache.sharedImageCache().storeImage(<#T##image: UIImage!##UIImage!#>, forKey: String!, toDisk: <#T##Bool#>)
                if let tmp0 = self.photoList![indexPath.row] as? UIImage {
                    cell1.pic.image = tmp0
                }else if let tmp1 = self.photoList![indexPath.row] as? cl_ObjIntroWalk2Photo {
                    cell1.spinner.startAnimating()
                    cell1.pic.sd_setImage(with: URL(string: tmp1.photoUrl!), completed: { (_, _, _, _) -> Void in
                            cell1.spinner.stopAnimating()
                        })
                }
                cell1.delelteBtn.isHidden = self.delEditBtn.isHidden
//                if !cell1.delelteBtn.hidden{
//                    cell1.layer.addAnimation(self.starAnim(indexPath.row), forKey: "transform")
//                }
                
            }else{
                cell1.layer.borderColor = UIColor.lightGray.cgColor
                cell1.pic.contentMode = .center
                cell1.pic.image = UIImage(named: "add")
                cell1.delelteBtn.isHidden = true
               
            }
            
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cnt = photoList?.count ?? 0
        if (cnt) < 12 {
            return cnt + 1
        }else{
            return 12
        }
        
    }
    
    @IBOutlet var CancelBtn: UIButton! {
        didSet{
            self.setBtnStyle(CancelBtn)
        }
    }
    @IBOutlet var SubmitBtn: UIButton! {
        didSet{
            self.setBtnStyle(SubmitBtn)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if xno == 0 && self.projectInfo != nil {
            let dbintro = cl_introWalkLocal()
            xno = dbintro.getMaxCheckListId(self.projectInfo!) + 1
            self.NoId.title = "# \(xno!)"
        }else if xno != 0 && self.projectInfo != nil && xno != nil {
            let dbintro = cl_introWalkLocal()
            let item = dbintro.getIntroWalkItem(self.projectInfo!, xno: xno!)
            self.commentTxt.text = item.comments
            self.photoList = item.photos
            self.NoId.title = "# \(xno!)"
        }
        
        if self.photoList == nil {
            self.photoList = [AnyObject]()
        }
        
//        let checkLocalDb = cl_checklistLocal()
//        let rtn = checkLocalDb.getCheckList(self.projectInfo!)
//        
//        if self.idchecklist == "-1" {
//            self.idchecklist = "0"
//            if rtn.1 == "0" {
//                self.localidchecklist = "1"
//            }
//            return
//        }
//        
//       
//        if rtn.0 == "" && rtn.1 == "0"{
//            let net = NetworkReachabilityManager()
//            if  net?.isReachable ?? false {
//                //            {"email":"String","password":"String","idcia":"String","idproject":"String"}
//                let userInfo = UserDefaults.standard
//                let email = userInfo.object(forKey: CConstants.UserInfoEmail) as? String ?? ""
//                let pwd = userInfo.object(forKey: CConstants.UserInfoPwd) as? String ?? ""
//                
//                var param = [String : String]()
//                param["email"] = email
//                param["password"] = pwd
//                param["idcia"] = self.projectInfo?.idcia ?? ""
//                param["idproject"] = self.projectInfo?.idproject ?? ""
//                param["idchecklist"] = self.idchecklist
//                
//                print(param)
//                var hud : MBProgressHUD?
//                hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//                hud?.label.text = CConstants.RequestMsg
//                Alamofire.request(CConstants.ServerURL + CConstants.GetCheckListServiceURL, parameters: param).responseJSON{ (response) -> Void in
//                    if response.result.isSuccess {
////                        print(response.result.value)
//                        //                    {"idproject":"String","idcia":"String","idchecklist":"String","comment":"String","photocnt":"String"}
//                        if let rtn = response.result.value as? [String: String] {
//                            //                        print(response.result.value)
//                            self.idchecklist = rtn["idchecklist"] ?? "0"
//                            if self.idchecklist == "0" || self.idchecklist == ""{
//                                self.idchecklist = "0"
//                                let checkLocalDb = cl_checklistLocal()
//                                let rtn = checkLocalDb.getCheckList(self.projectInfo!)
//                                if rtn.0 == "" && rtn.1 == "0"{
//                                    
//                                }else{
//                                    self.idchecklist = rtn.1
//                                    self.commentTxt.text = rtn.0
//                                    let checkPhotoLocal = cl_checklistphotolocal()
//                                    if let photos = checkPhotoLocal.getCheckListPhotoNotSynced(self.projectInfo!, idcheck: self.idchecklist ?? "0"){
//                                        for photo in photos {
//                                            self.photoList?.append((photo.value(forKey: "url") as? String ?? "" ) as AnyObject )
//                                        }
//                                        self.collectionListView.reloadData()
//                                    }
//                                }
//                            }else{
//                                self.commentTxt.text = rtn["comment"] ?? "";
//                                
//                                let serverDB = cl_checklistDB()
//                                serverDB.savedCheckListToDB(self.projectInfo!, comment: self.commentTxt.text, idcheck: self.idchecklist ?? "0")
//                                
//                                let cnt = Int(rtn["photocnt"] ?? "0") ?? 0
//                                if cnt > 0 {
//                                    let tool = util()
//                                    self.photoList = [AnyObject]()
//                                    let photoDB = cl_checklistphotoDB()
//                                    for i in 0...(cnt - 1) {
//                                        let xidx = String(i+1)
//                                        let url = tool.getImgFromServer(self.idchecklist ?? "0", idx: xidx, idcia: self.projectInfo!.idcia!, idproject: self.projectInfo!.idproject!)
//                                        
//                                        photoDB.savedCheckListPhotoToDB(self.projectInfo!, idcheck: self.idchecklist ?? "0", idx: xidx, url: url)
//                                        
//                                        self.photoList?.append(url as AnyObject)
//                                    }
//                                    self.collectionListView.reloadData()
//                                }
//                            }
//                            
//                        }
//                    }else{
//                        
//                    }
//                    hud?.hide(animated: true)
//                }
//            }else{
//                let checkLocalDb = cl_checklistLocal()
//                let rtn = checkLocalDb.getCheckList(self.projectInfo!)
//                if rtn.0 == "" && rtn.1 == "0"{
//                    let checkDb = cl_checklistDB()
//                    let rtn2 = checkDb.getCheckList(self.projectInfo!)
//                    self.idchecklist = rtn2.1
//                    self.commentTxt.text = rtn2.0
//                    let checkPhotoDBLocal = cl_checklistphotoDB()
//                    if let photos = checkPhotoDBLocal.getCheckListPhotoSaved(self.projectInfo!, idcheck: self.idchecklist ?? "0"){
//                        for photo in photos {
//                            self.photoList?.append((photo.value(forKey: "url") as? String ?? "" ) as AnyObject )
//                        }
//                        self.collectionListView.reloadData()
//                    }
//                }else{
//                    self.idchecklist = rtn.1
//                    self.commentTxt.text = rtn.0
//                    let checkPhotoLocal = cl_checklistphotolocal()
//                    if let photos = checkPhotoLocal.getCheckListPhotoNotSynced(self.projectInfo!, idcheck: self.idchecklist ?? "0"){
//                        for photo in photos {
//                            self.photoList?.append((photo.value(forKey: "url") as? String ?? "" ) as AnyObject )
//                        }
//                        self.collectionListView.reloadData()
//                    }
//                }
//            }
//        }else{
//            self.idchecklist = rtn.1
//            self.commentTxt.text = rtn.0
//            let checkPhotoLocal = cl_checklistphotolocal()
//            if let photos = checkPhotoLocal.getCheckListPhotoNotSynced(self.projectInfo!, idcheck: self.idchecklist ?? "0"){
//                for photo in photos {
//                    self.photoList?.append((photo.value(forKey: "url") as? String ?? "" ) as AnyObject )
//                }
//                self.collectionListView.reloadData()
//            }
//        }
        
    }
    
    var imagePicker : UIImagePickerController?
    func addPhoto(_ cell : selectionImageCell){
        self.DoCancelDel(self.delEditBtn)
        if (self.collectionListView.indexPath(for: cell)?.row ?? 0) == (self.photoList?.count ?? 0) {
            self.commentTxt.resignFirstResponder()
            
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Add Photo", message: nil, preferredStyle: .alert)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default)
            { action -> Void in
//                self.imagePicker =  UIImagePickerController()
//                self.imagePicker?.delegate = self
//                //            self.imagePicker?.allowsEditing = true
//                self.imagePicker?.sourceType = .PhotoLibrary
//                self.presentViewController(self.imagePicker!, animated: true, completion: nil)
                
                let vc = BSImagePickerViewController()
                vc.albumButton.tintColor = UIColor.white
                vc.maxNumberOfSelections = (12-(self.photoList?.count ?? 0))
                _ = vc.doneButton;
                self.bs_presentImagePickerController(vc, animated: true,
                                                select: { (asset: PHAsset) -> Void in
//                                                    print("Selected: \(asset)")
                    }, deselect: { (asset: PHAsset) -> Void in
//                        print("Deselected: \(asset)")
                    }, cancel: { (assets: [PHAsset]) -> Void in
//                        print("Cancel: \(assets)")
                    }, finish: { (assets: [PHAsset]) -> Void in
//                        print("Finish: \(assets)")
                        
                        for asset in assets {
                            let imgsize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                            let ops = PHImageRequestOptions()
                            ops.deliveryMode = .highQualityFormat
                            let m = PHImageManager()
                            m.requestImage(for: asset, targetSize: imgsize, contentMode: .aspectFill, options: ops, resultHandler: { (img, info) in
                                if let a = img {
                                    
                                    self.photoList?.append(a)
                                    self.collectionListView.reloadData()
                                }
                                
                            })
                        }
                    }, completion: nil)
                

            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default)
            { action -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker =  UIImagePickerController()
                    self.imagePicker?.delegate = self
                    //            self.imagePicker?.allowsEditing = true
                    self.imagePicker?.sourceType = .camera
                    self.present(self.imagePicker!, animated: true, completion: nil)
                }
                
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            
//            let popOver = actionSheetControllerIOS8.popoverPresentationController
//            popOver?.sourceView = cell
//            popOver?.sourceRect = cell.bounds
//            popOver?.permittedArrowDirections = .Any
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            
//            let alertController = UIAlertController(title: "Add Photo", message: "", preferredStyle: .ActionSheet)
//            
//            
//            
//            
//            let oKAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default) { action -> Void in
//                //Do some stuff
//            }
//            alertController.addAction(oKAction)
//            
//            let cancelAction1: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default) { action -> Void in
//                //Do some stuff

//            }
//
//            alertController.addAction(cancelAction1)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
////                alertController.dismissViewControllerAnimated(true, completion: nil)
//            }
//            alertController.addAction(cancelAction)
//            
//            //Present the AlertController
//            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            self.performSegue(withIdentifier: "showBig", sender: cell)
        
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
                
            case "showBig":
                
                if let checkListView = segue.destination as? BigPictureViewController{
                    if let a = sender as? selectionImageCell {
                        checkListView.imageorgin = a.pic.image
//                        if let index = self.collectionListView.indexPathForCell(a) {
                        
//                        }
                    }
                }
                
            default:
                break;
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker?.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageData = UIImageJPEGRepresentation(image, 0.65)
            let newimage = UIImage(data:imageData!,scale:1.0)
            if self.photoList == nil {
                self.photoList = [AnyObject]()
            }
            self.photoList?.append(newimage!)
            self.collectionListView.reloadData()
            //            }else{
            //                self.lbl?.hidden = true
            //                self.image.image = image
            //
            //                self.uploadAttachedPhoto(image)
            //            }
        }
        
        
        
        
        
    }

    func deletePhoto(_ tag: Int, cell: selectionImageCell) {
        self.commentTxt.resignFirstResponder()
        let index = self.collectionListView.indexPath(for: cell)
        if (index?.row ?? 0) < (self.photoList?.count ?? 0) {
            self.photoList?.remove(at: index?.row ?? 0)
            self.collectionListView.reloadData()
            self.delEditBtn.setTitle("Done", for: UIControlState())
            if (self.photoList?.count ?? 0) == 0 {
                cell.delelteBtn.isHidden = true
            }
            
        }
        
    }
    func delPhoto(_ cell: selectionImageCell) {
        let index = self.collectionListView.indexPath(for: cell)
        if (index?.row ?? 0) < (self.photoList?.count ?? 0)  {
            self.commentTxt.resignFirstResponder()
            self.delEditBtn.setTitle("Cancel", for: UIControlState())
            self.delEditBtn.isHidden = false
            if (self.photoList?.count ?? 0) > 0 {
                for si in 0...((self.photoList?.count ?? 0) - 1) {
                    let nindex = IndexPath(row: si, section: 0)
                    if let cell = self.collectionListView.cellForItem(at: nindex) as? selectionImageCell {
                        cell.delelteBtn.isHidden = false
//                        cell.layer.addAnimation(self.starAnim(si), forKey: "transform")
                        
                    }
                    
                }
                //            starAnim()
                
            }
        }
        
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        self.DoCancelDel(self.delEditBtn)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func DoSubmit(_ sender: UIBarButtonItem) {
        self.DoSubmitPicture(self.SubmitBtn)
    }
    
    var xno: Int32?
    
    @IBAction func DoSubmitPicture(_ sender: UIButton) {
        
        self.DoCancelDel(self.delEditBtn)
        self.commentTxt.resignFirstResponder()
//        let userInfo = UserDefaults.standard
//        let email = userInfo.object(forKey: CConstants.UserInfoEmail) as? String ?? ""
        let tool = util()
        let introWalkLocalDb = cl_introWalkLocal()
        let introWalkPhotoLocalDb = cl_introWalkPhotoLocal()
        if commentTxt.text == ""{
        self.PopMsgWithJustOK(msg: "Comment is Required.", action1: { (action) in
            self.commentTxt.becomeFirstResponder()
        })
        }else {
            if xno == nil {
                xno = 0
            }
            // save Data to Local Database begin
            let xidintrowalk2 = introWalkLocalDb.savedIntroWalkItemToDB(self.projectInfo!, comment: self.commentTxt.text, xno: xno ?? 0)
            
            let pro = cl_project()
            if self.projectInfo?.introwalk_status == "" {
                self.projectInfo?.introwalk_status = "Draft"
            }
            pro.saveIntroWalkForProject(self.projectInfo!)
            
//            let pro = cl_project()url	String	"https://contractssl.buildersaccess.com/bachecklist_getChecklistPhoto.json?email=roberto@buildersaccess.com&password=11111&idchecklist=-1&idx=1&isthumbnail=0&idcia=100&idproject=205038"	
//            pro.saveCheckListForProject(self.projectInfo!)
//            introWalkPhotoLocalDb.deleteCheckListPhotoFromServer22(idIntroWalk2!)
            if (photoList?.count ?? 0) > 0 {
                var i : Int32 = 0
                var newUrl = [String]()
                
                for img in photoList! {
                    let url = tool.getImgFromServer(xidintrowalk2, xno: i + 1, idcia: self.projectInfo!.idcia!, idproject: self.projectInfo!.idproject!, islocal: true)
                    print(url)
                    if let tmp0 = img as? UIImage {
                        SDImageCache.shared().store(tmp0, forKey: url, toDisk: true)
                    }else if let tmp1 = img as? cl_ObjIntroWalk2Photo {
                        
                        let dimg = SDImageCache.shared().imageFromDiskCache(forKey: tmp1.photoUrl ?? "")
                        newUrl.append(url)
                        SDImageCache.shared().store(dimg, forKey: url , toDisk: true)
                    }
                    introWalkPhotoLocalDb.savedIntroWalkItemPhotoToDB(xidintrowalk2, url: url)
                    
                    i = i + 1
                }
                
                for img in photoList! {
                    if let tmp1 = img as? String {
                        if !newUrl.contains(tmp1) {
                            SDImageCache.shared().removeImage(forKey: tmp1, fromDisk: true)
                        }
                    }
                }
            }// save Data to Local Database end 
            
            var hud : MBProgressHUD?
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = .customView
            self.HUDProgress = hud
            let image = UIImage(named: CConstants.SuccessImageNm)
            hud?.customView = UIImageView(image: image)
            hud?.label.text = "Saved To Device."
            //"Saved To Device, the Data will synchronize \nto BA Server when network connected."
            self.perform(#selector(IntroWalkItemViewController.dismissProgress as (IntroWalkItemViewController) -> () -> ()), with: nil, afterDelay: 1)
        }
        
    }
    
    var HUDProgress : MBProgressHUD?
    
    func dismissProgress() {
        self.HUDProgress?.hide(animated: true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbar.isHidden = true
        self.setCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.toolbar.isHidden = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.setCollectionView()
    }
    
    fileprivate func setCollectionView(){
        var itemSize : CGSize
        if UIDevice.current.orientation.isPortrait {
            itemSize = CGSize(width: 178, height: 178)
        }else{
            itemSize = CGSize(width: 159, height: 159)
        }
        (self.collectionListView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = itemSize

    }
    
    func starAnim(_ i: Int) -> CAKeyframeAnimation{
        
        
        
        
//            // 1:创建动画对象
//            let anim = CAKeyframeAnimation(keyPath: "transform")
//            //        let wobbleAngle = 0.06
//            let valLeft = NSValue.init(CATransform3D: CATransform3DMakeRotation(0.06, 0.0, 0.0, 1.0))
//            let valRight = NSValue.init(CATransform3D: CATransform3DMakeRotation(-0.06, 0.0, 0.0, 1.0))
//            anim.values = [valLeft, valRight]
//            
//            anim.repeatCount = Float(MAX_CANON)
//            anim.duration = 0.125
//            anim.autoreverses = true
            
            let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
            transformAnim.values  = [NSValue(caTransform3D: CATransform3DMakeRotation(0.02, 0.0, 0.0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(-0.02 , 0, 0, 1))]
            transformAnim.autoreverses = true
            transformAnim.duration  = (Double(i).truncatingRemainder(dividingBy: 2)) == 0 ?   0.115 : 0.105
            transformAnim.repeatCount = Float.infinity
//         transformAnim.repeatCount = 4
            return transformAnim
            
            
        
        
        
        
    }
    

}

