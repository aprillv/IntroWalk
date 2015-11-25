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

@interface PDFViewController(Private)
//@property  (nonatomic, retain)

- (void)loadPDFView;
- (CGPoint)margins;
@end

@implementation PDFViewController{
    SignatureView *currentSignature;
    NSArray *signatureArray;
}
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Contract";
    self.navigationItem.hidesBackButton = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Buyer 1" style:UIBarButtonItemStylePlain target:self action:@selector(buyer1Signature:)];
    saveBarButtonItem.tag = 1;
    UIBarButtonItem * saveBarButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Buyer 2" style:UIBarButtonItemStylePlain target:self action:@selector(buyer1Signature:)];
    saveBarButtonItem2.tag = 2;
    
    UIBarButtonItem *saveBarButtonItema = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    
    [self.navigationItem setLeftBarButtonItems:@[backItem, saveBarButtonItem, saveBarButtonItem2]];
    
     [self.navigationItem setRightBarButtonItem:saveBarButtonItema];
    [self loadPDFView];
    
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)save:(id)sender {
//    NSString *savedPdfPath = [_pdfViewController.document savedStaticPDFData];
//    
//    [_pdfViewController removeFromParentViewController];
//    //    _pdfViewController = [[PDFViewController alloc] initWithData:savedStaticData];
//    
//    _pdfViewController = [[PDFViewController alloc] initWithPath:savedPdfPath];
//    
//    _pdfViewController.title = @"Saved Static PDF";
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Save Complete" message:@"The displayed PDF file is a static version of the previous file, but with the form values added. The starting PDF has not been modified and this static PDF no longer contains forms." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
//    [_navigationController setViewControllers:@[_pdfViewController]];
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
        _document = [[PDFDocument alloc] initWithData:data];
    }
    return self;
}

- (instancetype)initWithResource:(NSString *)name {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _document = [[PDFDocument alloc] initWithResource:name];
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil) {
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
    for (PDFWidgetAnnotationView * pv in additionViews) {
       
//        [str appendString:[pv printself]];
        NSDictionary *dic = [pv printself];
        if (dic) {
            if ([dics.allKeys containsObject:[dic allKeys].firstObject]){
                NSLog(@"%@", dic);
            }
            if (dic){
                [dics addEntriesFromDictionary:dic];
            }
        }
        
        
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
