// PDFFormButtonField.m
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

#import <QuartzCore/QuartzCore.h>
#import "PDF.h"
#import "PDFFormButtonField.h"

#define PDFButtonMinScaledDimensionScaleFactor 0.85
#define PDFButtonMinScaledDimension(r) MIN((r).size.width,(r).size.height)*PDFButtonMinScaledDimensionScaleFactor
#define PDFButtonMarginScaleFactor 0.75

@implementation PDFFormButtonField {
    NSString *_val;
    UIButton *_button;
}

#pragma mark - UIView

- (void)drawRect:(CGRect)rect {
    if (_pushButton) {
        [super drawRect:rect];
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self drawWithRect:rect context:ctx back:YES selected:_button.selected radio:_radio];
}



- (void)setValue2:(NSString *)value {
    if ([value isEqualToString:@"1"]) {
        _val = @"1";
        _button.selected = YES;
    } else {
        _val = @"0";
        _button.selected = NO;
    }
    self.value = _val;
    [self refresh];
}


- (NSString *)value {
    return _val;
}

- (void)updateWithZoom:(CGFloat)zoom {
    [super updateWithZoom:zoom];
    CGFloat minDim = PDFButtonMinScaledDimension(self.bounds);
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _button.frame = CGRectMake(center.x-minDim+self.frame.origin.x, center.y-minDim+self.frame.origin.y, minDim*2, minDim*2);
    if (_radio) _button.layer.cornerRadius = _button.frame.size.width/2;
    [self refresh];
    [_button setNeedsDisplay];
}

#pragma mark - PDFFormButtonField
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame radio:NO];
}
- (instancetype)initWithFrame:(CGRect)frame radio:(BOOL)rad {
    self = [super initWithFrame:frame];
    if (self) {
        _radio = rad;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat minDim = PDFButtonMinScaledDimension(self.bounds);
        CGPoint center = CGPointMake(frame.size.width/2,frame.size.height/2);
        _button.frame = CGRectMake(center.x-minDim, center.y-minDim, minDim*2, minDim*2);
        if (_radio) _button.layer.cornerRadius = _button.frame.size.width/2;
        _button.opaque = NO;
        _button.backgroundColor = [UIColor clearColor];
        [self addSubview:_button];
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.userInteractionEnabled = NO;
        _button.userInteractionEnabled  = NO;
    }
    return self;
}

- (void)setButtonSuperview {
    [_button removeFromSuperview];
    CGRect frame = self.bounds;
    CGFloat minDim = PDFButtonMinScaledDimension(self.bounds);
    CGPoint center = CGPointMake(frame.size.width/2,frame.size.height/2);
    _button.frame = CGRectMake(center.x-minDim+self.frame.origin.x, center.y-minDim+self.frame.origin.y, 2*minDim,2*minDim);
    [self.superview insertSubview:_button aboveSubview:self];
}

#pragma mark - Responders

- (void)buttonPressed:(id)sender {
    [self.delegate widgetAnnotationValueChanged:self];
}

#pragma mark - Getters/Setters

- (void)setPushButton:(BOOL)pb {
    _pushButton = pb;
}

- (void)setNoOff:(BOOL)no {
    _noOff = no;
}

- (void)setRadio:(BOOL)rd {
    _radio = rd;
}

#pragma mark - Rendering

