//
//  AppDelegate.h
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GeTuiSdk.h"
#import "GexinSdk.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GexinSdkDelegate,GeTuiSdkDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

