//
//  AddressUITableViewCell.swift
//  Contract
//
//  Created by April Lv on 2/20/17.
//  Copyright © 2017 HapApp. All rights reserved.
//

import UIKit

class AddressUITableViewCell: UITableViewCell {
    @IBOutlet weak var lineHeight: NSLayoutConstraint!{
        didSet{
            lineHeight.constant = 1.0 / UIScreen.main.scale
            updateConstraintsIfNeeded()
        }
    }

    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var projectNameLbl: UILabel!
     @IBOutlet weak var buyerNameLbl: UILabel!
    func setCellContent(pinfo: projectItem) {
        projectNameLbl.text = ""
        buyerNameLbl.text = ""
        statusLbl.text = ""
//        projectNameLbl.textColor = UIColor.black
        
        if pinfo.name == nil {
            projectNameLbl.text = "No address found"
//            projectNameLbl.textColor = UIColor.red
        }else{
            projectNameLbl.text = pinfo.name ?? ""
            
            buyerNameLbl.text = pinfo.buyer1name ?? ""
            if pinfo.buyer2name != "" {
                buyerNameLbl.text = buyerNameLbl.text! + ", " +  pinfo.buyer2name!
            }
            if pinfo.finishyn == "1" {
                statusLbl.text = "Finished"
            }else{
                statusLbl.text = pinfo.introwalk_status ?? ""
                if statusLbl.text == "" {
                    let oi = cl_introWalkLocal()
                    if oi.getIntroWalkItemsCount(pinfo) > 0 {
                        statusLbl.text = "Draft"
                    }
                }
            }
            
            
        }
        
//        statusLbl.text = "Draft"
    }

}
