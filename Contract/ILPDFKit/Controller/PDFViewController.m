// PDFViewController.m
//
// Copyright (c) 2015 Iwe Labs
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PDF.h"
#import "PDFFormContainer.h"
#import "SignatureView.h"
#import "PopSignUtil.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "cl_pdf.h"
#import "Contract-Bridging-Header.h"
#import "Contract-Swift.h"
//#import "Alamofire-Swift.h"
//#import <Contract/LoginUser-Swift.h>

@interface PDFViewController(Private)
//@property  (nonatomic, retain)

- (void)loadPDFView;
- (CGPoint)margins;
@end

@implementation PDFViewController{
    SignatureView *currentSignature;
    NSArray *signatureArray;
    bool isDownload;
}

const static NSString *CompanyName= @"sellercompany";
const static NSString *Buyer= @"buyer";
const static NSString *Lot= @"lot";
const static NSString *Block= @"block1";
const static NSString *Section= @"block2";
const static NSString *City= @"city";
const static NSString *County= @"county";
const static NSString *Address= @"address_1";
const static NSString *SalePrice= @"saleprice";

const static NSString *CompanyName1= @"cianame";
const static NSString *Buyer1= @"client";
const static NSString *Lot1= @"lot";
const static NSString *Block1= @"block";
const static NSString *Section1= @"section";
const static NSString *City1= @"cityname";
const static NSString *County1= @"county";
const static NSString *Address1= @"nproject";
const static NSString *SalePrice1= @"sold";

//const static NSString *CompanyName= @"sellercompany";

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Contract";
//    for (NSString *keys in self.pdfInfo.allKeys) {
//        if (![keys isEqualToString:@"base64pdf"]) {
//            NSLog(@"pdf %@ - %@", keys, self.pdfInfo[keys]);
//        }
//    }
    NSLog(@"pdf  %@", self.pdfInfo);
    self.navigationItem.hidesBackButton = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Buyer 1" style:UIBarButtonItemStylePlain target:self action:@selector(buyer1Signature:)];
    saveBarButtonItem.tag = 1;
    UIBarButtonItem * saveBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Buyer 2" style:UIBarButtonItemStylePlain target:self action:@selector(buyer1Signature:)];
    saveBarButtonItem2.tag = 2;
    
    UIBarButtonItem *saveBarButtonItema = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
    [self.navigationItem setLeftBarButtonItems:@[backItem, saveBarButtonItem, saveBarButtonItem2]];
    
     [self.navigationItem setRightBarButtonItem:saveBarButtonItema];
//    self.view.backgroundColor = NSColor.whiteColo
    
    [self loadPDFView];
    
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save:(id)sender {
    NSData *savedPdfData = [self.document savedStaticPDFData];
    NSString *filedata = [savedPdfData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    idcia	query	string	Yes
//    idproject	query	string	Yes
//    username	query	string	Yes
//    code	query	string	Yes
//    file	query	string
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"idcia"] = self.pdfInfo[@"idcia"];
    param[@"idproject"] = self.pdfInfo[@"idproject"];
    param[@"username"] = [[NSUserDefaults standardUserDefaults] objectForKey: @"LoggedUserNameInDefaults"];
    param[@"code"] = self.pdfInfo[@"code"];
    param[@"file"] = filedata;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:CConstantsC.ContractUploadPdfURL]
                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval: 20];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:nil]];
    
    NSURLSessionDataTask* postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        NSLog(@"return value = %@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    }];
    [postDataTask resume];
}


- (void)buyer1Signature:(UIBarButtonItem *)item{
    for (SignatureView * sign in self.pdfView.pdfWidgetAnnotationViews) {
        if ([sign isKindOfClass:[SignatureView class]]) {
            if (CGRectIntersectsRect(sign.superview.bounds, sign.frame)) {
                if ((item.tag == 1 && [sign.sname hasSuffix:@"bottom1"]) || (item.tag == 2 && [sign.sname hasSuffix:@"bottom2"])) {
                    // buyer
                    [sign toSignautre];
                    return;
                }
//                NSLog(@"%@, %f %f", sign.sname, sign.frame.origin.x,  sign.frame.size.height);
            }
        }
    }
}

- (void)buyer2Signature{
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _pdfView.alpha = 0;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    for (PDFForm *form in self.document.forms) {
        [form removeObservers];
    }
    [_pdfView removeFromSuperview];
    self.pdfView = nil;
    [self loadPDFView];
}

#pragma mark - PDFViewController

