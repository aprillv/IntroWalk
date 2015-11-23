//
//  AdressListViewController.swift
//  Contract
//
//  Created by April on 11/19/15.
//  Copyright © 2015 HapApp. All rights reserved.
//

import UIKit
import Alamofire

class AddressListViewController: UITableViewController, UISearchBarDelegate {

    var AddressList : [ContractsItem]? {
        didSet{
            self.tableView?.reloadData()
        }
    }
    
    @IBOutlet weak var LoginUserName: UIBarButtonItem!{
        didSet{
            let userInfo = NSUserDefaults.standardUserDefaults()
            LoginUserName.title = userInfo.objectForKey(BaseViewController.ProjectOpenConstants.LoggedUserNameKey) as? String
        }
    }
    // MARK: - Constanse
    private struct constants{
        static let Title : String = "Address List"
        static let CellIdentifier : String = "Address Cell Identifier"
        static let ContractServiceURL = "bacontract_signature.json"
    }
    
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.title = constants.Title
        
        self.tableView.reloadData()
        
    }

    
    // MARK: - Search Bar Deleagte
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AddressList?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(constants.CellIdentifier, forIndexPath: indexPath)

        if let cellitem = cell as? AddressListViewCell {
            let item: ContractsItem = AddressList![indexPath.row]
            cellitem.CiaNmLbl.text = item.cianame
            cellitem.ProjectNmLbl.text = item.nproject
            cellitem.DateLbl.text = item.refdate
            cellitem.ClientLbl.text = item.client
        }
        
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
       let item: ContractsItem = AddressList![indexPath.row]
        Alamofire.request(.POST,
            BaseViewController.ProjectOpenConstants.ServerURL + constants.ContractServiceURL,
            parameters: ContractRequestItem(contractInfo: item).DictionaryFromObject()).responseJSON{ (response) -> Void in
            if response.result.isSuccess {
                if let rtnValue = response.result.value as? [String: AnyObject]{
                    let rtn = ContractSignature(dicInfo: rtnValue)
                   let pdfData = NSData(base64EncodedString: rtn.base64pdf!, options: NSDataBase64DecodingOptions(rawValue: 0))
//                    [webview loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
                    let path =  NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                    let pdfPath = path.stringByAppendingString("_\(rtn.idcia)_\(rtn.idcity)_\(rtn.idproject).pdf")
                    let filemanager = NSFileManager.defaultManager()
                    if !filemanager.fileExistsAtPath(pdfPath){
                        if NSFileManager.defaultManager().createFileAtPath(pdfPath, contents: pdfData, attributes: nil){
                            print("success")
                        }else{
                            print("fail")
                        }
                    }
                    
                    //    NSString *PDFPath = [path stringByAppendingPathComponent:@"123.pdf"];
                    //    _pdfViewController = [[PDFViewController alloc] initWithPath:PDFPath];
                    
                    let pdfConr = PDFViewController(path: pdfPath)
                    self.navigationController?.pushViewController(pdfConr, animated: true)
//                    _pdfViewController = [[PDFViewController alloc] initWithResource:@"testA.pdf"];
//                    
//                    
//                    _pdfViewController.title = @"Sample PDF";
//                    
//                    _navigationController = [[UINavigationController alloc] initWithRootViewController:_pdfViewController];
//                    [self.window setRootViewController:_navigationController];
//                    _navigationController.view.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
//                    _navigationController.navigationBar.translucent = NO;
//                    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
//                    [_pdfViewController.navigationItem setRightBarButtonItems:@[saveBarButtonItem]];
                    
//                    let handle = NSFileHandle.
                    
//                    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                    //2>.拼接路径
//                    NSString *PDFPath = [path stringByAppendingPathComponent:@"123.pdf"];
//                    
//                    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//                    NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
//                    NSString *imagePath = [documentFolderPath stringByAppendingPathComponent:@"yourPdfFileName.pdf"];
//                    
//                    NSFileManager *filemanager=[NSFileManager defaultManager];
//                    if(![filemanager fileExistsAtPath:filePath])
//                    [[NSFileManager defaultManager] createFileAtPath:filePath   contents: nil attributes: nil];
//                    
//                    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
//                    
//                    [handle writeData:data];
                    
                    
                }else{
//                    self.PopServerError()
                }
            }else{
//                self.PopNetworkError()
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
