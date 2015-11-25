//
//  AddressListViewHeadView.swift
//  Contract
//
//  Created by April on 11/23/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class AddressListViewHeadView2: UIView {
    
    var CiaNmLbl: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = CConstants.BackColor
        
        CiaNmLbl = UILabel()
        self.addSubview(CiaNmLbl)
        CiaNmLbl.font = UIFont.boldSystemFontOfSize(15)
        
        setDisplaySubViews()
        CiaNmLbl.autoresizingMask = UIViewAutoresizing.FlexibleWidth
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setDisplaySubViews()
    }
    
   
    
     
    
    func setDisplaySubViews(){
        
          CiaNmLbl.frame = CGRect(x: 8, y: 0, width: frame.width-16, height: frame.height)
    }
    
}
