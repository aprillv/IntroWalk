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

class cl_introWalkLocal : NSObject{
    let DTName = "IntroWalk2Local"
    let DTPhotoName = "IntroWalk2photoLocal"
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentStoreCoordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    
    func savedIntroWalkItemToDB(_ project : projectItem, comment: String, xno: Int32) -> Int32{
//        comments
//        creaby
//        creadate
//        idcia
//        idintrowalk1
//        idnumber
//        idproject
//        initial_finishyn
//        initial_status
//        initialUrl
//        modiby
//        modidate
//        photoyn
//        sidintrowalk1
//        sidnumber
//        let fetchRequest = NSFetchRequest(entityName: "CheckList")
//        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        var idnum : Int32 = 0
        do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            
            
            let predicate = NSPredicate(format: "idcia = %@ and idproject = %@ and xno = \(xno)", project.idcia ?? "", project.idproject ?? "")
            fetchRequest1.predicate = predicate
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
            for comment in commentIDs {
                
                let idintrowalk2 = (comment.value(forKey: "idnumber") as? Int32) ?? 0
                managedObjectContext.delete(comment)
                
                let fetchRequest3 = NSFetchRequest<NSFetchRequestResult>(entityName: DTPhotoName)
                let predicate = NSPredicate(format: "idintrowalk2 = \(idintrowalk2)")
                fetchRequest3.predicate = predicate
                let commentIDs2 =  try managedObjectContext.fetch(fetchRequest3) as! [NSManagedObject]
                for comment2 in commentIDs2 {
                    managedObjectContext.delete(comment2)
                }
                
            }
            
            let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            fetchRequest2.fetchLimit = 1
            fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "idnumber", ascending: false)]
            let commentIDs2 =  try managedObjectContext.fetch(fetchRequest2) as! [NSManagedObject]
            
            
            for comment in commentIDs2 {
                idnum = (comment.value(forKey: "idnumber") as? Int32) ?? 0
            }
            idnum = idnum + 1
            
            
            let entity =  NSEntityDescription.entity(forEntityName: DTName,
                                                            in:managedObjectContext)
            
            let scheduledDayItem = NSManagedObject(entity: entity!,
                                                   insertInto: managedObjectContext)
            
            scheduledDayItem.setValue(project.idcia!, forKey: "idcia")
            scheduledDayItem.setValue(project.idproject!, forKey: "idproject")
            scheduledDayItem.setValue(comment, forKey: "comments")
            scheduledDayItem.setValue(xno, forKey: "xno")
            scheduledDayItem.setValue(idnum, forKey: "idnumber")
            scheduledDayItem.setValue(Date(), forKey: "creadate")
            let userinfo = UserDefaults()
            scheduledDayItem.setValue(userinfo.value(forKey: CConstants.UserInfoName) ?? "", forKey: "creaby")
            
            do {
                try managedObjectContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            
        } catch _ as NSError {
            //            print0000("\(error)")
            // TODO: handle the error
        }
        
        return idnum
        
        
    }
    
    func updateCheckList(idIntroWalk2local idIntroWalk2: String, sidintrowalk1: String, sidintrowalk2: String){
       do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            
            let predicate = NSPredicate(format: "idnumber = %@", idIntroWalk2)
            fetchRequest1.predicate = predicate
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
            if let x = commentIDs.first{
                x.setValue(sidintrowalk1, forKey: "sidintrowalk1")
                x.setValue(sidintrowalk2, forKey: "sidnumber")
            }
            
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func updateIntroWalkInitailURl(idIntroWalk2local idIntroWalk2: Int32, url: String, finished: Bool){
        do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            
            let predicate = NSPredicate(format: "idnumber = \(idIntroWalk2)" )
            fetchRequest1.predicate = predicate
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
            if let x = commentIDs.first{
                x.setValue(url, forKey: "initialUrl")
                if finished {
                x.setValue("1", forKey: "initial_finishyn")
                }
                
            }
            
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("\(error)")
        }
    }
    
    func updateIntroWalkInitailFinish(idIntroWalk2local idIntroWalk2: Int32){
        do {
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            
            let predicate = NSPredicate(format: "idnumber = \(idIntroWalk2)" )
            fetchRequest1.predicate = predicate
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            
            if let x = commentIDs.first{
                x.setValue("1", forKey: "initial_finishyn")
                
            }
            
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("\(error)")
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
    
    
    func getCheckList(_ project : projectItem) -> (String, String){
        
        
            let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
            let predicate = NSPredicate(format: "idcia = %@ and idproject = %@", project.idcia ?? "", project.idproject ?? "")
            fetchRequest1.predicate = predicate
         do {
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            if let first = commentIDs.last {
                return (first.value(forKey: "comments") as? String ?? "", first.value(forKey: "idnumber") as? String ?? "0")
            }
            
         } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return ("", "0")
        
        
    }
    
    
    
    func getMaxCheckListId(_ project : projectItem) -> Int32{
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        let predicate = NSPredicate(format: "idcia = %@ and idproject = %@", project.idcia ?? "", project.idproject ?? "")
        fetchRequest1.predicate = predicate
        fetchRequest1.fetchLimit = 1
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "xno", ascending: false)]
        
        do {
            
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            for first in commentIDs {
               return (first.value(forKey: "xno") as? Int32) ?? 0
            }
            // try managedObjectContext.save()
            return 0
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return 0
        
        
    }
    
    func getIntroWalkItems(_ project : projectItem) -> [cl_ObjIntroWalk2]{
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        let predicate = NSPredicate(format: "idcia = %@ and idproject = %@", project.idcia ?? "", project.idproject ?? "")
        fetchRequest1.predicate = predicate
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "xno", ascending: true)]
        
        var rtns = [cl_ObjIntroWalk2]()
        do {
            let introwalk2photo = cl_introWalkPhotoLocal()
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            for first in commentIDs {
                let obj = cl_ObjIntroWalk2()
                obj.idcia = project.idcia
                obj.idproject = project.idproject
                obj.sidintrowalk1 = project.idintrowalk1
                obj.xno = (first.value(forKey: "xno") as? Int32) ?? 0
                obj.idnumber = (first.value(forKey: "idnumber") as? Int32) ?? 0
                obj.sidnumber = (first.value(forKey: "sidnumber") as? String) ?? ""
                obj.comments = (first.value(forKey: "comments") as? String) ?? ""
                obj.initial_finishyn = (first.value(forKey: "initial_finishyn") as? String) ?? ""
                obj.initialURL = (first.value(forKey: "initialUrl") as? String) ?? ""
                if let xid = obj.idnumber {
                    obj.photos = introwalk2photo.getIntroWalkItemPhotos(xid)
                }else{
                    obj.photos = [cl_ObjIntroWalk2Photo]()
                }
                
                rtns.append(obj)
            }
            return rtns
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return rtns
        
        
    }
    
    func getIntroWalkItems(_ project : projectItem, sidnumber: String) -> cl_ObjIntroWalk2{
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        let predicate = NSPredicate(format: "idcia = %@ and idproject = %@ and sidnumber= %@", project.idcia ?? "", project.idproject ?? "", sidnumber)
        fetchRequest1.predicate = predicate
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "idnumber", ascending: true)]
        
        var rtns = cl_ObjIntroWalk2()
        do {
            let introwalk2photo = cl_introWalkPhotoLocal()
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            if let first = commentIDs.first {
                let obj = cl_ObjIntroWalk2()
                obj.idcia = project.idcia
                obj.idproject = project.idproject
                obj.sidintrowalk1 = project.idintrowalk1
                obj.xno = (first.value(forKey: "xno") as? Int32) ?? 0
                obj.idnumber = (first.value(forKey: "idnumber") as? Int32) ?? 0
                obj.comments = (first.value(forKey: "comments") as? String) ?? ""
                obj.initial_finishyn = (first.value(forKey: "initial_finishyn") as? String) ?? ""
                obj.initialURL = (first.value(forKey: "initialUrl") as? String) ?? ""
                if let xid = obj.idnumber {
                    obj.photos = introwalk2photo.getIntroWalkItemPhotos(xid)
                }else{
                    obj.photos = [cl_ObjIntroWalk2Photo]()
                }
                
                rtns = obj
            }
            return rtns
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return rtns
        
        
    }
    
    
    func getIntroWalkItemsCount(_ project : projectItem) -> Int{
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        let predicate = NSPredicate(format: "idcia = %@ and idproject = %@", project.idcia ?? "", project.idproject ?? "")
        fetchRequest1.predicate = predicate
        
        
        do {
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            return commentIDs.count
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return 0
        
        
    }
    
    
    func getIntroWalkItem(_ project : projectItem, xno: Int32) -> cl_ObjIntroWalk2{
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        let predicate = NSPredicate(format: "idcia = %@ and idproject = %@ and xno = \(xno)", project.idcia ?? "", project.idproject ?? "")
        fetchRequest1.predicate = predicate
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "idnumber", ascending: true)]
        
        let rtns = cl_ObjIntroWalk2()
        do {
            
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            let introwalk2photo = cl_introWalkPhotoLocal()
            if let first = commentIDs.first {
                let obj = cl_ObjIntroWalk2()
                obj.idcia = project.idcia
                obj.idproject = project.idproject
                obj.sidintrowalk1 = project.idintrowalk1
                obj.xno = (first.value(forKey: "xno") as? Int32) ?? 0
                obj.idnumber = (first.value(forKey: "idnumber") as? Int32) ?? 0
                obj.comments = (first.value(forKey: "comments") as? String) ?? ""
                if let xid = obj.idnumber {
                    obj.photos = introwalk2photo.getIntroWalkItemPhotos(xid)
                }else{
                    obj.photos = [cl_ObjIntroWalk2Photo]()
                }
                return obj
            }
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return rtns
        
        
    }
    
    
    func getCheckListNotSynced0() -> [checklistItemL]?{
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        
       
        var rtns = [checklistItemL]()
        
        //        let predicate = NSPredicate(format: "lastupdate = nil")
        //        fetchRequest1.predicate = predicate
        do {
            
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            for first in commentIDs {
                let rtn = checklistItemL()
                
                rtn.comment = first.value(forKey: "comments") as? String ?? ""
                rtn.creadate = first.value(forKey: "creadate") as? Date ?? Date()
                rtn.idchecklist = first.value(forKey: "idnumber") as? String ?? ""
                rtn.idcia = first.value(forKey: "idcia") as? String ?? ""
                rtn.idproject = first.value(forKey: "idproject") as? String ?? ""
                print(rtn.idproject!)
                rtns.append(rtn)
            }
            // try managedObjectContext.save()
            return rtns
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return nil
        
        
    }
    
}
