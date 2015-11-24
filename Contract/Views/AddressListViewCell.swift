//
//  AdressListViewCell.swift
//  Contract
//
//  Created by April on 11/20/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit

class AddressListViewCell: UITableViewCell {

    private var CiaNmLbl: UILabel!
    private var ProjectNmLbl: UILabel!
    private var DateLbl: UILabel!
    private var ClientLbl: UILabel!
    
    
    
    @IBOutlet weak var backView: UIView!{
        didSet{
            CiaNmLbl = UILabel()
            backView.addSubview(CiaNmLbl)
            
            ProjectNmLbl = UILabel()
            backView.addSubview(ProjectNmLbl)
            
            DateLbl = UILabel()
            backView.addSubview(DateLbl)
            
            ClientLbl = UILabel()
            backView.addSubview(ClientLbl)
            
//            addObserverCell()
            backView.autoresizesSubviews = true
            
            backView?.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.Old, context: nil)
            setDisplaySubViews()
        }
    }

    
    func addObserverCell(){
//        removeObserverCell()
        backView?.addObserver(self, forKeyPath: "center", options: NSKeyValueObservingOptions.Old, context: nil)
       
//         print("\(backView.observationInfo)")
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "center"{
            self.setDisplaySubViews()
        }
    }
    
    func removeObserverCell(){
//        print("\(backView.observationInfo)")
        backView?.removeObserver(self, forKeyPath: "center")
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
