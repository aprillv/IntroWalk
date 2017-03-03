//
//  ChecklistTableViewCell.swift
//  Contract
//
//  Created by April Lv on 2/17/17.
//  Copyright © 2017 HapApp. All rights reserved.
//

import UIKit

protocol IntroWalkTableViewCellDelegate {
    func editCheckList(cell: IntroWalkTableViewCell)
}
class IntroWalkTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var initialImg: UIImageView!
    @IBOutlet weak var noLblHeight: NSLayoutConstraint!
    
    var collectionDelegate : IntroWalkListViewController?
    
    @IBOutlet weak var noLbl: UILabel!
    @IBOutlet weak var btn: UIButton!{
        didSet{
           setBtnStyle(btn)
        }
    }
    
    func setBtnStyle(_ signInBtn: UIButton){
        signInBtn.layer.cornerRadius = 5.0
        signInBtn.titleLabel?.font = UIFont(name: CConstants.ApplicationBarFontName, size: CConstants.ApplicationBarItemFontSize)
    }
    var delegate : IntroWalkTableViewCellDelegate?
    
    
    @IBAction func doEditCheckList(_ sender: UIButton) {
        delegate?.editCheckList(cell: self)
    }
    private struct constants{
    static let cellIdentifier="selectionImageCell"
    }
    @IBOutlet weak var lineHeight: NSLayoutConstraint!{
        didSet{
            lineHeight.constant = 1.0/UIScreen.main.scale
            self.updateConstraintsIfNeeded()
        }
    }
    @IBOutlet weak var txtHeight1: NSLayoutConstraint!
    @IBOutlet weak var txtContent: UILabel!{
        didSet{
//             txtContent.backgroundColor = UIColor.blue
            txtContent.numberOfLines = 0
            txtContent.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    @IBOutlet weak var txtHeight: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!{
        didSet{
            //             txtComment.backgroundColor = UIColor.lightText
            //            txtComment.layer.borderColor = UIColor(colorLiteralRed: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1).cgColor
            //            txtComment.layer.borderColor = UIColor.white.cgColor
            //            txtComment.layer.borderWidth = 1.0/(UIScreen.main.scale)
            backView.layer.cornerRadius = 5.0
            backView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblComent: UILabel!
    @IBOutlet weak var txtComment: UILabel!{
        didSet{
//             txtComment.backgroundColor = UIColor.lightText
//            txtComment.layer.borderColor = UIColor(colorLiteralRed: 192.0/255.0, green: 192.0/255.0, blue: 192.0/255.0, alpha: 1).cgColor
//            txtComment.layer.borderColor = UIColor.white.cgColor
//            txtComment.layer.borderWidth = 1.0/(UIScreen.main.scale)
            txtComment.layer.cornerRadius = 5.0
            txtComment.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblPhoto: UILabel!
    @IBOutlet weak var clvPhoto: UICollectionView!{
        didSet{
            clvPhoto.delegate = self
            clvPhoto.dataSource = self
        }
    }
    
    func setContent(item : cl_ObjIntroWalk2, no: Int, del: IntroWalkListViewController) {
        self.collectionDelegate = del
        noLbl.text = "# \(no + 1)"
        txtHeight.constant = item.txtHeghts ?? 40
        if txtHeight.constant ==  40 {
            noLblHeight.constant = 40
        }else{
            noLblHeight.constant = 23.5
        }
        txtHeight1.constant = item.txtHeghts ?? 40
        self.updateConstraintsIfNeeded()
//        print(self.bounds, UIScreen.main.bounds)
        txtContent.text = item.comments
        
        (clvPhoto.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = item.clvSize ?? CGSize.zero
        
//        _ = util()
        self.photoList = item.photos
        
        
        
//        let photoDB = cl_checklistphotoDB()
//        let cnt = Int(item.photocnt ?? "0") ?? 0
//        if cnt > 0 {
//            for i in 0...(cnt - 1) {
//                let xidx = String(i+1)
//                let url = tool.getImgFromServer(item.idchecklist ?? "0", idx: xidx, idcia: item.idcia!, idproject: item.idproject!)
//                
//                photoDB.savedCheckListPhotoToDB(item.idcia ?? "",idproject: item.idproject ?? "", idcheck: item.idchecklist ?? "", idx: xidx, url: url)
//                
//                self.photoList?.append(url as AnyObject)
//            }
//            self.clvPhoto.reloadData()
//        }
        
        
        
    }
    var photoList: [AnyObject]?{
        didSet{
            
            if clvPhoto != nil {
                clvPhoto.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: constants.cellIdentifier, for: indexPath)
        if let cell1 = cell as? selectionImageCell {
            
            cell1.selDelegate = self.collectionDelegate
            cell1.layer.borderColor = UIColor.clear.cgColor
            cell1.pic.contentMode = .scaleAspectFill
            if let tmp0 = self.photoList![indexPath.row] as? UIImage {
                cell1.pic.image = tmp0
            }else if let tmp1 = self.photoList![indexPath.row] as? cl_ObjIntroWalk2Photo {
                if let url = tmp1.photoUrl {
//                    print(url)
                    cell1.spinner.startAnimating()
                    cell1.pic.sd_setImage(with: URL(string: url), completed: { (_, _, _, _) -> Void in
                        cell1.spinner.stopAnimating()
                    })
                }
                
            }
            cell1.delelteBtn.isHidden = true
            
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList?.count ?? 0
    }
    
}
