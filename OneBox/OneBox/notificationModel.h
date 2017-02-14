//
//  notificationModel.h
//  OneBox
//
//  Created by 谢江新 on 15/8/27.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface notificationModel : NSObject

+(NSMutableArray *)parsingWithArrForModel:(NSData *)data;

__string(send_avatar);
__string(sender);
__string(NOT_ID);
__string(created_at);
__string(detail_TIME);
@property (nonatomic,copy)NSDictionary *extra_info;
__string(user_id);
__string(updated_at);
__string(body);
@property (nonatomic,assign)BOOL is_readed;

@end
