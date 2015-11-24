//
//  AddressListViewHeadView.swift
//  Contract
//
//  Created by April on 11/23/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class AddressListViewHeadView: UIView {
    
    private var CiaNmLbl: UILabel!
    private var ProjectNmLbl: UILabel!
    private var DateLbl: UILabel!
    private var ClientLbl: UILabel!
    
    private struct constants{
        static let CiaNM = "Company"
        static let ProjectNM = "Project"
        static let DateS = "* Date"
        static let Client = "Client"
        static let HeadBackGroudColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
    }
   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = constants.HeadBackGroudColor
        backView = UIView(frame: CGRect(x: 8, y: 4, width: frame.width - 16, height: 44-8))
        backView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.addSubview(backView)
        addSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setDisplaySubViews()
    }
    
    private var backView : UIView!
    
    private func addSubviews(){
        CiaNmLbl = UILabel()
        backView.addSubview(CiaNmLbl)
        CiaNmLbl.font = UIFont.boldSystemFontOfSize(17)
        
        ProjectNmLbl = UILabel()
        backView.addSubview(ProjectNmLbl)
        ProjectNmLbl.font = UIFont.boldSystemFontOfSize(17)
        
        DateLbl = UILabel()
        backView.addSubview(DateLbl)
        DateLbl.font = UIFont.boldSystemFontOfSize(17)
        
        ClientLbl = UILabel()
        backView.addSubview(ClientLbl)
        ClientLbl.font = UIFont.boldSystemFontOfSize(17)
        
        //            addObserverCell()
        SetFields()
        setDisplaySubViews()
    }
    
   
    
    func setDisplaySubViews(){
        if backView != nil{
            let frame = backView.frame
            let space : CGFloat = 10.0
            let xwidth = frame.width - space * 3
            let xheight = frame.height
            
            CiaNmLbl.frame = CGRect(x: 0, y: 0, width: xwidth * 0.26, height: xheight)
            
            ProjectNmLbl.frame  = CGRect(x: CiaNmLbl.frame.width + space, y: 0, width: xwidth * 0.30, height: xheight)
            
            DateLbl.frame  = CGRect(x: ProjectNmLbl.frame.origin.x + ProjectNmLbl.frame.width + space, y: 0, width: xwidth * 0.16, height: xheight)
            
            ClientLbl.frame  = CGRect(x: DateLbl.frame.origin.x + DateLbl.frame.width + space, y: 0, width: xwidth * 0.28, height: xheight)
        }
    }
    
    func SetFields(){
        CiaNmLbl.text = constants.CiaNM
        ProjectNmLbl.text = constants.ProjectNM
        DateLbl.text = constants.DateS
        ClientLbl.text = constants.Client
    }
    
}