- (instancetype)initWithData:(NSData *)data {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        isDownload = YES;
        _document = [[PDFDocument alloc] initWithData:data];
    }
    return self;
}

- (instancetype)initWithResource:(NSString *)name {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        isDownload = NO;
        _document = [[PDFDocument alloc] initWithResource:name];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil) {
        isDownload = NO;
        _document = [[PDFDocument alloc] initWithPath:path];
    }
    return self;
}

- (void)reload {
    [_document refresh];
    [_pdfView removeFromSuperview];
    _pdfView = nil;
    [self loadPDFView];
}

#pragma mark - Private

- (void)loadPDFView {
    id pass = (_document.documentPath ? _document.documentPath:_document.documentData);
    CGPoint margins = [self getMargins];
    NSArray *additionViews = [_document.forms createWidgetAnnotationViewsForSuperviewWithWidth:self.view.bounds.size.width margin:margins.x hMargin:margins.y];
    
//    NSMutableString * str = [[NSMutableString alloc]init];
    NSMutableDictionary *dics = [[NSMutableDictionary alloc]init];
    NSMutableArray *Samedics = [[NSMutableArray alloc]init];
    NSDictionary *overrideFields = @{CompanyName : CompanyName1
                                       , Buyer : Buyer1
                                       , Lot: Lot1
                                       , Block : Block1
                                       , Section : Section1
                                       , City : City1
                                       , County : County1
                                       , Address : Address1
                                     , SalePrice : SalePrice1};
    NSArray *na = overrideFields.allKeys;
    for (PDFWidgetAnnotationView * pv in additionViews) {
        if ([na containsObject: pv.xname]) {
            if ([Address isEqualToString: pv.xname]) {
                pv.value = [NSString stringWithFormat:@"%@/%@", self.pdfInfo[overrideFields[pv.xname]], self.pdfInfo[@"zipcode"]];
            }else{
                pv.value = self.pdfInfo[overrideFields[pv.xname]];
            }
            
        }
        
        
        NSDictionary *dic = [pv printself];
        if (dic) {
            if ([dics.allKeys containsObject:[dic allKeys].firstObject]){
                [Samedics addObject:[dic allKeys].firstObject];
            }else{
                [dics addEntriesFromDictionary:dic];
            }
        }
    }
    
    for (NSString *xkey in Samedics) {
        [dics removeObjectForKey:xkey];
    }
    cl_pdf *pdf = [[cl_pdf alloc] init];
    NSString* pdfkey = [NSString stringWithFormat:@"%@_%@", self.pdfInfo[@"idcia"], self.pdfInfo[@"idcity"]];
    if (isDownload) {
        NSData *pdfData = [NSJSONSerialization dataWithJSONObject:dics options:kNilOptions error:nil];
        [pdf addToPDF:pdfData withId: pdfkey];
    }else{
        NSData *pdfData = [pdf getPDFByKey:pdfkey];
        
//        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:pdfData options:kNilOptions error:nil]);
    }
    
//    NSLog(@"%d %d %@", additionViews.count, dics.allKeys.count, dics);
    _pdfView = [[PDFView alloc] initWithFrame:self.view.bounds dataOrPath:pass additionViews:additionViews];
    [self.view addSubview:_pdfView];
}

- (CGPoint)getMargins {
    
    static const float PDFLandscapePadWMargin = 13.0f;
    static const float PDFLandscapePadHMargin = 7.25f;
    static const float PDFPortraitPadWMargin = 9.0f;
    static const float PDFPortraitPadHMargin = 6.10f;
    static const float PDFPortraitPhoneWMargin = 3.5f;
    static const float PDFPortraitPhoneHMargin = 6.7f;
    static const float PDFLandscapePhoneWMargin = 6.8f;
    static const float PDFLandscapePhoneHMargin = 6.5f;
    UIInterfaceOrientation a = [[UIApplication sharedApplication] statusBarOrientation];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        
        if (UIInterfaceOrientationIsPortrait(a))return CGPointMake(PDFPortraitPadWMargin,PDFPortraitPadHMargin);
        else return CGPointMake(PDFLandscapePadWMargin,PDFLandscapePadHMargin);
    } else {
        if (UIInterfaceOrientationIsPortrait(a))return CGPointMake(PDFPortraitPhoneWMargin,PDFPortraitPhoneHMargin);
        else return CGPointMake(PDFLandscapePhoneWMargin,PDFLandscapePhoneHMargin);
    }
}

@end
