//
//  MyInfo.h
//  OneBox
//
//  Created by 顾鹏 on 15/5/8.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyInfo : NSObject
__string(sid);
__string(username);
//enroll_order_schools_count
@property(nonatomic,assign)NSInteger  enroll_order_schools_count;
@property(nonatomic,assign)NSInteger follow_schools_count;
@property(nonatomic,assign)NSInteger follows_count;
@property(nonatomic,assign)NSInteger following_count;
@property(nonatomic,assign)NSInteger posts_count;
@property(nonatomic,assign)NSInteger activities_count;
@property(nonatomic,assign)NSInteger order_schools_count;
__string(area);
__string(avatar);
__string(email);
@property(nonatomic,assign)BOOL weibo;
@property(nonatomic,assign)BOOL qq_connect;
@property(nonatomic,assign)BOOL weixin;

@property (nonatomic,assign)NSInteger gender;
__string(city);
__string(mark);
+(MyInfo *)parsingWithJsonDataForModel:(NSData *)data;
+(NSMutableArray *)parsingWithArrForModel:(NSData *)data;

@end
