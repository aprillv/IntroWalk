//
//  CheckListTableViewController.swift
//  Contract
//
//  Created by April Lv on 2/17/17.
//  Copyright © 2017 HapApp. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SDWebImage

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}


class IntroWalkListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, IntroWalkTableViewCellDelegate, selectionImageCellDelegate, DoOperationDelegate {
    
    @IBOutlet weak var pm1Sign: UIImageView!

    @IBOutlet weak var sendItem: UIBarButtonItem!
    @IBOutlet weak var hoSign: UIImageView!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var buyerNm: UILabel!
    private struct Constants{
        static let gotoNewCheckListSegue = "gotoNewChecklist"
        static let cellIdentifier = "ChecklistCell"
        static let gotoBigImageSegue = "showBig"
        static let sendOperationSegue = "SendOperation"
        
        //finish & rewalk
        static let FinishRewalkStatus = "IntroWalk"
        static let FinishRewalkFinishYn = "0"
        static let FinishRewalkStatusId = "1"
        
        //finish & close
        static let FinishCloseStatus = "IntroWalk"
        static let FinishCloseFinishYn = "1"
        static let FinishCloseStatusId = "1"
        
    }
    @IBOutlet weak var introWalkItemsTableview: UITableView!{
        didSet{
            introWalkItemsTableview.separatorColor = UIColor.clear
            introWalkItemsTableview.estimatedRowHeight = introWalkItemsTableview.rowHeight
            introWalkItemsTableview.rowHeight = UITableViewAutomaticDimension
            introWalkItemsTableview.delegate = self
            introWalkItemsTableview.dataSource = self
        }
    }
    
    var projectInfo: projectItem? {
        didSet{
            
//            getCheckListTableFromServer()
        }
    }
    
    
    var walkItems : [cl_ObjIntroWalk2]? {
        didSet{
            self.introWalkItemsTableview.reloadData()
        }
    }
    
    private func getCheckListTableFromServer(){
      
        if let project = self.projectInfo {
            let pmurl = self.getIntroWalk1PMInitialURL(project.idcia ?? "", idproject: project.idproject ?? "")
            self.pm1Sign.isHidden = false
            if let img = SDImageCache.shared().imageFromDiskCache(forKey: pmurl) {
            self.pm1Sign.image = img
            }
            
            let hourl = self.getIntroWalk1HOInitialURL(project.idcia ?? "", idproject: project.idproject ?? "")
            self.hoSign.isHidden = false
            if let img = SDImageCache.shared().imageFromDiskCache(forKey: hourl) {
                self.hoSign.image = img
            }
            
            let introwalk2 = cl_introWalkLocal()
            self.walkItems = introwalk2.getIntroWalkItems(project)

        }
    }
    
