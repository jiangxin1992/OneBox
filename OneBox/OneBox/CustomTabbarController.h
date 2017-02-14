//
//  CustomTabbarController.h
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@interface CustomTabbarController : UITabBarController
- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

//调用单例
+(id)sharedManager;
//使tabbarHide
-(void)tabbarHide;
-(void)tabbarHideWithanimated;
-(void)tabbarAppearWithanimated;
//使tabbarAppear
- (void)updateMsgCount:(int) count;
-(void)tabbarAppear;
- (void)logMsg:(NSString *)aMsg;
- (void)updateStatusView:(AppDelegate *)delegate;
@end
