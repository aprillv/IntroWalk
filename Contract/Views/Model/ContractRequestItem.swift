//
//  ContractRequestItem.swift
//  Contract
//
//  Created by April on 11/20/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Foundation

class ContractRequestItem: NSObject {
    var cInfo : ContractsItem?
//    var idnumber: String?
//    var idcity: String?
//    var idcia: String?
//    var code: String?
    
    required init(contractInfo : ContractsItem){
        super.init()
        cInfo = contractInfo
    }
    
    func DictionaryFromObject() -> [String: String]{
        return ["idnumber" : cInfo?.idnumber ?? ""
            , "idcity" : cInfo?.idcity ?? ""
            , "idcia": cInfo?.idcia ?? ""
            , "code": cInfo?.code ?? ""]
    }
}