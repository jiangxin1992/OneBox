//
//  usermodel.h
//  OneBox
//
//  Created by 谢江新 on 15/9/2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface usermodel : NSObject
+(usermodel *)parsingData_single:(NSDictionary *)_dict;
+(NSMutableArray *)parsingData:(NSDictionary *)dict;
@property (nonatomic,assign)BOOL ease_mob_activated;
//2表示是否把我拉黑
@property(nonatomic,assign) NSInteger is_block2;
//1表示我是否把他拉黑
@property(nonatomic,assign) NSInteger is_block1;
@property (nonatomic,assign)BOOL is_following;
@property (nonatomic,assign)BOOL is_server;
__string(cell);
__string(title);
__string(token);
__string(mark);
__string(avatar);
__string(ease_mob_password);
__string(user_id);
__string(ease_mob_uuid);
__string(username);
__string(ease_mob_username);
//__string(level);
@property (nonatomic,assign) long level;
@end
