//
//  PopSignUtil.h
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//


#import "DrawSignView.h"



@interface PopSignUtil : UIView
@property(nonatomic,copy)CallBackBlock noB;

+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock withCancel:(CallBackBlock)callBackBlock;
+(void)getInitialWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock withTitle: (NSString *)title withLineArray:(NSArray*)na withCancel:(CallBackBlock)callBackBlock;
+(void)closePop;
+ (UIImage *) imageWithView:(UIView *)view;
@end
