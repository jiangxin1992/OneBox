//
//  CustomTabbarController.h
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CustomTabbarController : UITabBarController

//调用单例
+(id)sharedManager;
//使tabbarHide
-(void)tabbarHide;
//使tabbarAppear
-(void)tabbarAppear;
@end
