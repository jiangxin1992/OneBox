//
//  comment_model_alter.h
//  OneBox
//
//  Created by 谢江新 on 15/5/10.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

@interface comment_model_alter : baseModelJX
+(NSMutableArray *)parsingWithJsonDict:(NSDictionary *)dict;
+(comment_model_alter *)getdata:(NSDictionary *)dict;
//评论id
__string(cell);
@property (nonatomic,assign) BOOL is_server;
__string(comment_id);
__string(ease_mob_username);
//用户id
__string(user_id);
//用户名
__string(user_name);
//用户头像
__string(user_avatar);

//评论内容
__string(content);
//评论创建时间
__string(created_at);
//评论点赞数量
@property (nonatomic,assign)NSInteger votes_count;
//是否点赞
@property (nonatomic,assign)BOOL had_voted;

@end