    private func SetHomeOwener(sd: String) {
        if projectInfo?.buyer2name == "" {
            buyerNm.text = projectInfo?.buyer1name ?? ""
        }else{
            buyerNm.text = (projectInfo?.buyer1name ?? "") + ", " + (projectInfo?.buyer2name ?? "")
        }
        if sd != "" {
            self.buyerNm.numberOfLines = 0
            self.buyerNm.text = self.buyerNm.text! + "\nFinished @ " + sd
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Intro Walk List"
        self.projectInfo = cl_project().getProjectByPro(pro: self.projectInfo!)
        projectName.text = projectInfo?.name
        SetHomeOwener(sd: "")
        if let project = self.projectInfo {
            if project.finishyn == "1" {
                
                SetHomeOwener(sd: project.finishDate ?? "")
                self.bottomSpace.constant = -40
                self.view.updateConstraintsIfNeeded()
                
                self.sendItem.title = "Finished"
                self.sendItem.image = nil
            }
        }
        
        
        getIntroWalk()
    }

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Constants.gotoNewCheckListSegue:
                
                if let viewc = segue.destination as? IntroWalkItemViewController {
                    viewc.projectInfo = self.projectInfo
                    if let item = sender as? cl_ObjIntroWalk2 {
//                        viewc.idchecklist = item.idchecklist ?? ""
                        viewc.xno = item.xno
                    }else{
                        viewc.xno = 0
                    }
                    
                }
            case Constants.gotoBigImageSegue:
                
                if let checkListView = segue.destination as? BigPictureViewController{
                    if let a = sender as? selectionImageCell {
                        checkListView.imageorgin = a.pic.image
                    }
                }
            case Constants.sendOperationSegue:
                if let checkListView = segue.destination as? SendOperationViewController{
                    if !self.btn.isHidden {
                        checkListView.showRewalk = (self.walkItems?.count ?? 0) > 0
                        checkListView.showClose = (self.walkItems?.count ?? 0) > 0
                    }else{
                        var cnt = 0
                        var allcnt = 0;
                        for i in 0...(self.walkItems?.count ?? 1)-1 {
                            let item1 = self.walkItems![i]
                            if item1.initial_finishyn == "1" {
                                continue
                            }
                            allcnt += 1
                            let index = IndexPath(row: i, section: 0)
                            if let cell = self.introWalkItemsTableview.cellForRow(at: index) as? IntroWalkTableViewCell {
                                if cell.btn.isHidden {
                                    cnt = cnt + 1
                                }
                            }
                        }
                        
                        if cnt == allcnt {
                            checkListView.showClose = true
                            checkListView.showRewalk = false
                        }else if cnt == 0 {
                            checkListView.showClose = false
                            checkListView.showRewalk = false
                        }else{
                            checkListView.showClose = false
                            checkListView.showRewalk = true
                        }
                    }
                    
                    checkListView.delegate1 = self
                }
            default:
                break
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walkItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let item = walkItems![indexPath.row]
        if let cell0 = cell as? IntroWalkTableViewCell {
            cell0.setContent(item: item, no: indexPath.row, del: self)
            
            if self.btn.isHidden {
//                print(self.projectInfo?.finishyn)
                if self.projectInfo?.finishyn == "1" {
                    cell0.btn.isHidden = true
                    
//                    let tool = util()
//                    let initialurl = tool.getInitialFromServer(item.idnumber ?? 0, xno: Int32(indexPath.row), idcia: self.projectInfo!.idcia!, idproject: self.projectInfo!.idproject!, islocal: true)
                    
                    //                    SDImageCache.shared().store(init1, forKey: initialurl, toDisk: true)
                    if let _ = SDImageCache.shared().imageFromDiskCache(forKey: (item.initialURL ?? "")) {
                        //                    cell.initialImg.sd_imageURL() = URL(str)
//                        cell0.btn.isHidden = true
                        cell0.initialImg.sd_setImage(with: URL(string: (item.initialURL ?? "")), completed: { (_, _, _, _) -> Void in
                            //                        cell1.spinner.stopAnimating()
                        })
                    }else{
                        if (item.initial_finishyn ?? "") == "1" {
//                            cell0.btn.isHidden = true
                            if item.initial != nil && item.initial != "" {
                                let dataDecoded : Data = Data(base64Encoded: item.initial!, options: .ignoreUnknownCharacters)!
                                let decodedimage = UIImage(data: dataDecoded)
                                cell0.initialImg.image = decodedimage
                                item.initialURL = self.getIntroWalk2InitialURL(item.idnumber ?? 0)
                                if cell0.initialImg.image != nil {
                                    SDImageCache.shared().store(cell0.initialImg.image!, forKey: (item.initialURL ?? ""), toDisk: true)
                                }
                            }
                        }
                    }
                    
                    
                }else{
                    
//                    let tool = util()
//                    let initialurl = tool.getInitialFromServer(item.idnumber ?? 0, xno: Int32(indexPath.row), idcia: self.projectInfo!.idcia!, idproject: self.projectInfo!.idproject!, islocal: true)
                    
//                    SDImageCache.shared().store(init1, forKey: initialurl, toDisk: true)
//                    print(item.initialURL)
                    if let _ = SDImageCache.shared().imageFromDiskCache(forKey: (item.initialURL ?? "")) {
                        //                    cell.initialImg.sd_imageURL() = URL(str)
                        cell0.btn.isHidden = true
                        cell0.initialImg.sd_setImage(with: URL(string: item.initialURL ?? ""), completed: { (_, _, _, _) -> Void in
                            //                        cell1.spinner.stopAnimating()
                        })
                    }else{
                        if (item.initial_finishyn ?? "") == "1" {
                            cell0.btn.isHidden = true
                            if item.initial != nil && item.initial != "" {
                                let dataDecoded : Data = Data(base64Encoded: item.initial!, options: .ignoreUnknownCharacters)!
                                let decodedimage = UIImage(data: dataDecoded)
                                cell0.initialImg.image = decodedimage
                                item.initialURL = self.getIntroWalk2InitialURL(item.idnumber ?? 0)
                                if cell0.initialImg.image != nil {
                                    SDImageCache.shared().store(cell0.initialImg.image!, forKey: item.initialURL ?? "", toDisk: true)
                                }
                                
                            }
                            
                        }else{
                            cell0.btn.isHidden = false
                            cell0.btn.setTitle("Initial", for: .normal)
                        }
                        
                        
                    }
                    
                    
                    
                }
                
            }
            cell0.delegate = self
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = walkItems![indexPath.row]
        let font = UIFont.preferredFont(forTextStyle: .body)
        var width: CGFloat
        var itemSize : CGSize
        var hp : CGFloat
        let photocnt = item.photos?.count ?? 0
        if UIDevice.current.orientation.isLandscape  {
            
            if photocnt == 0 {
                 hp = 0
            }else if photocnt < 7 {
                hp = 159 + 10
            }else{
                hp = 318 + 15
            }
            itemSize = CGSize(width: 159, height: 159)
            width = max(view.bounds.width, view.bounds.height) - 50
//            print("landscape")
        }else{
            if photocnt == 0 {
                hp = 0
            }else if photocnt < 5 {
                hp = 178 + 10
            }else if photocnt < 9 {
                hp = 356 + 15
            }else{
                hp = 534 + 20
            }
            itemSize = CGSize(width: 178, height: 178)
            width = min(view.bounds.width, view.bounds.height) - 50
//            print("potrait")
        }
        
        let h = max(item.comments?.heightWithConstrainedWidth(width: width, font: font) ?? 0, 40)
        item.clvSize =  itemSize
        item.txtHeghts = h+5
        return 65 + h + hp
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.introWalkItemsTableview.layoutSubviews()
    }
    
    func editCheckList(cell: IntroWalkTableViewCell) {
        if self.projectInfo?.finishyn == "0" {
            if let index = introWalkItemsTableview.indexPath(for: cell) {
                let item = walkItems![index.row]
                PopSignUtil.getInitialWithVC(self, withOk: { (init1, init2) in
                    cell.btn.isHidden = true
                    
                    let db = cl_introWalkLocal()
                    if item.idnumber != nil {
                        let urls = self.getIntroWalk2InitialURL(item.idnumber!)
                        db.updateIntroWalkInitailURl(idIntroWalk2local: item.idnumber!, url: urls, finished: false)
                        
                        SDImageCache.shared().store(init1, forKey: urls, toDisk: true)
                        item.initialURL = urls
                        cell.initialImg.sd_setImage(with: URL(string: urls), completed: { (_, _, _, _) -> Void in
                            //                        cell1.spinner.stopAnimating()
                        })
                    }
                    
                    PopSignUtil.closePop()
                }, withTitle: "Homeowner Initial", withLineArray: nil) {
                    PopSignUtil.closePop()
                }
            }
        }else{
            if let index = introWalkItemsTableview.indexPath(for: cell) {
                let item = walkItems![index.row]
                self.performSegue(withIdentifier: Constants.gotoNewCheckListSegue, sender: item)
            }
        }
        
    }
    
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.toolbar.isHidden = true
        self.getCheckListTableFromServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.toolbar.isHidden = false
    }
    @IBOutlet weak var btn: UIButton!{
        didSet{
            btn.setTitle("New Item", for: .normal)
            setBtnStyle(btn)
        }
    }
    
