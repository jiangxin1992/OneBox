//
//  LoginTool.m
//  OneBox
//
//  Created by yyj on 2017/2/14.
//  Copyright © 2017年 谢江新. All rights reserved.
//

#import "LoginTool.h"

@implementation LoginTool
+(NSString *)getAPIWithPlatformType:(SSDKPlatformType)platformType
{
    NSString *url = @"";
    if(platformType==SSDKPlatformSubTypeQZone)
    {
        url=@"/v3/users/qq_connect/callback";
        
    }else if(platformType==SSDKPlatformTypeSinaWeibo)
    {
        url=@"/v3/users/weibo/callback";
        
    }if(platformType==SSDKPlatformTypeWechat)
    {
        url=@"/v3/users/weixin/callback";
    }
    return url;
}
+(NSDictionary *)getCallbackParameters:(SSDKUser *)user
{
    NSDictionary *parameters = nil;
    NSString *_avatar = @"";
    if(![NSString isNilOrEmpty:user.icon])
    {
        _avatar = user.icon;
    }
    NSString *_username = @"";
    if(![NSString isNilOrEmpty:user.nickname])
    {
        _username = user.icon;
    }
    NSString *_mark = @"";
    if(![NSString isNilOrEmpty:user.aboutMe])
    {
        _mark = user.aboutMe;
    }
    parameters=@{@"token":[regular getToken]
                 ,@"uid":user.uid
                 ,@"avatar":_avatar
                 ,@"sex":@(user.gender)
                 ,@"username":_username
                 ,@"email":@""
                 ,@"mark":_mark};
    return parameters;
}

@end
