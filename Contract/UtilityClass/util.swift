//
//  util.swift
//  Contract
//
//  Created by April on 1/23/17.
//  Copyright © 2017 HapApp. All rights reserved.
//

import Foundation
import Alamofire
import SDWebImage
import CoreData

class util {
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func getImgFromServer(_ idIntroWalk2: Int32, xno: Int32, idcia: String, idproject: String, islocal: Bool) -> String {
        return "https://contractssl.buildersaccess.com/bachecklist_getChecklistPhoto.json?email=roberto@buildersaccess.com&password=11111&idIntroWalk2=\(idIntroWalk2)&xid=\(xno)" + "&isthumbnail=0&idcia=" + idcia + "&idproject=" + idproject + "&islocal=" + (islocal ? "1" : "0")
    }
    
    
    func syncDataToServer() {
        return
//        let userInfo = UserDefaults.standard
//        let email = userInfo.object(forKey: CConstants.UserInfoEmail) as? String ?? ""
//        let pwd = userInfo.object(forKey: CConstants.UserInfoPwd) as? String ?? ""
//        let username = userInfo.object(forKey: CConstants.UserInfoName) as? String ?? ""
//        
//        
//        
//        let checkDb = cl_checklistLocal()
//        let checkPhotoDB = cl_checklistphotolocal()
//        
//        if let items = checkPhotoDB.getFirstCheckListPhotoNotSynced(){
//            for photoitem in items {
//                self.uploadPhotoToServer(photoitem,
//                                         email: email,
//                                         pwd: pwd,
//                                         username: username)
//            }
//        }
//        
////        getFirstCheckListPhotoNotSynced
//        if let rtn = checkDb.getCheckListNotSynced0(){
//            
//            for item in rtn{
//               // print(item.comment!)
//                    var param = [String : String]()
//                    param["email"] = email
//                    param["password"] = pwd
//                    param["idnumber"] = item.idchecklist!
//                if param["idnumber"] == "" {
//                    param["idnumber"] = "0"
//                }
//                    let url1 = getImgFromServer(param["idnumber"]!, idx: "1", idcia: item.idcia!, idproject: item.idproject!)
//                    if SDImageCache.shared().diskImageExists(withKey: url1) {
//                        param["hasphoto"] = "1"
//                    }else{
//                        param["hasphoto"] = "0"
//                    }
//                    
//                    param["idcia"] = item.idcia!
//                    param["idproject"] = item.idproject!
//                    param["comment"] = item.comment!
//                    param["username"] = username
//                    
//                Alamofire.request( CConstants.ServerURL + CConstants.SaveCommentServiceURL, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON{ (response) -> Void in
//                        if response.result.isSuccess {
//                            
//                            if let str = response.result.value as? NSNumber {
//                                if str.intValue > 0 {
//                                    var oldIdchecklist = "0"
//                                    do {
//                                        if let datastring =   try JSONSerialization.jsonObject(with: response.request!.httpBody!, options: []) as? [String:String]{
//                                            oldIdchecklist = datastring["idnumber"] ?? "0"
//                                            
//                                        }
//                                    } catch let error as NSError {
//                                        print(error)
//                                    }
//                                    
//                                    
//                                    
//                                    
//                                    let idchecklist = String(describing: str)
//                                    let projectInfo = projectItem(dicInfo: nil)
//                                    projectInfo.idproject = param["idproject"]
//                                    projectInfo.idcia =  param["idcia"]
//                                    
//                                   let comment = checkDb.deleteCheckListFromLocal(projectInfo, idcheck: oldIdchecklist, newidcheck: idchecklist)
//                                    
////                                    if let addd = checkDb.getCheckListNotSynced(){
////                                        for a in addd {
////                                            print(a.valueForKey("comment"))
////                                        }
////                                    }
//                                    
//                                    let checkServer = cl_checklistDB()
//                                    checkServer.savedCheckListToDB(projectInfo, comment: comment, idcheck: idchecklist)
//                                    //checkDb.savedCheckListToDB(projectInfo, comment: comment, idcheck: idchecklist)
//                                    
//                                    if let items = checkPhotoDB.getCheckListPhotoNotSynced(projectInfo, idcheck: idchecklist){
//                                        for photoitem in items {
//                                            self.uploadPhotoToServer(photoitem,
//                                                email: email,
//                                                pwd: pwd,
//                                                username: username)
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }//end save comment
//                
//            }
//        }
    }
    
    func uploadPhotoToServer(_ photoitem: NSManagedObject,
                             email: String,
                             pwd: String,
                             username: String) {
//        let checkPhotoDB = cl_checklistphotolocal()
//        let checkPhotoServer = cl_checklistphotoDB()
//        let idx = photoitem.value(forKey: "xid") as? String ?? "0"
//        let url1 = photoitem.value(forKey: "url") as? String ?? ""
//        let idchecklist = photoitem.value(forKey: "idchecklist") as? String ?? ""
//        if let img = SDImageCache.shared().imageFromDiskCache(forKey: url1){
//            var photoparam = [String : String]()
//            
//            photoparam["email"] = email
//            photoparam["password"] = pwd
//            photoparam["idchecklist"] = idchecklist
//            photoparam["idx"] = idx
//            photoparam["username"] = username
//            let imageData = UIImageJPEGRepresentation(self.resizeImage(img, newWidth: 600)!, 0.5)
//            let photoData = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
//             print(photoparam)
//            photoparam["photo"] = photoData
//            photoparam["xthumbnail"] = ""
//           
//            Alamofire.request( CConstants.ServerURL + CConstants.SaveChecklistPhotoServiceURL, method: .post, parameters: photoparam, encoding: JSONEncoding.default).responseJSON{ (response) -> Void in
//                
//                if response.result.isSuccess {
//                    
//                    if let _ = response.result.value as? NSNumber {
////                        print("=========%@", rtn)
//                        //                                                            newIdx = String(rtn)
//                    }
//                    do {
//                        if let datastring =   try JSONSerialization.jsonObject(with: response.request!.httpBody!, options: []) as? [String:String]{
//                            
//                            if let b = datastring["idx"]{
//                                let newIdx = b
//                                let projectInfo = projectItem(dicInfo: nil)
//                                projectInfo.idcia = photoitem.value(forKey: "idcia") as? String ?? ""
//                                projectInfo.idproject = photoitem.value(forKey: "idproject") as? String ?? ""
//                                let oldurl = checkPhotoDB.deleteCheckListPhotoFromServer(projectInfo, idcheck: idchecklist, idx: b)
//                                
//                                let newurl = self.getImgFromServer(idchecklist, idx: newIdx, idcia: projectInfo.idcia!, idproject: projectInfo.idproject!)
//                                checkPhotoServer.savedCheckListPhotoToDB(projectInfo, idcheck: idchecklist, idx: newIdx, url: newurl)
//                                
//                                let oldImage = SDImageCache.shared().imageFromDiskCache(forKey: oldurl)
//                                SDImageCache.shared().removeImage(forKey: oldurl, fromDisk: true)
//                                SDImageCache.shared().store(oldImage, forKey: newurl, toDisk: true)
//                                
//                            }
//                        }
//                    } catch let error as NSError {
//                        print(error)
//                    }
//                    
//                }
//            }// end upload photo
//        }
    }
}
