//
//  HapObject.swift
//  HappApp
//
//  Created by April on 11/12/15.
//  Copyright © 2015 lovetthomes. All rights reserved.
//

import Foundation

class ContractObject : NSObject{
    required init(dicInfo : [String: AnyObject]){
        super.init()
        self.setValuesForKeysWithDictionary(dicInfo)
    }
    
    private struct constants  {
        static let projectName : String = "Contract."
//        NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
        static let lastName : String = "Item"
    
    }
    
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if let dic = value as? [Dictionary<String, AnyObject>]{
            var tmpArray : [ContractObject] = [ContractObject]()
            for tmp0 in dic{
//                print(GetCapitalFirstWord(key))
                
                let anyobjecType: AnyObject.Type = NSClassFromString(GetCapitalFirstWord(key)!)!
                if anyobjecType is ContractObject.Type {
                    let vc = (anyobjecType as! ContractObject.Type).init(dicInfo: tmp0)
                    tmpArray.append(vc)
                }
            }
            super.setValue(tmpArray, forKey: key)
        }else{
            super.setValue(value, forKey: key as String)
        }
        
    }
    
    private func GetCapitalFirstWord(str : String?) -> String?{
        if let str0 = str {
            let index = str0.startIndex.advancedBy(1)
            let firstCapitalWord = str0.substringToIndex(index).capitalizedString
            return constants.projectName + firstCapitalWord + str0.substringFromIndex(index) + constants.lastName
        }
        return nil
    }
}