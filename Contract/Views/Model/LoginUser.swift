//
//  LoginUser.swift
//  Contract
//
//  Created by April on 11/20/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Foundation

class LoginUser: NSObject {
    var email: String?
    var password: String?
    var keyword : String?
    
    required init(email: String, password: String, keyword: String){
        super.init()
        self.email = email
        self.password = password
        self.keyword = keyword
    }
    
    func DictionaryFromObject() -> [String: String]{
        return ["email" : email ?? "", "password" : password ?? "", "keyword" : keyword!]
    }
    
}
