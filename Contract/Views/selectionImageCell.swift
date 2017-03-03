//
//  selectionImageCell.swift
//  Selection
//
//  Created by April on 3/14/16.
//  Copyright © 2016 BuildersAccess. All rights reserved.
//

import UIKit

protocol selectionImageCellDelegate{
    func addPhoto(_ cell : selectionImageCell)
    func delPhoto(_ cell : selectionImageCell)
    func deletePhoto(_ tag: Int, cell : selectionImageCell)
}

class selectionImageCell: UICollectionViewCell {

//    override func drawRect(rect: CGRect) {
//        self.layer.borderColor = UIColor.clearColor().CGColor
//    }
    var selDelegate : selectionImageCellDelegate?
    
    @IBAction func deletePicture(_ sender: UIButton) {
        self.selDelegate?.deletePhoto(sender.tag,cell:  self)
        print(sender.tag)
    }
    @IBOutlet var delelteBtn: UIButton!
    @IBOutlet var spinner: UIActivityIndicatorView!
//    @IBOutlet var upc: UILabel!
//    @IBOutlet var name: myUILabel!{
//        didSet{
//            name.verticalAlignment = VerticalAlignmentTop
//        }
//    }
    @IBOutlet var pic: UIImageView!{
        didSet{
            self.layer.borderColor = CConstants.BorderColor.cgColor
            self.layer.borderWidth = 1.0
            
            pic.isUserInteractionEnabled = true
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectionImageCell.imageTapped(_:)))
            pic.addGestureRecognizer(tapRecognizer)
            
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(selectionImageCell.imageLongPress(_:)))
            pic.addGestureRecognizer(longGesture)
            
//            pic.backgroundColor = CConstants.BorderColor
        }
    }
    
    func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
//        let tappedImageView = gestureRecognizer.view!
        self.selDelegate?.addPhoto(self)
        
    }
    func imageLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        //        let tappedImageView = gestureRecognizer.view!
        self.selDelegate?.delPhoto(self)
        
    }
    
    
    
}
