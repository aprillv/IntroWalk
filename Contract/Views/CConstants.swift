//
//  File.swift
//  Contract
//
//  Created by April on 11/23/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import Foundation
import UIKit

struct CConstants{
   
    
    static let BorderColor : UIColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
    static let BackColor : UIColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
    
    static let ShowFilter : String = "ShowFilter"
    
    static let UserInfohasLogout :  String = "logout"
    
    static let MsgTitle : String = "BA Checklist"
    static let MsgOKTitle : String = "OK"
    static let MsgValidationTitle : String = "Validation Failed"
    static let MsgServerError : String = "Server Error, please try again later"
    static let MsgNetworkError : String = "Network Error, please check your network"
    
    static let UserInfoRememberMe :  String = "Login Remember Me"
    static let UserInfoEmail :  String = "Login Email"
    static let UserInfoPwdbefore : String = "Login Password Last"
    static let UserInfoName :  String = "Logined User Name"
    static let UserInfoPwd :  String = "Login Password"
    
    static let LoginingMsg = "   Logining...   "
    static let RequestMsg = "Requesting from server..."
     static let SubmitMsg = "Submitting to server..."
    static let SavedMsg = "Saving to the BA Server..."
    static let SavedSuccessMsg = "Photo Saved successfully."
    static let SavedFailMsg = "Saved fail."
    static let SendEmailSuccessfullMsg = "Sent email successfully."
    static let PrintSuccessfullMsg = "Print successfully."
    
    static let CheckedImgNm = "checked"
    static let CheckImgNm = "check"
    static let SuccessImageNm = "checkmark"
    
    static let SegueToAddressList :  String = "adressList"
    static let SegueToPrintPdf : String = "tofile"
//    static let SegueToSignaturePdf : String = "pdfSignature"
//    static let SegueToThridPartyFinacingAddendumPdf : String = "pdfThridPartyFinacingAddendum"
//    static let SegueToClosingMemo : String = "closingmemo"
//    static let SegueToDesignCenter : String = "designcenter"
//    static let SegueToAddendumA : String = "addenduma"
//    static let SegueToAddendumC : String = "addendumc"
//    
//    static let SegueToInformationAboutBrokerageServices : String = "InformationAboutBrokerageServices"
//    static let SegueToExhibitA : String = "exhibita"
//    static let SegueToExhibitB : String = "exhibitb"
//    static let SegueToExhibitC : String = "exhibitc"
    static let SegueToPrintModel : String = "printModel"
    static let SegueToPrintModel2 : String = "printModel2"
    static let SegueToPrintModelPopover : String = "Print switch"
    static let SegueToAddressModelPopover : String = "Address switch"
    static let SegueToOperationsPopover : String = "Show Operations"
    
    static let Administrator = "roberto@buildersaccess.com"
    
    static let ServerURL = "https://contractssl.buildersaccess.com/"
    static let LoggedUserNameKey : String = "LoggedUserNameInDefaults"
    static let InstallAppLink : String = "itms-services://?action=download-manifest&url=https://www.buildersaccess.com/iphone/checklist.plist"
     //validate login and get address list
    static let LoginServiceURL: String = "bachecklist_login.json"
    //check app version
    static let CheckUpdateServiceURL: String = "bachecklist_version.json"
    //get project list
    static let ProjectListServiceURL = "bachecklist_projectSearch.json"
    //get check list Table
    static let GetCheckListTableServiceURL = "bachecklist_getChecklistTable.json"
    //get check list
    static let GetCheckListServiceURL = "bachecklist_getChecklist.json"
    //save Intro Walk1
    static let SaveIntroWalk1ServiceURL = "bachecklist_saveIntroWalk1.json"
    
    static let GetIntroWalkPhotoURL = "bachecklist_getIntroWalkPhoto"
    
    //save Intro Walk2
    static let SaveIntroWalk2ServiceURL = "bachecklist_saveIntroWalk2.json"
    
    //save Intro Walk2 Photo
    static let SaveIntroWalk2PhotoServiceURL = "bachecklist_saveIntroWalk2Photo.json"
    
    static let GetIntroWalk1ServiceURL = "bachecklist_getIntroWalk.json"
    //seve checklist photo
    static let SaveChecklistPhotoServiceURL = "bachecklist_saveChecklistPhoto.json"
    
    
    
    static let StoryboardName = "Main"
    
   
    
    static let ApplicationColor  = UIColor(red: 0, green: 164/255.0, blue: 236/255.0, alpha: 1)
    static let SearchBarBackColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    static let ApplicationBarFontName  =  "Futura"
    static let ApplicationBarFontSize : CGFloat = 25.0
    static let ApplicationBarItemFontSize : CGFloat = 17.0
    
    
    
}



