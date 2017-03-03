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

class cl_project : NSObject{
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentStoreCoordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.managedObjectContext
    }()
    
    let DTName = "Project"
    
    func savedProjectsToDB(_ itemList : [projectItem]){
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
//        let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
//            try persistentStoreCoordinator.execute(request, with: managedObjectContext)
            for item : projectItem in itemList {
                let entity =  NSEntityDescription.entity(forEntityName: DTName,
                                                                in:managedObjectContext)
                
                let scheduledDayItem = NSManagedObject(entity: entity!,
                                                       insertInto: managedObjectContext)
                
                scheduledDayItem.setValue(item.cianame!, forKey: "cianame")
//                scheduledDayItem.setValue(item.haschecklist!, forKey: "haschecklistDB")
                scheduledDayItem.setValue(item.idcia!, forKey: "idcia")
                scheduledDayItem.setValue(item.idproject!, forKey: "idproject")
//                scheduledDayItem.setValue(item.idsub!, forKey: "idsub")
                scheduledDayItem.setValue(item.name!, forKey: "projectname")
                scheduledDayItem.setValue(item.status!, forKey: "status")
                scheduledDayItem.setValue(item.buyer1name ?? "", forKey: "buyer1name")
                scheduledDayItem.setValue(item.buyer2name ?? "", forKey: "buyer2name")
                scheduledDayItem.setValue(item.introwalk_status ?? "", forKey: "introwalk_status")
                scheduledDayItem.setValue(item.introwalk_statusid ?? "", forKey: "introwalk_statusid")
                scheduledDayItem.setValue(item.idintrowalk1 ?? "", forKey: "idintrowalk1")
                scheduledDayItem.setValue(item.finishyn ?? "", forKey: "finishyn")
                scheduledDayItem.setValue(item.finishDate ?? "", forKey: "finishDate")
                
//                if item.haschecklist ?? "False" == "True" {
//                    scheduledDayItem.setValue("1", forKey: "haschecklistDB")
//                }else{
//                    scheduledDayItem.setValue("0", forKey: "haschecklistDB")
//                }
                do {
                    try managedObjectContext.save()
                    
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }
            
        
        
        
        
    }
    
    func getAllProjects() -> [projectItem]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        //        let predicate = NSPredicate(format: "dayFullName = %@", weekdayNm)
        //        fetchRequest.predicate = predicate
        
        var rtn = [projectItem]()
        //3
        do {
            let results =
                try managedObjectContext.fetch(fetchRequest)
            if let t = results as? [NSManagedObject] {
                for item in t {
                    let tmp : projectItem = projectItem(dicInfo : nil)
                    tmp.idproject = item.value(forKey: "idproject") as? String
                    tmp.cianame = item.value(forKey: "cianame") as? String
                    tmp.idcia = item.value(forKey: "idcia") as? String
                    tmp.name = item.value(forKey: "projectname") as? String
                    tmp.status = item.value(forKey: "status") as? String
                    tmp.buyer1name = item.value(forKey: "buyer1name") as? String
                    tmp.buyer2name = item.value(forKey: "buyer2name") as? String
                    tmp.introwalk_statusid = item.value(forKey: "introwalk_statusid") as? String
                    tmp.introwalk_status = item.value(forKey: "introwalk_status") as? String
                    tmp.idintrowalk1 = item.value(forKey: "idintrowalk1") as? String
                    tmp.finishyn = item.value(forKey: "finishyn") as? String
                    tmp.finishDate  = item.value(forKey: "finishDate") as? String
//                    tmp.haschecklist = item.value(forKey: "haschecklistDB") as? String
//                    if tmp.haschecklist == "False" {
//                        tmp.haschecklist = item.value(forKey: "haschecklistLocal") as? String ?? "0"
//                    }
                    rtn.append(tmp)
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return rtn
        
    }
    
    func getProjectByPro(pro : projectItem) -> projectItem{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
                let predicate = NSPredicate(format: "idcia = %@ and idproject = %@", pro.idcia ?? "", pro.idproject ?? "")
                fetchRequest.predicate = predicate
        
        var rtn = pro
        //3
        do {
            let results =
                try managedObjectContext.fetch(fetchRequest)
            if let t = results as? [NSManagedObject] {
                if let item = t.first {
                    let tmp : projectItem = projectItem(dicInfo : nil)
                    tmp.idproject = item.value(forKey: "idproject") as? String
                    tmp.cianame = item.value(forKey: "cianame") as? String
                    tmp.idcia = item.value(forKey: "idcia") as? String
                     tmp.name = item.value(forKey: "projectname") as? String
                    tmp.status = item.value(forKey: "status") as? String
                    tmp.buyer1name = item.value(forKey: "buyer1name") as? String
                    tmp.buyer2name = item.value(forKey: "buyer2name") as? String
                    tmp.introwalk_statusid = item.value(forKey: "introwalk_statusid") as? String
                    tmp.introwalk_status = item.value(forKey: "introwalk_status") as? String
                    tmp.idintrowalk1 = item.value(forKey: "idintrowalk1") as? String
                    tmp.finishyn = item.value(forKey: "finishyn") as? String
                    tmp.finishDate  = item.value(forKey: "finishDate") as? String
                    //                    tmp.haschecklist = item.value(forKey: "haschecklistDB") as? String
                    //                    if tmp.haschecklist == "False" {
                    //                        tmp.haschecklist = item.value(forKey: "haschecklistLocal") as? String ?? "0"
                    //                    }
                    rtn = tmp
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return rtn
        
    }
    
    
    func saveIntroWalkForProject(_ projectInfo: projectItem) {
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: DTName)
        
        
        let predicate = NSPredicate(format: "idcia = %@ and idproject = %@", projectInfo.idcia ?? "", projectInfo.idproject ?? "")
        fetchRequest1.predicate = predicate
        
        do {
            let commentIDs =  try managedObjectContext.fetch(fetchRequest1) as! [NSManagedObject]
            if commentIDs.count > 0 {
                if let project = commentIDs.first {
//                    project.setValue(projectInfo.status ?? "", forKey: "status")
                    project.setValue(projectInfo.idintrowalk1 ?? "", forKey: "idintrowalk1")
                    project.setValue(projectInfo.introwalk_status ?? "", forKey: "introwalk_status")
                    project.setValue(projectInfo.introwalk_statusid ?? "", forKey: "introwalk_statusid")
                    project.setValue(projectInfo.finishyn ?? "", forKey: "finishyn")
                    let currentDate = Date()
                    let usDateFormat = DateFormatter()
                    usDateFormat.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM/dd/yyyy hh:mm a", options: 0, locale: Locale(identifier: "en-US"))
                    project.setValue(usDateFormat.string(from: currentDate), forKey: "finishDate")
                    
                }
            }else{
                savedProjectsToDB([projectInfo])
            }
            
            
            try managedObjectContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
