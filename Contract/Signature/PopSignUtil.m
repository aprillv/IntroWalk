//
//  PopSignUtil.m
//  YRF
//
//  Created by jun.wang on 14-5-28.
//  Copyright (c) 2014年 王军. All rights reserved.
//

#import "PopSignUtil.h"
//#import "ConformView.h"


static PopSignUtil *popSignUtil = nil;

@implementation PopSignUtil{
    UIButton *okBtn;
    UIButton *cancelBtn;
    //遮罩层
    UIView *zhezhaoView;
    DrawSignView *draw1;
    DrawSignView *draw2;
}


//取得单例实例(线程安全写法)
+(id)shareRestance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popSignUtil = [[PopSignUtil alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver: popSignUtil selector:   @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    });
    return popSignUtil;
}


/** 构造函数 */
-(id)init{
    self = [super init];
    if (self) {
        //遮罩层
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        
//        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    return self;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    //Obtain current device orientation
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == 1 || orientation == 2) {
        // portral
        id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
//        [appDelegate.window.rootViewController.view addSubview:zhezhaoView];
//        CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
        //    NSLog(@"%@", appDelegate.window.rootViewController.view);
//        zhezhaoView.frame = CGRectMake(screenSize.height, 0, screenSize.height, screenSize.width);
        
        
        //    [signCallBackBlock release];
        
        CGRect appFrame = appDelegate.window.rootViewController.view.frame;
        zhezhaoView.frame = CGRectMake( 0, 0, MIN(appFrame.size.width, appFrame.size.height), MAX(appFrame.size.width, appFrame.size.height));
        
        if (draw2 != nil) {
            CGFloat width = MAX(appFrame.size.width, appFrame.size.height)/2 - 7.5;
            CGFloat height = width * .75 + 120;
            CGFloat orignx = (MIN(appFrame.size.width, appFrame.size.height) - width)/2;
            CGFloat origny = (MAX(appFrame.size.width, appFrame.size.height) - height*2-10)/2;
            draw1.frame = CGRectMake( orignx, origny, width, height);
            draw2.frame = CGRectMake( orignx, origny + height + 10 , width, height);
        }else{
//            CGFloat width = MIN(appFrame.size.width, appFrame.size.height) - 20;
//            CGFloat orginy = (MAX(appFrame.size.width, appFrame.size.height) - width * .75 - 120)/2;
//            draw1.frame = CGRectMake( 10, orginy, width, width*.75 + 120);
            draw1.center = zhezhaoView.center;
        }
        
    }else{
        id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
//        [appDelegate.window.rootViewController.view addSubview:zhezhaoView];
        CGRect appFrame = appDelegate.window.rootViewController.view.frame;
        zhezhaoView.frame = CGRectMake( 0, 0, MAX(appFrame.size.width, appFrame.size.height), MIN(appFrame.size.width, appFrame.size.height));
        if (draw2 != nil) {
            CGFloat width = MAX(appFrame.size.width, appFrame.size.height)/2 - 7.5;
            CGFloat height = width * .75 + 120;
            CGFloat origny = (MIN(appFrame.size.width, appFrame.size.height) - height)/2;
            draw1.frame = CGRectMake( 5, origny, width, height);
            draw2.frame = CGRectMake( 10 + width, origny, width, height);
        }else{
//            CGFloat width = MIN(appFrame.size.width, appFrame.size.height) - 20;
//            CGFloat orginy = (MAX(appFrame.size.width, appFrame.size.height) - width * .75 - 120)/2;
//            draw1.frame = CGRectMake( 10, orginy, width, width*.75 + 120);
            draw1.center = zhezhaoView.center;
        }
        
    }
    
    //Do my thing
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

//定制弹出框。模态对话框。
//+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock
//          withCancel:(CallBackBlock)callBackBlock showAll:(BOOL) show withTitle: (NSString *)title{
//    PopSignUtil *p = [PopSignUtil shareRestance];
//    [p setPopWithVC:VC withOk:signCallBackBlock withCancel:callBackBlock showAll:show title:title];
//}

+(void)getSignWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock withCancel:(CallBackBlock)callBackBlock{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p setPopWithVC:VC withOk:signCallBackBlock withCancel:callBackBlock showAll:NO title:nil withLineArray: nil];
}




-(void)setPopWithVC:(UIViewController *)VCrrr withOk:(SignCallBackBlock)signCallBackBlock
         withCancel:(CallBackBlock)cancelBlock showAll:(BOOL) show title:(NSString *) title withLineArray:(NSArray*)na{
    
    if (!zhezhaoView) {
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        //        zhezhaoView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    }else{
        for (UIView *tmp in zhezhaoView.subviews) {
            [tmp removeFromSuperview];
        }
    }
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController.view addSubview:zhezhaoView];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    //    NSLog(@"%@", appDelegate.window.rootViewController.view);
    zhezhaoView.frame = CGRectMake(screenSize.height, 0, screenSize.height, screenSize.width);
    
    
    //    [signCallBackBlock release];
    
    CGRect appFrame = appDelegate.window.rootViewController.view.frame;
    zhezhaoView.frame = appFrame;