    @IBAction func gotoNewCheckList2(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.gotoNewCheckListSegue, sender: nil)
    }
    @IBAction func goToNewCheckList(_ sender: Any) {
        self.performSegue(withIdentifier: Constants.gotoNewCheckListSegue, sender: nil)
    }
    
    @IBAction func goback2(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var cancelbtn: UIButton!{
        didSet{
            setBtnStyle(cancelbtn)
        }
    }
    
    
    func addPhoto(_ cell: selectionImageCell) {
        self.performSegue(withIdentifier: Constants.gotoBigImageSegue, sender: cell)
    }
    
    func delPhoto(_ cell: selectionImageCell) {
        
    }
    func deletePhoto(_ tag: Int, cell: selectionImageCell) {
        
    }
    
    func  saveAndRewalk(){
       
        self.PopConfirmMsg(msg: "Are you sure you want to Finish & Rewalk") { (_) in
            let status = self.projectInfo?.introwalk_status ?? ""
            if status == "Draft" || status == "" {
                self.saveData(isClose: false)
            }else if status == "IntroWalk" || status.hasPrefix("Rewalk") {
                self.saveIntrowalk2Initial(isClose0: false)
            }
        }
        
        
        
       
    
    }
    func  saveAndClose(){
        self.PopConfirmMsg(msg: "Are you sure you want to Finish & Close") { (_) in
            self.popSignScreen()
        }
        
    }
    
    
    
    private func saveData(isClose: Bool) {
        self.isClose = isClose
        if let pro = self.projectInfo {
            if pro.idintrowalk1 == "" {
                pro.idintrowalk1 = "0"
            }
            let userinfo = UserDefaults.standard
            var param = [String: String]()
            param["email"] = (userinfo.value(forKey: CConstants.UserInfoEmail) as? String) ?? ""
            param["password"] = self.MD5(str: ((userinfo.value(forKey: CConstants.UserInfoPwd) as? String) ?? ""))
            param["username"] = (userinfo.value(forKey: CConstants.UserInfoName) as? String) ?? ""
            param["idcia"] = pro.idcia ?? ""
             param["idproject"] = pro.idproject ?? ""
            param["status"] = Constants.FinishCloseStatus
            
            if pro.idintrowalk1 == "" {
                pro.idintrowalk1 = "0"
            }
            param["idnumber"] = pro.idintrowalk1 ?? "0"
            if isClose {
                param["status"] = Constants.FinishCloseStatus
                param["statusid"] = Constants.FinishCloseStatusId
                param["finishyn"] = Constants.FinishCloseFinishYn
                
            }else{
                param["status"] = Constants.FinishRewalkStatus
                param["statusid"] = Constants.FinishRewalkStatusId
                param["finishyn"] = Constants.FinishRewalkFinishYn
            }
            self.nowStatus = param["status"] ?? ""
            if isClose{
                if self.pm1Sign.image != nil {
                    let tool = util()
//                    let scale = 160.0 / self.pm1Sign.image!.size.width
                    param["pm_sign"] = UIImagePNGRepresentation(tool.resizeImage(self.pm1Sign.image!, newWidth: 160)!)!.base64EncodedString()
                }
                if self.hoSign.image != nil {
                    let tool = util()
//                    let scale = 160.0 / self.hoSign.image!.size.width
                    param["ho_sign"] = UIImagePNGRepresentation(tool.resizeImage(self.hoSign.image!, newWidth: 160)!)!.base64EncodedString()
                }
            }else{
                param["pm_sign"] = " "
                param["ho_sign"] = " "
            }
            
//            ,"pm_sign":" "
//            ,"ho_sign":" "
            
//            print(param)
            
            self.btn.isHidden = true
            self.cancelbtn.isHidden = true
            
            var hud : MBProgressHUD?
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.label.text = CConstants.SavedMsg
            progresshud = hud
//            Alamofire.request(CConstants.ServerURL + CConstants.SaveIntroWalk1ServiceURL, parameters: param).responseJSON
            Alamofire.request(CConstants.ServerURL + CConstants.SaveIntroWalk1ServiceURL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ (response) -> Void in
                if response.result.isSuccess {
//                    hud?.hide(animated: true)
//                    hud.hide(a)
                    //                    {"idproject":"String","idcia":"String","idchecklist":"String","comment":"String","photocnt":"String"}
//                    print(response.result.value)
                    if let idintrowalk1 = response.result.value as? Int {
                        let clpro = cl_project()
                        pro.idintrowalk1 = "\(idintrowalk1)"
                        pro.introwalk_status = param["status"]
                        self.nowStatus = pro.introwalk_status ?? ""
                        pro.introwalk_statusid = param["statusid"]
                        pro.finishyn = param["finishyn"]
                        self.projectInfo?.introwalk_statusid = pro.introwalk_statusid
                        self.projectInfo?.introwalk_status = pro.introwalk_status
                        self.projectInfo?.finishyn = param["finishyn"]
                        clpro.saveIntroWalkForProject(pro)
                        self.saveIntroWalk2(idintrowalk1)
                    }
                }
            }
        }
    }
    
    var progresshud : MBProgressHUD?
    private func saveIntroWalk2(_ idintrowalk1: Int){
        //        print("\(idintrowalk1)")
        
        for item in self.walkItems! {
            if item.sidnumber == nil || item.sidnumber == "" {
                photoCnt += item.photos?.count ?? 0
                item.sidintrowalk1 = "\(idintrowalk1)"
                
                let userinfo = UserDefaults.standard
                var param = [String: String]()
                param["email"] = (userinfo.value(forKey: CConstants.UserInfoEmail) as? String) ?? ""
                param["password"] = self.MD5(str: ((userinfo.value(forKey: CConstants.UserInfoPwd) as? String) ?? ""))
                param["username"] = (userinfo.value(forKey: CConstants.UserInfoName) as? String) ?? ""
                param["idintrowalk1"] = "\(idintrowalk1)"
                param["comments"] = item.comments ?? ""
                param["initial_finishyn"] = "0"
                param["photoyn"] = ((item.photos!.count > 0 ? "1" : "0"))
                if item.sidnumber == "" {
                    item.sidnumber = "0"
                }
                param["idnumber"] = "\(item.sidnumber ?? "0")"
                param["initial"] = " "
                param["initial_status"] = " "
                
                Alamofire.request(CConstants.ServerURL + CConstants.SaveIntroWalk2ServiceURL, parameters: param).responseJSON{ (response) -> Void in
                    if response.result.isSuccess {
                        if let idintrowalk2 = response.result.value as? Int {
                            item.sidnumber = "\(idintrowalk2)"
                            let db = cl_introWalkLocal()
                            db.updateCheckList(idIntroWalk2local: "\(item.idnumber!)", sidintrowalk1: "\(idintrowalk1)", sidintrowalk2: "\(idintrowalk2)")
                            
                            var donext = true
                            for item in self.walkItems! {
                                if item.sidnumber == nil || item.sidnumber == "" {
                                    donext = false
                                }
                            }
                            if donext {
                                if self.photoCnt == 0 {
                                    if self.isClose {
                                        self.projectInfo?.finishyn = "1"
                                    }
                                self.finishedSubmit()
                                }else{
                                self.uploadPhotos()
                                }
                                
                            }else{
                                self.saveIntroWalk2(idintrowalk1)
                            }
                        }
                    }
                }
                break
            }
        }
    }
    private func getPhotoURL(_ idphoto: Int) -> String {
//        return ""
        return CConstants.ServerURL + CConstants.GetIntroWalkPhotoURL + "?idnumber=\(idphoto)"
    }
    var nowStatus = ""
    private func uploadPhotos(){
        for item in self.walkItems! {
            if item.sidnumber != nil && item.sidnumber != "" {
                let tool = util()
                //                        print(idintrowalk2)
                var i = 0
                for photo in item.photos!{
                    i = i + 1
                    let userinfo = UserDefaults.standard
                    let dimg = SDImageCache.shared().imageFromDiskCache(forKey: photo.photoUrl ?? "")
                    let imageData = UIImageJPEGRepresentation(tool.resizeImage(dimg!, newWidth: 600)!, 0.65)
                    let photoData = imageData!.base64EncodedString()
                    
                    var param2 = [String: String]()
                    param2["email"] = (userinfo.value(forKey: CConstants.UserInfoEmail) as? String) ?? ""
                    param2["password"] = self.MD5(str: ((userinfo.value(forKey: CConstants.UserInfoPwd) as? String) ?? ""))
                    param2["username"] = (userinfo.value(forKey: CConstants.UserInfoName) as? String) ?? ""
                    param2["idintrowalk2"] = item.sidnumber
                    param2["idnumber"] = "0"
                    //                            print(param2)
                    param2["photo"] = photoData
                    param2["sortno"] = "\(i)"
                    //                            print(param2)
                    
                    Alamofire.request(CConstants.ServerURL + CConstants.SaveIntroWalk2PhotoServiceURL, method: .post, parameters: param2, encoding: JSONEncoding.default).responseJSON{ (response) -> Void in
                        self.uploadedPhotoCnt += 1
                        
                        if response.result.isSuccess {
                            
                            if let idintrowalk2Photo = response.result.value as? Int {
                                SDImageCache.shared().removeImage(forKey: photo.photoUrl!, fromDisk: true)
                                
                                
                                photo.photoUrl = self.getPhotoURL(idintrowalk2Photo)
//                                SDImageCache.shared().storeImageData(toDisk: imageData, forKey: photo.photoUrl)
                                SDImageCache.shared().store(dimg, forKey: photo.photoUrl, toDisk: true)
                                let db = cl_introWalkPhotoLocal()
                                db.updateIntroWalkItemPhoto((photo.idnumber ?? 0), idIntroWalk2: item.idnumber ?? 0, url: (photo.photoUrl ?? ""))
                                
                                
                            }
                        }else{
                            //                                    print(response.result.value)
                        }
                        if self.uploadedPhotoCnt == self.photoCnt {
                           self.finishedSubmit()
                            if self.isClose {
                                self.projectInfo?.finishyn = "1"
                            }
//                            self.progresshud?.hide(animated: true)
                            
                            
                        }
                        
                    }
                }
            }
        }
        
        
    }
    
    private func finishedSubmit(){
        self.progresshud?.mode = .customView
        let image = UIImage(named: CConstants.SuccessImageNm)
        self.progresshud?.customView = UIImageView(image: image)
        self.progresshud?.label.text = "Saved Successfully."
        //                            self.progresshud?.hide(animated: true, afterDelay: 1)
        //"Saved To Device, the Data will synchronize \nto BA Server when network connected."
        if self.isClose{
            self.btn.isHidden = true
            self.cancelbtn.isHidden = true
            self.sendItem.title = "Finished"
            self.projectInfo?.finishyn = "1"
            self.sendItem.image = nil
            self.introWalkItemsTableview.reloadData()
        }else{
            self.btn.isHidden = true
            self.cancelbtn.isHidden = true
            self.introWalkItemsTableview.reloadData()
        }
        self.projectInfo?.introwalk_status = self.nowStatus
//        for i in 0...(self.projectlist!.count - 1){
//            let it = self.projectlist![i]
//            if it.idcia == self.projectInfo!.idcia! && it.idproject == self.projectInfo!.idproject! {
//                self.projectlist![i] = self.projectInfo!
//                break
//            }
//        }
        let pro = cl_project()
        pro.saveIntroWalkForProject(self.projectInfo!)
        self.perform(#selector(IntroWalkListViewController.dismissProgress as (IntroWalkListViewController) -> () -> ()), with: nil, afterDelay: 1)
    }
    
    func dismissProgress() {
        self.progresshud?.hide(animated: true)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
      var uploadedPhotoCnt = 0
     var photoCnt = 0
    var isClose = false
    
    var imageHomeowner : UIImage? {
        didSet{
           self.hoSign.image = imageHomeowner
            let hourl = self.getIntroWalk1HOInitialURL(self.projectInfo?.idcia ?? "", idproject: self.projectInfo?.idproject ?? "")
            SDImageCache.shared().store(imageHomeowner, forKey: hourl, toDisk: true)
        }
    }
    
    var imagePM: UIImage? {
        didSet{
            self.pm1Sign.image = imagePM
            let pmurl = self.getIntroWalk1PMInitialURL(self.projectInfo?.idcia ?? "", idproject: self.projectInfo?.idproject ?? "")
            SDImageCache.shared().store(imagePM, forKey: pmurl, toDisk: true)
        }
    }
     private func popSignScreen(){
        PopSignUtil.getSignWithVC(self, withOk: { (imgHo, imgpm) in
            PopSignUtil.closePop()
            self.imageHomeowner = imgHo
            self.imagePM = imgpm
            
            let status = self.projectInfo?.introwalk_status ?? ""
            if status == "Draft" || status == "" {
                self.saveData(isClose: true)
            }else if status == "IntroWalk" || status.hasPrefix("Rewalk") {
                self.saveIntrowalk2Initial(isClose0: true)
                
            }
            
        }) {
            PopSignUtil.closePop()
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
            
        case Constants.sendOperationSegue:
            if self.projectInfo?.finishyn == "1" {
                return false
            }else{
                return true
            }
        default:
            break
        }
        return true
    }
    
    private func getIntroWalk(){
        if let pro = self.projectInfo {
            if pro.idintrowalk1 != "" && pro.idintrowalk1 != nil  {
                self.btn.isHidden = true
                self.cancelbtn.isHidden = true
                let userinfo = UserDefaults.standard
                var param = [String: String]()
                param["email"] = (userinfo.value(forKey: CConstants.UserInfoEmail) as? String) ?? ""
                param["password"] = self.MD5(str: ((userinfo.value(forKey: CConstants.UserInfoPwd) as? String) ?? ""))
                param["idintrowalk1"] = pro.idintrowalk1!
                
                self.progresshud = MBProgressHUD.showAdded(to: self.view, animated: true)
                progresshud?.label.text = CConstants.RequestMsg
                Alamofire.request(CConstants.ServerURL + CConstants.GetIntroWalk1ServiceURL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ (response) -> Void in
                    self.progresshud?.hide(animated: true)
                    if response.result.isSuccess {
//                        print(response.result.value)
                        if let rtn = response.result.value as? [String: AnyObject] {
                            self.projectInfo?.introwalk_status = rtn["status"] as? String
                            self.projectInfo?.introwalk_statusid = rtn["statusid"] as? String
                            self.projectInfo?.finishyn = rtn["finishyn"] as? String
                            if (rtn["finishyn"]! as! String) == "1"{
                                self.buyerNm.numberOfLines = 0
                                if (rtn["rewalkdate"] as! String).contains("1980") {
                                    self.SetHomeOwener(sd: rtn["walkdate"] as? String ?? "")
                                }else {
                                    self.SetHomeOwener(sd: rtn["rewalkdate"] as? String ?? "")
                                }
                                
                                self.bottomSpace.constant = -40
                                self.view.updateConstraintsIfNeeded()
                                
                                self.sendItem.title = "Finished"
                                self.sendItem.image = nil
                                self.btn.isHidden = true
                                self.cancelbtn.isHidden = true
                                self.introWalkItemsTableview.reloadData()
                                
                                let imgPm = rtn["pm_sign"] as! String
                                if imgPm.characters.count > 0 {
                                    let imageData = NSData(base64Encoded: imgPm, options: .ignoreUnknownCharacters)
                                    self.imagePM = UIImage(data: imageData! as Data)
                                }
                                let imgHo = rtn["ho_sign"] as! String
                                if imgHo.characters.count > 0 {
                                    let imageData = NSData(base64Encoded: imgHo, options: .ignoreUnknownCharacters)
                                    self.imageHomeowner = UIImage(data: imageData! as Data)
                                }
                            }else{
                                var walkdata = rtn["rewalkdate"] as? String ?? ""
                                if walkdata.hasPrefix("1/1/1980") {
                                    walkdata = rtn["walkdate"] as? String ?? ""
                                }
                                self.SetHomeOwener(sd: "")
//                                self.buyerNm.text = self.buyerNm.text! + "\nLast Walk @ " + walkdata
//                                self.btn.isHidden = false
//                                self.cancelbtn.isHidden = false
                            }
                            let items = rtn["items"] as! [[String: AnyObject]]
                            let db = cl_introWalkLocal()
                            
                            if items.count > 0 {
                                var walkItems2 = [cl_ObjIntroWalk2]()
                                for item in items {
                                    let walk2 = cl_ObjIntroWalk2()
                                    walk2.idcia = pro.idcia
                                    walk2.idproject = pro.idproject
                                    walk2.sidintrowalk1 = rtn["idnumber"] as? String
                                    walk2.idintrowalk1 = Int32(walk2.sidintrowalk1 ?? "0")
                                    walk2.comments = item["comments"] as? String
                                    walk2.photos = [cl_ObjIntroWalk2Photo]()
                                    walk2.sidnumber = item["idnumber"] as? String
                                    let local = db.getIntroWalkItems(pro, sidnumber: walk2.sidnumber ?? "")
                                    if local.idnumber != nil{
                                        walk2.idnumber = local.idnumber
                                        walk2.initialURL = local.initialURL
                                    }else{
                                        walk2.idnumber = Int32(walk2.sidnumber ?? "0")
                                    }
                                   
                                    walk2.initial_finishyn =  item["initial_finishyn"] as? String ?? ""
                                    walk2.initial = item["initial"] as? String ?? ""
                                    for itemphoto in (item["photos"] as! [[String: String]]){
                                        let photo = cl_ObjIntroWalk2Photo()
                                        photo.idintrowalk2 = walk2.idnumber
                                        photo.idnumber = Int32(itemphoto["idnumber"] ?? "0")
                                        photo.photoUrl = "https://contractssl.buildersaccess.com/bachecklist_getIntroWalkPhoto?idnumber=" + (itemphoto["idnumber"] ?? "0")
                                        walk2.photos?.append(photo)
                                    }
                                    walkItems2.append(walk2)
                                }
                                
                                if (self.walkItems == nil) || (self.walkItems?.count ?? 0) == 0 {
                                    self.walkItems = walkItems2
                                    
                                    let db = cl_introWalkLocal()
                                    let dbphoto = cl_introWalkPhotoLocal()
                                    let dbProject = cl_project()
                                    dbProject.savedProjectsToDB([self.projectInfo!])
                                    var i : Int32 = 0
                                    for item in self.walkItems! {
                                        i = i + 1
                                        let id2 = db.savedIntroWalkItemToDB(self.projectInfo!, comment: item.comments ?? "", xno: i)
                                        if item.initial != "" {
                                            item.initialURL = self.getIntroWalk2InitialURL(id2)
                                            let imageData = NSData(base64Encoded: item.initial!, options: .ignoreUnknownCharacters)
                                            SDImageCache.shared().store(UIImage(data: imageData! as Data), forKey: item.initialURL!, toDisk: true)
                                            db.updateIntroWalkInitailURl(idIntroWalk2local: id2, url: item.initialURL!, finished: true)
                                        }
                                        if item.photos != nil && (item.photos?.count ?? 0) > 0 {
                                            for photo in item.photos! {
                                                dbphoto.savedIntroWalkItemPhotoToDB(id2, url: photo.photoUrl ?? "")
                                            }
                                            
                                        }
                                    }
                                }
                                
                            }
                        }
                    }else{
                        //                                    print(response.result.value)
                    }
                }
            }
        }
    }
    
    private func getIntroWalk1PMInitialURL(_ idcia: String, idproject: String) -> String {
        return CConstants.ServerURL + "PMIntroWalk2initial/idcia=\(idcia)&idproject=\(idproject)"
    }
    private func getIntroWalk1HOInitialURL(_ idcia: String, idproject: String) -> String {
        return CConstants.ServerURL + "HOIntroWalk2initial/idcia=\(idcia)&idproject=\(idproject)"
    }
    private func getIntroWalk2InitialURL(_ idIntroWalk2: Int32) -> String {
        return CConstants.ServerURL + "IntroWalk2initial/\(idIntroWalk2)"
    }
    
    private func saveIntrowalk2Initial(isClose0: Bool) {
        var hud : MBProgressHUD?
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.label.text = CConstants.SavedMsg
        progresshud = hud
        uploadedPhotoCnt = 0
        var total = 1
        for i in 0...(self.walkItems?.count ?? 1)-1 {
            let index = IndexPath(row: i, section: 0)
            if let cell = self.introWalkItemsTableview.cellForRow(at: index) as? IntroWalkTableViewCell {
                if let _ = cell.initialImg.image {
                    total += 1
                }
            }
        
        }
        for i in 0...(self.walkItems?.count ?? 1)-1 {
            let item = self.walkItems![i]
            let index = IndexPath(row: i, section: 0)
            if let cell = self.introWalkItemsTableview.cellForRow(at: index) as? IntroWalkTableViewCell {
                if let initial = cell.initialImg.image {
                    let userinfo = UserDefaults.standard
                    var param = [String: String]()
                    param["email"] = (userinfo.value(forKey: CConstants.UserInfoEmail) as? String) ?? ""
                    param["password"] = self.MD5(str: ((userinfo.value(forKey: CConstants.UserInfoPwd) as? String) ?? ""))
                    param["username"] = (userinfo.value(forKey: CConstants.UserInfoName) as? String) ?? ""
                    param["idintrowalk1"] = self.projectInfo?.idintrowalk1 ?? ""
                    
                    param["initial_finishyn"] = "1"
                    param["comments"] = item.comments ?? ""
                    param["photoyn"] = ((item.photos!.count > 0 ? "1" : "0"))
                    
                    param["idnumber"] = "\(item.sidnumber ?? "0")"
                    let tool = util()
//                    let scale = 160.0 / initial.size.width
                    param["initial"] = UIImagePNGRepresentation(tool.resizeImage(initial, newWidth: 160)!)!.base64EncodedString()
                    
                    
                    
                    param["initial_status"] = self.projectInfo?.introwalk_status ?? ""
//                    print(param)
                    Alamofire.request(CConstants.ServerURL + CConstants.SaveIntroWalk2ServiceURL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ (response) -> Void in
//                        print(response.result.value)
                        if response.result.isSuccess {
                            self.uploadedPhotoCnt += 1
                            let db = cl_introWalkLocal()
                            db.updateIntroWalkInitailFinish(idIntroWalk2local: (item.idnumber ?? 0))
                            if self.uploadedPhotoCnt == total {
//                                self.progresshud?.hide(animated: true)
                                self.finishedSubmit()
                            }
                            
                        }
                    }
                
                }
                
            }
        }
        
        if let pro = self.projectInfo {
            let userinfo = UserDefaults.standard
            var param = [String: String]()
            param["email"] = (userinfo.value(forKey: CConstants.UserInfoEmail) as? String) ?? ""
            param["password"] = self.MD5(str: ((userinfo.value(forKey: CConstants.UserInfoPwd) as? String) ?? ""))
            param["username"] = (userinfo.value(forKey: CConstants.UserInfoName) as? String) ?? ""
            param["idcia"] = pro.idcia ?? ""
            param["idproject"] = pro.idproject ?? ""
            let id = Int(pro.introwalk_statusid ?? "0") ?? 0
            if id < 2 {
                param["status"] = "Rewalk"
            }else{
                param["status"] = "Rewalk\(id)"
            }
            self.nowStatus = pro.introwalk_status ?? ""
            if isClose0 {
                param["statusid"] = "\(id)"
                param["finishyn"] = "1"
                if self.pm1Sign.image != nil {
                    let tool = util()
//                    let scale = 160.0 / self.pm1Sign.image!.size.width
                    param["pm_sign"] = UIImagePNGRepresentation(tool.resizeImage(self.pm1Sign.image!, newWidth: 160)!)!.base64EncodedString()
                }
                if self.hoSign.image != nil {
                    let tool = util()
//                    let scale = 160.0 / self.hoSign.image!.size.width
                    param["ho_sign"] = UIImagePNGRepresentation(tool.resizeImage(self.hoSign.image!, newWidth: 160)!)!.base64EncodedString()
                }
            }else{
                param["statusid"] = "\(id + 1)"
                param["finishyn"] = "0"
                param["pm_sign"] = ""
                param["ho_sign"] = ""
            }
            
            param["idnumber"] = self.projectInfo?.idintrowalk1 ?? ""
            
            
//            print(param)
            
            self.btn.isHidden = true
            self.cancelbtn.isHidden = true
            
           
            //            Alamofire.request(CConstants.ServerURL + CConstants.SaveIntroWalk1ServiceURL, parameters: param).responseJSON
            Alamofire.request(CConstants.ServerURL + CConstants.SaveIntroWalk1ServiceURL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ (response) -> Void in
//               print(response.result.value)
                if response.result.isSuccess {
                    //                    hud?.hide(animated: true)
                    //                    hud.hide(a)
                    //                    {"idproject":"String","idcia":"String","idchecklist":"String","comment":"String","photocnt":"String"}
                    //                    print(response.result.value)
                    if let idintrowalk1 = response.result.value as? Int {
                        let clpro = cl_project()
                        pro.idintrowalk1 = "\(idintrowalk1)"
                        pro.introwalk_status = param["status"]
                        self.nowStatus = pro.introwalk_status ?? ""
                        pro.introwalk_statusid = param["statusid"]
                        pro.finishyn = param["finishyn"]
                        self.projectInfo?.introwalk_statusid = pro.introwalk_statusid
                        self.projectInfo?.introwalk_status = pro.introwalk_status
                        self.projectInfo?.finishyn = param["finishyn"]
                    
                        clpro.saveIntroWalkForProject(pro)
                        self.uploadedPhotoCnt += 1
                        if self.uploadedPhotoCnt == total {
                            self.progresshud?.hide(animated: true)
                        }
                    
                        
                        if isClose0 {
                            self.sendItem.title = "Finished"
                            self.sendItem.image = nil
                            self.projectInfo?.finishyn = "1"
                        }
                        
                        self.finishedSubmit()
//                        self.saveIntroWalk2(idintrowalk1)
                    }
                }
            }
        }
        
    }
    
   
    
    
}
