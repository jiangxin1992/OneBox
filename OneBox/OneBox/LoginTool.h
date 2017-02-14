//
//  LoginTool.h
//  OneBox
//
//  Created by yyj on 2017/2/14.
//  Copyright © 2017年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ShareSDK/ShareSDK.h>

@interface LoginTool : NSObject
/**
 * 第三方登录
 * 获取当前PlatformType对应的API
 */
+(NSString *)getAPIWithPlatformType:(SSDKPlatformType)platformType;
/**
 * 第三方登录
 * 获取请求参数 （第三方回调参数）
 * 用户信息
 */
+(NSDictionary *)getCallbackParameters:(SSDKUser *)user;

@end
