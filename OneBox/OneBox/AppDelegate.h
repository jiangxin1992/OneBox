//
//  AppDelegate.h
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/// 使用个推回调时，需要添加"GeTuiSdkDelegate"
/// iOS 10 及以上环境，需要添加 UNUserNotificationCenterDelegate 协议，才能使用 UserNotifications.framework 的回调

@interface AppDelegate : UIResponder <UIApplicationDelegate,GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

