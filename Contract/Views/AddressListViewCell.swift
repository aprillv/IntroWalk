//
//  AdressListViewCell.swift
//  Contract
//
//  Created by April on 11/20/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class AddressListViewCell: UITableViewCell {
    private var ProjectNmLbl: UILabel!
    private var ConsultantLbl: UILabel!
    private var ClientLbl: UILabel!
    
    
    @IBOutlet weak var cview: UIView!{
        didSet{
            
            ProjectNmLbl = UILabel()
            cview.addSubview(ProjectNmLbl)
            
            ConsultantLbl = UILabel()
            ConsultantLbl.textAlignment = NSTextAlignment.Left
            cview.addSubview(ConsultantLbl)
            
            ClientLbl = UILabel()
            cview.addSubview(ClientLbl)
            setDisplaySubViews()
        }
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setDisplaySubViews()
    }
    
    func setDisplaySubViews(){
        
        let space : CGFloat = 10.0
        
        let xheight = frame.height
        let xwidth = frame.width - space * 2 - 16
        ProjectNmLbl.frame  = CGRect(x: 8, y: 0, width: xwidth * 0.34, height: xheight)
        
        
        
        ClientLbl.frame  = CGRect(x: ProjectNmLbl.frame.origin.x + ProjectNmLbl.frame.width + space, y: 0, width: xwidth * 0.33, height: xheight)
        
        ConsultantLbl.frame  = CGRect(x: ClientLbl.frame.origin.x + ClientLbl.frame.width + space, y: 0, width: xwidth * 0.23, height: xheight)
        
        
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        self.setCellBackColor(highlighted)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setCellBackColor(selected)
    }
    
    private func setCellBackColor(sels: Bool){
        if sels {
            self.backgroundColor = CConstants.SearchBarBackColor
            self.contentView.backgroundColor = CConstants.SearchBarBackColor
        }else{
            self.backgroundColor = UIColor.whiteColor()
            self.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
   
    
    var contractInfo: ContractsItem? {
        didSet{
            if let item = contractInfo{
                ProjectNmLbl.text = item.nproject
                ConsultantLbl.text = item.assignsales1name
                ClientLbl.text = item.client
            }
        }
    }
}
