//
//  SignatureView.h
//  ILPDFKitSample
//
//  Created by April on 11/17/15.
//  Copyright © 2015 Iwe Labs. All rights reserved.
//

#import "PDFWidgetAnnotationView.h"
#import "PDFView.h"
@interface SignatureView : PDFWidgetAnnotationView

@property (nonatomic, retain) NSMutableArray *lineArray;
//@property (nonatomic, retain) PDFView* pdfView;
@property (nonatomic, retain) NSString *sname;
@property (nonatomic, assign) float LineWidth;
@property (nonatomic,retain)   PDFView* pdfViewsssss;
@property (nonatomic, assign) float originHeight;
-(void)drawInRect:(CGRect)rect withContext:(CGContextRef )context;
//@property (nonatomic, retain)  float lineWidthArray[10]={5.0,10.0,12.0,14.0,16.0,20.0,22.0,24.0,26.0,28.0};
//
//static NSMutableArray *WidthArray;
//static int widthCount;
-(void)toSignautre;
@end