//    NSLog(@"===%d", [[UIDevice currentDevice] orientation]);
    if ([[UIDevice currentDevice] orientation] == 1 || [[UIDevice currentDevice] orientation] == 2) {
    
        CGFloat width = MAX(appFrame.size.width, appFrame.size.height)/2 - 7.5;
        CGFloat height = width * .75 + 120;
        CGFloat orignx = (MIN(appFrame.size.width, appFrame.size.height) - width)/2;
        CGFloat origny = (MAX(appFrame.size.width, appFrame.size.height) - height*2-10)/2;
        DrawSignView *conformView = [[DrawSignView alloc]initWithFrame:CGRectMake( orignx, origny, width, height)];
        conformView.showSwitch = show;
        [conformView setLineArray:na];
        [conformView setTitle: @"Project Manager Signatrue"];
        [zhezhaoView addSubview:conformView];
        
        
        DrawSignView *conformView2 = [[DrawSignView alloc]initWithFrame: CGRectMake( orignx, origny + height + 10 , width, height)];
        conformView2.showSwitch = show;
        [conformView2 setLineArray: nil];
        conformView2.lastView = conformView;
        [conformView2 setTitle: @"Homeowner Signatrue"];
        conformView2.cancelBlock = cancelBlock;
        conformView2.signCallBackBlock  = signCallBackBlock;
        [zhezhaoView addSubview:conformView2];
        draw1 = conformView;
        draw2 = conformView2;
        
    }else{
        CGFloat width = MAX(appFrame.size.width, appFrame.size.height)/2 - 7.5;
        CGFloat height = width * .75 + 120;
        CGFloat origny = (MIN(appFrame.size.width, appFrame.size.height) - height)/2;
        DrawSignView *conformView = [[DrawSignView alloc]initWithFrame:CGRectMake( 5, origny, width, height)];
        conformView.showSwitch = show;
        [conformView setLineArray:na];
        [conformView setTitle: @"Project Manager Signatrue"];
        [zhezhaoView addSubview:conformView];
        
        DrawSignView *conformView2 = [[DrawSignView alloc]initWithFrame: CGRectMake( 10 + width, origny, width, height)];
        conformView2.showSwitch = show;
        [conformView2 setLineArray: nil];
        conformView2.lastView = conformView;
        [conformView2 setTitle: @"Homeowner Signatrue"];
        conformView2.cancelBlock = cancelBlock;
        conformView2.signCallBackBlock  = signCallBackBlock;
        [zhezhaoView addSubview:conformView2];
        draw1 = conformView;
        draw2 = conformView2;
    }
}
+(void)getInitialWithVC:(UIViewController *)VC withOk:(SignCallBackBlock)signCallBackBlock withTitle: (NSString *)title withLineArray:(NSArray*)na withCancel:(CallBackBlock)callBackBlock {
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p setPopWithVC2: VC withOk: signCallBackBlock withCancel: callBackBlock title: title withLineArray: na];
}

-(void)setPopWithVC2:(UIViewController *)VCrrr withOk:(SignCallBackBlock)signCallBackBlock
           withCancel:(CallBackBlock)cancelBlock title:(NSString *) title withLineArray:(NSArray*)na{
    
    if (!zhezhaoView) {
        zhezhaoView = [[UIView alloc]init];
        zhezhaoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    }else{
        for (UIView *tmp in zhezhaoView.subviews) {
            [tmp removeFromSuperview];
        }
    }
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController.view addSubview:zhezhaoView];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    zhezhaoView.frame = CGRectMake(screenSize.height, 0, screenSize.height, screenSize.width);
    
    CGRect appFrame = appDelegate.window.rootViewController.view.frame;
    CGFloat width = MIN(appFrame.size.width, appFrame.size.height) - 20;
    CGFloat orginy = (MAX(appFrame.size.width, appFrame.size.height) - width * .75 - 120)/2;
    
    DrawSignView *conformView = [[DrawSignView alloc]initWithFrame:CGRectMake( 10, orginy, width, width*.75 + 120)];
    conformView.showSwitch = false;
    [conformView setLineArray:na];
   
    conformView.cancelBlock = cancelBlock;
    conformView.signCallBackBlock  = signCallBackBlock;
    [conformView setTitle: @"Please print your initial here"];
    [zhezhaoView addSubview:conformView];
    
    draw1 = conformView;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    zhezhaoView.frame = appFrame;
    conformView.center = zhezhaoView.center;
    [UIView commitAnimations];
}





/** 关闭弹出框 */
+(void)closePop{
    PopSignUtil *p = [PopSignUtil shareRestance];
    [p closePop];
}


/** 关闭弹出框 */
-(void)closePop{
    id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
    CGSize screenSize = [appDelegate.window.rootViewController.view bounds].size;
    [CATransaction begin];
    [UIView animateWithDuration:0.25f animations:^{
        zhezhaoView.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
    } completion:^(BOOL finished) {
        //都关闭啊都关闭
        [zhezhaoView removeFromSuperview];
//        SAFETY_RELEASE(zhezhaoView);
    }];
    [CATransaction commit];
}




@end
