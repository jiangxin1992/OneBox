//
//  MyInfo.m
//  OneBox
//
//  Created by 顾鹏 on 15/5/8.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "MyInfo.h"

@implementation MyInfo
+(MyInfo *)parsingWithJsonDataForModel:(NSData *)data
{
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *_dict=(NSDictionary*)res;
    NSDictionary *dict=_dict[@"data"];
    MyInfo * model = [[MyInfo alloc]init];

    if([dict objectForKey:@"order_schools_count"]==[NSNull null])
    {

        model.order_schools_count=0;
    }else
    {
        model.order_schools_count=[[dict objectForKey:@"order_schools_count"] integerValue];

    }
//    gender
    if([dict objectForKey:@"auth_providers"]==[NSNull null])
    {
        model.weibo=NO;
        model.qq_connect=NO;
        model.weixin=NO;
    }else
    {
        model.weibo=NO;
        model.qq_connect=NO;
        model.weixin=NO;
        NSMutableArray *arr=((NSMutableArray *)[dict objectForKey:@"auth_providers"]);
        for (NSString *auth in arr) {
            if([auth isEqualToString:@"weibo"])
            {
                model.weibo=YES;
                break;
            }
        }
        for (NSString *auth in [dict objectForKey:@"auth_providers"]) {
            if([auth isEqualToString:@"qq_connect"])
            {
                model.qq_connect=YES;
                break;
            }
        }
        for (NSString *auth in [dict objectForKey:@"auth_providers"]) {
            if([auth isEqualToString:@"weixin"])
            {
                model.weixin=YES;
                break;
            }
        }

    }

    if([dict objectForKey:@"gender"]==[NSNull null])
    {

        model.gender=0;
    }else
    {
        model.gender=[[dict objectForKey:@"gender"] integerValue];
        
    }
    if([dict objectForKey:@"activities_count"]==[NSNull null])
    {

        model.activities_count=0;
    }else
    {
        model.activities_count=[[dict objectForKey:@"activities_count"] integerValue];
        
    }
    if([dict objectForKey:@"posts_count"]==[NSNull null])
    {

        model.posts_count=0;
    }else
    {
        model.posts_count=[[dict objectForKey:@"posts_count"] integerValue];

    }
    if([dict objectForKey:@"following_count"]==[NSNull null])
    {

        model.following_count=0;
    }else
    {
        model.following_count=[[dict objectForKey:@"following_count"] integerValue];
        
    }
    if([dict objectForKey:@"follows_count"]==[NSNull null])
    {

        model.follows_count=0;
    }else
    {
        model.follows_count=[[dict objectForKey:@"follows_count"] integerValue];

    }
    if([dict objectForKey:@"follow_schools_count"]==[NSNull null])
    {

        model.follow_schools_count=0;
    }else
    {
        model.follow_schools_count=[[dict objectForKey:@"follow_schools_count"] integerValue];
        
    }
    if([dict objectForKey:@"enroll_order_schools_count"]==[NSNull null])
    {

        model.enroll_order_schools_count=0;
    }else
    {
        model.enroll_order_schools_count=[[dict objectForKey:@"enroll_order_schools_count"] integerValue];

    }

    if([dict objectForKey:@"id"]==[NSNull null])
    {

        model.sid=@"";
    }else
    {
        model.sid=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"id"] longValue]];

    }

    if([dict objectForKey:@"avatar"]==[NSNull null])
    {

        model.avatar=@"http://7ximo7.com2.z0.glb.qiniucdn.com/assets/images/avatar3.png";
    }else
    {
        model.avatar=[dict objectForKey:@"avatar"];

    }
    if([dict objectForKey:@"username"]==[NSNull null])
    {

        model.username=@"";
    }else
    {
        model.username=[dict objectForKey:@"username"];
        
    }
    if([dict objectForKey:@"mark"]==[NSNull null])
    {

        model.mark=@"";
    }else
    {
        model.mark=[dict objectForKey:@"mark"];

    }
    if([dict objectForKey:@"email"]==[NSNull null])
    {

        model.email=@"";
    }else
    {
        model.email=[dict objectForKey:@"email"];

    }
    if([dict objectForKey:@"area"]==[NSNull null])
    {

        model.area=@"";
    }else
    {
        model.area=[dict objectForKey:@"area"];
        
    }

    if([dict objectForKey:@"city"]==[NSNull null])
    {

        model.city=@"";
    }else
    {
        model.city=[dict objectForKey:@"city"];

    }
    return model;
    
}
+(NSMutableArray *)parsingWithArrForModel:(NSData *)data
{
    NSMutableArray *arrFriends = [[NSMutableArray alloc] init];
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *_dict=(NSDictionary*)res;
    NSArray *dict=_dict[@"data"];
    for (int i = 0; i < dict.count;i++) {
        MyInfo * model = [[MyInfo alloc]init];
        [model setValuesForKeysWithDictionary:dict[i]];
        [arrFriends addObject:model];

    }
    return arrFriends;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
