//
//  SignatureView.m
//  ILPDFKitSample
//
//  Created by April on 11/17/15.
//  Copyright © 2015 Iwe Labs. All rights reserved.
//

#import "SignatureView.h"
#import "PopSignUtil.h"

@implementation SignatureView{
//    CGRect cts;
    CGFloat ratios;
    
    
}

@synthesize lineArray, LineWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ratios = 1;
        self.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(toSignautre)];
        
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(void)updateWithZoom:(CGFloat)zoom{
    [super updateWithZoom:zoom];
    [self setNeedsDisplay];
}
-(void)setLineWidth:(float)LineWidth1{
    LineWidth = LineWidth1;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    [self drawInRect:rect withContext:context];
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *theTouch = [touches anyObject];
    if ([theTouch tapCount] == 2) {
        [self toSignautre];
    }
}

-(void)toSignautre{
    [self becomeFirstResponder];
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle: [self.xname hasSuffix:@"Sign"]? @"Signature" : @"Initial" action:@selector(popSignature:)];
    UIMenuController *menuCont = [UIMenuController sharedMenuController];
    
    [menuCont setTargetRect:self.frame inView:self.superview];
    menuCont.arrowDirection = UIMenuControllerArrowDown;
    menuCont.menuItems = [NSArray arrayWithObject:menuItem];
    [menuCont setMenuVisible:YES animated:YES];
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {}

- (BOOL)canBecomeFirstResponder { return YES; }

- (void)popSignature:(id)sender {
    
    [PopSignUtil getSignWithVC:nil withOk:^(UIView *image, BOOL isToAll) {
        CGRect ct = self.frame;
        SignatureView *sv = (SignatureView *)image;
        self.frame = sv.frame;
        self.frame = ct;
        self.lineArray = sv.lineArray;
        self.originHeight =sv.originHeight;
        self.LineWidth = sv.LineWidth;
        
        if (isToAll) {
            for (SignatureView *other in self.pdfViewsssss.pdfWidgetAnnotationViews) {
                if ([other isKindOfClass:[SignatureView class]]
                    && [other.sname hasSuffix: [self.sname substringFromIndex:2] ]){
                    CGRect ct = other.frame;
                    other.frame = sv.frame;
                    other.frame = ct;
                    other.lineArray = sv.lineArray;
                    other.originHeight =sv.originHeight;
                    other.LineWidth = sv.LineWidth;
                }
            }
        }
        
        [PopSignUtil closePop];
    } withCancel:^{
        [PopSignUtil closePop];
    } showAll:![self.xname hasSuffix:@"Sign"]];
    
}



-(void)drawInRect:(CGRect)rect withContext:(CGContextRef )context{
    if (self.originHeight > 0) {
        //        ratios = MIN(frame.size.width/self.frame.size.width, frame.size.height/self.frame.size.height);
        ratios = rect.size.height/self.originHeight;
    }else{
        ratios = 1;
    }
    
    
    CGFloat prex = 2;
//    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, LineWidth*ratios);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    //    CGContextSetLineCap(context, kCGLineJoinRound);
    //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
    if ([lineArray count]>0) {
        //        self.backgroundColor = [UIColor redColor];
        for (int i=0; i<[lineArray count]; i++) {
            NSArray * array=[NSArray
                             arrayWithArray:[lineArray objectAtIndex:i]];
            
            if ([array count]>0)
            {
                CGContextBeginPath(context);
                CGPoint myStartPoint=CGPointFromString([array objectAtIndex:0]);
                CGContextMoveToPoint(context, myStartPoint.x*ratios+prex, myStartPoint.y*ratios);
                
                for (int j=0; j<[array count]-1; j++)
                {
                    CGPoint myEndPoint=CGPointFromString([array objectAtIndex:j+1]);
                    //--------------------------------------------------------
                    CGContextAddLineToPoint(context, myEndPoint.x*ratios+prex,myEndPoint.y*ratios);
                }
                //获取colorArray数组里的要绘制线条的颜色
                
                UIColor *lineColor=[UIColor blackColor];
                //获取WidthArray数组里的要绘制线条的宽度
                
                //设置线条的颜色，要取uicolor的CGColor
                CGContextSetStrokeColorWithColor(context,[lineColor CGColor]);
                //-------------------------------------------------------
                //设置线条宽度
                CGContextSetLineWidth(context, LineWidth*ratios);
                //保存自己画的
                CGContextStrokePath(context);
            }
        }
    }
    
    
}

@end
