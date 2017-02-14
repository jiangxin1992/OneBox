//
//  AppDelegate.h
//  OneBox
//
//  Created by 谢江新 on 15-2-2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYIntroductionPanel.h"
#import "MYIntroductionView.h"
#import "GeTuiSdk.h"
#import "GexinSdk.h"
@class CustomTabbarController;


@interface AppDelegate : UIResponder <UIApplicationDelegate,GexinSdkDelegate,UIScrollViewDelegate,MYIntroductionDelegate,GeTuiSdkDelegate>{
@private
    UINavigationController *_naviController;
    NSString *_deviceToken;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomTabbarController *viewController;

@property (strong, nonatomic) GexinSdk *gexinPusher;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;
@property (assign, nonatomic) SdkStatus sdkStatus;

@property (assign, nonatomic) int lastPayloadIndex;
@property (retain, nonatomic) NSString *payloadId;

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)stopSdk;

- (void)setDeviceToken:(NSString *)aToken;
- (BOOL)setTags:(NSArray *)aTag error:(NSError **)error;
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

- (void)bindAlias:(NSString *)aAlias;
- (void)unbindAlias:(NSString *)aAlias;

- (void)testSdkFunction;
//- (void)testSendMessage;
- (void)testGetClientId;




@end