- (void)drawWithRect:(CGRect)frame context:(CGContextRef)ctx back:(BOOL)back selected:(BOOL)selected radio:(BOOL)radio {
    
//    NSLog(@"%@\n%@\n%@", self.name, self.value, self.exportValue);
//    NSArray *na = @[@"22a32", @"22a102", @"22a152", @"22a12", @"Buyer only as Buyers agent2"];
    NSArray *na = @[@""];

    radio = [na containsObject:self.exportValue];
    if (radio) {
        if (frame.size.width != frame.size.height) {
            frame.size.width = frame.size.height = MIN(frame.size.width, frame.size.height);
        }
//        selected = NO;
    }
    CGFloat minDim = PDFButtonMinScaledDimension(frame);
    if (radio) {
        minDim *= 1/.85;
    }
    CGPoint center = CGPointMake(frame.size.width/2,frame.size.height/2);
    CGRect rect = CGRectMake(center.x-minDim/2, center.y-minDim/2, minDim, minDim);
    if (selected && radio) {
        CGContextSaveGState(ctx);
        CGFloat margin = minDim/3;
        CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y);
        CGContextSetLineWidth(ctx, rect.size.width/8);
        CGContextSetLineCap(ctx,kCGLineCapRound);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
        
        CGContextMoveToPoint(ctx, rect.origin.x + margin/4, rect.origin.y + margin/4);
        CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width - margin/4, rect.origin.y +margin/4);
        CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width - margin/4, rect.origin.y + rect.size.height - margin/4);
        CGContextAddLineToPoint(ctx, rect.origin.x + margin/4, rect.origin.y + rect.size.height - margin/4);
        CGContextAddLineToPoint(ctx, rect.origin.x + margin/4, rect.origin.y + margin/4);
        
        CGContextMoveToPoint(ctx, rect.origin.x + margin, rect.origin.y + margin);
        CGContextAddLineToPoint(ctx, rect.origin.x - margin + rect.size.width, rect.origin.y - margin + rect.size.height);
        CGContextMoveToPoint(ctx, rect.origin.x - margin + rect.size.width, rect.origin.y + margin);
        CGContextAddLineToPoint(ctx, rect.origin.x + margin, rect.origin.y - margin + rect.size.height);
        //            CGContextAddLineToPoint(ctx, rect.size.width-margin*PDFButtonMarginScaleFactor, margin/2);
        
        CGContextStrokePath(ctx);
        
        
        CGContextRestoreGState(ctx);
    }else {
        CGContextSaveGState(ctx);
        CGFloat margin = minDim/3;
//        NSLog(@"+===%@+==%@+==%@", self.xname, self.value, self.exportValue);
        CGContextTranslateCTM(ctx, rect.origin.x, rect.origin.y);
        
        CGContextSetLineCap(ctx,kCGLineCapSquare);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
        
        if ([self.xname hasPrefix:@"dcChk"]) {
            CGContextSetLineWidth(ctx, rect.size.width/16);
            CGContextMoveToPoint(ctx, rect.origin.x - margin/4, rect.origin.y -margin/4);
            CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width - margin/4, rect.origin.y - margin/4);
            CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width - margin/4, rect.origin.y + rect.size.height - margin/4);
            CGContextAddLineToPoint(ctx, rect.origin.x - margin/4, rect.origin.y + rect.size.height - margin/4);
            CGContextAddLineToPoint(ctx, rect.origin.x - margin/4, rect.origin.y - margin/4);
            CGContextStrokePath(ctx);
            if (selected) {
                CGContextSetLineWidth(ctx, rect.size.width/8);
                CGContextMoveToPoint(ctx, rect.origin.x + frame.size.width*41/236  - margin/2, rect.origin.y  + frame.size.width*115/236 - margin/2);
                CGContextAddLineToPoint(ctx, rect.origin.x + frame.size.width*84/236 - margin/2, rect.origin.y  + frame.size.width*167/236 - margin/2);
                CGContextAddLineToPoint(ctx, rect.origin.x + frame.size.width*191/236 - margin/2, rect.origin.y + frame.size.width*64/236 - margin/2);
            }
            
        }else{
            if (selected) {
                CGContextSetLineWidth(ctx, rect.size.width/8);
                CGContextMoveToPoint(ctx, rect.origin.x-margin/4 , rect.origin.y + margin/4);
                CGContextAddLineToPoint(ctx, rect.origin.x - margin + rect.size.width-margin/2, rect.origin.y - margin + rect.size.height);
                CGContextMoveToPoint(ctx, rect.origin.x - margin + rect.size.width-margin/2, rect.origin.y + margin/4);
                CGContextAddLineToPoint(ctx, rect.origin.x + margin/4-margin/2, rect.origin.y - margin + rect.size.height);
            }
        }
        
        
        
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);
    }
    
    
}

@end
