//
//  AdressListViewCell.swift
//  Contract
//
//  Created by April on 11/20/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class AddressListViewCell: UITableViewCell {

    @IBOutlet weak var CiaNmLbl: UILabel!
    @IBOutlet weak var ProjectNmLbl: UILabel!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var ClientLbl: UILabel!
    
    var contractInfo: ContractsItem? {
        didSet{
            if let item = contractInfo{
                CiaNmLbl.text = item.cianame
                ProjectNmLbl.text = item.nproject
                DateLbl.text = item.refdate
                ClientLbl.text = item.client
            }
        }
    }
}
