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
    var isContract : String?
    
    required init(contractInfo : ContractsItem?){
        super.init()
        if contractInfo != nil {
            cInfo = contractInfo
        }
        
    }
    
    func DictionaryFromObject() -> [String: String]{
        let a = ["idnumber" : cInfo?.idnumber ?? ""
            , "idcity" : cInfo?.idcity ?? ""
            , "idcia": cInfo?.idcia ?? ""
            , "code": cInfo?.code ?? ""
            , "isContract" : isContract ?? "1"
            , "ispdf": "0"]
//        print(a)
        return a
    }
    
    func DictionaryFromBasePdf(model :ContractPDFBaseModel) -> [String: String]{
        let a = ["idnumber" : model.idnumber!
            , "idcity" : model.idcity!
            , "idcia": model.idcia!
            , "code": model.code!
            , "isContract" : isContract ?? "1"
            , "ispdf": "0"]
        //        print(a)
        return a
    }
}