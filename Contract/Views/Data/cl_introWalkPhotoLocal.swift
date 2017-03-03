//
//  cl_Frequency.swift
//  BA-Clock
//
//  Created by April on 1/25/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class cl_introWalkPhotoLocal : NSObject{
    let DTName = "IntroWalk2photoLocal"
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentStoreCoordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    func savedIntroWalkItemPhotoToDB(_ idIntroWalk2: Int32, url: String){
        
        do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            let predicate = NSPredicate(format: "idintrowalk2 = \(idIntroWalk2)" )
            fetchRequest1.predicate = predicate
            fetchRequest1.fetchLimit = 1
            fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "idnumber", ascending: false)]
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
            var idnumber : Int32 = 0
            
            for comment in commentIDs {
                idnumber = (comment.value(forKey: "idnumber") as? Int32) ?? 0
            }
            
            idnumber += 1
            
            let entity =  NSEntityDescription.entity(forEntityName: DTName,
                                                                in: managedObjectContext)
            
            let scheduledDayItem = NSManagedObject(entity: entity!,
                                                   insertInto: managedObjectContext)
            
            scheduledDayItem.setValue(idIntroWalk2, forKey: "idintrowalk2")
            scheduledDayItem.setValue(idnumber, forKey: "idnumber")
            scheduledDayItem.setValue(url, forKey: "photoUrl")
            scheduledDayItem.setValue(Date(), forKey: "creadate")
            
            let userinfo = UserDefaults()
            scheduledDayItem.setValue(userinfo.value(forKey: CConstants.UserInfoName) ?? "", forKey: "creaby")
            
            do {
                try managedObjectContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        } catch _ as NSError {
            
        }
    }
    
    func updateIntroWalkItemPhoto(_ idIntroWalk2Photo: Int32, idIntroWalk2: Int32, url: String){
        
        do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            let predicate = NSPredicate(format: "idintrowalk2 = \(idIntroWalk2) and idnumber = \(idIntroWalk2Photo)" )
            fetchRequest1.predicate = predicate
            fetchRequest1.fetchLimit = 1
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
            for comment in commentIDs {
                comment.setValue(url, forKey: "photoUrl")
            }
            try managedObjectContext.save()
        } catch _ as NSError {
            
        }
    }
    
    
    func getIntroWalkItemPhotos(_ idIntroWalk2: Int32) -> [cl_ObjIntroWalk2Photo]{
        
        var rtns = [cl_ObjIntroWalk2Photo]()
        
        //        let fetchRequest = NSFetchRequest(entityName: "CheckList")
        //        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            
            //            idintrowalk2
            //            idnumber
            //            modiby
            //            modidate
            //            photoUrl
            
            
            let predicate = NSPredicate(format: "idintrowalk2 = \(idIntroWalk2)" )
            fetchRequest1.predicate = predicate
            fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "idnumber", ascending: true)]
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
//            var idnumber : Int32 = 0
            
            for comment in commentIDs {
                let item = cl_ObjIntroWalk2Photo()
//                var idnumber: Int32?
//                var idintrowalk2: Int32?
//                var photoUrl: String?
                item.idnumber = (comment.value(forKey: "idnumber") as? Int32) ?? 0
                item.idintrowalk2 = (comment.value(forKey: "idintrowalk2") as? Int32) ?? 0
                item.photoUrl = (comment.value(forKey: "photoUrl") as? String) ?? ""
                
                rtns.append(item)
//                idnumber = (comment.value(forKey: "idnumber") as? Int32) ?? 0
            }
            
            
            
        } catch _ as NSError {
            //            print0000("\(error)")
            // TODO: handle the error
        }
        
        return rtns
        
    }
    
    
    func deleteCheckListPhotoFromServer22(_ idintrowalk2: Int32){
        
        do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            
            //Fields
            //            creadate
            //            idchecklist
            //            idcia
            //            idproject
            //            url
            //            xid
            
            
            let predicate = NSPredicate(format: "idintrowalk2 = \(idintrowalk2)")
            fetchRequest1.predicate = predicate
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
            for comment in commentIDs {
                managedObjectContext.delete(comment)
            }
            
            
            try managedObjectContext.save()
           
            
        } catch _ as NSError {
           
            //            print0000("\(error)")
            // TODO: handle the error
        }
        
        
        
    }
    
    
    func deleteCheckListPhotoFromServer(_ project : projectItem, idcheck: String, idx: String) -> String{
        
        //        let fetchRequest = NSFetchRequest(entityName: "CheckList")
        //        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        var rtn = ""
        do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            
            //Fields
            //            creadate
            //            idchecklist
            //            idcia
            //            idproject
            //            url
            //            xid
            
            
            let predicate = NSPredicate(format: "idcia = %@ and idproject = %@ and idchecklist = %@ and xid = %@", project.idcia ?? "", project.idproject ?? "", idcheck, idx)
            fetchRequest1.predicate = predicate
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
            
            if commentIDs.count > 0 {
                rtn = commentIDs.first!.value(forKey: "url") as? String ?? ""
            }
            for comment in commentIDs {
                managedObjectContext.delete(comment)
            }
            
            
             try managedObjectContext.save()
            
            return rtn
            
        } catch _ as NSError {
            return rtn
            //            print0000("\(error)")
            // TODO: handle the error
        }
        
        
        
    }
    
    //    func savedCheckListPhotoToDB(project : projectItem, idchecklist: String, idx: Int){
    //
    //        do {
    //            let fetchRequest1 = NSFetchRequest(entityName: DTName)
    //            let predicate = NSPredicate(format: "idcia = %@ and idproject = %@ and idchecklist = %@"
    //                , project.idcia ?? ""
    //                , project.idproject ?? ""
    //                , idchecklist)
    //            fetchRequest1.predicate = predicate
    //            let commentIDs =  try managedObjectContext.executeFetchRequest(fetchRequest1) as! [NSManagedObject]
    //            if commentIDs.count > 0 {
    //                if let scheduledDayItem = commentIDs.first {
    //                    scheduledDayItem.setValue(NSDate(), forKey: "lastupdate")
    //                    scheduledDayItem.setValue(true, forKey: "p" + String(idx))
    //                }
    //            }
    //
    //
    //            do {
    //                try managedObjectContext.save()
    //
    //            } catch let error as NSError  {
    //                print("Could not save \(error), \(error.userInfo)")
    //            }
    //
    //        } catch let error as NSError {
    //            //            print0000("\(error)")
    //            // TODO: handle the error
    //        }
    //
    //
    //
    //    }
    
    
    //    func getCheckList(project : projectItem) -> (String, String){
    //
    //
    //            let fetchRequest1 = NSFetchRequest(entityName: DTName)
    //            let predicate = NSPredicate(format: "idcia = %@ and idproject = %@", project.idcia ?? "", project.idproject ?? "")
    //            fetchRequest1.predicate = predicate
    //         do {
    //            let commentIDs =  try managedObjectContext.executeFetchRequest(fetchRequest1) as! [NSManagedObject]
    //            if let first = commentIDs.last {
    //                return (first.valueForKey("comment") as? String ?? "", first.valueForKey("idchecklistinserver") as? String ?? "0")
    //            }
    //
    //         } catch let error as NSError  {
    //            print("Could not save \(error), \(error.userInfo)")
    //        }
    //
    //        return ("", "0")
    //
    //
    //    }
    
    
    func getCheckListPhotoNotSynced(_ project : projectItem, idcheck: String) -> [NSManagedObject]?{
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        let predicate = NSPredicate(format: "idcia = %@ and idproject = %@ and idchecklist = %@", project.idcia ?? "", project.idproject ?? "", idcheck)
        fetchRequest1.predicate = predicate
       do {
        let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
        
            return commentIDs
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return nil
        
        
    }
    
//    func getFirstCheckListPhotoNotSynced() -> [NSManagedObject]?{
//        var idchecks = [String]()
//        
//        if let firstItems = cl_checklistLocal().getCheckListNotSynced0(){
//            
//            for first in firstItems {
//                let xidcia = first.idcia!
//                let xidproject = first.idproject!
//                let xidchecklist = first.idchecklist!
//                let s = "idcia = " + xidcia + " and idproject = " + xidproject + " and idchecklist = " + xidchecklist
//                idchecks.append(s)
//            }
//        }
//        
//        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
//        
//        do {
//            var oldData = [NSManagedObject]()
//            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
//            if idchecks.count == 0 {
//                return commentIDs
//            }else{
//                for photo in commentIDs {
//                    let xidcia = (photo.value(forKey: "idcia") as? String ?? "")
//                    let xidproject = (photo.value(forKey: "idproject") as? String ?? "")
//                    let xidchecklist = (photo.value(forKey: "idchecklist") as? String ?? "")
//                    let str = "idcia = " + xidcia + " and idproject = " + xidproject + " and idchecklist = " + xidchecklist
//                    
//                    if !idchecks.contains(str) {
//                        oldData.append(photo)
//                    }
//                }
//                
//                return oldData
//            }
//            
//            
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
//        
//        return nil
//        
//        
//    }
}
