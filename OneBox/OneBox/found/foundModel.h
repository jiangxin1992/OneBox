//
//  foundModel.h
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

@interface foundModel : baseModelJX

+(NSMutableArray *)parsingData:(NSDictionary *)dict;

@property(nonatomic,assign) BOOL isapp;
@property (nonatomic,assign)BOOL if_order_school;
@property (nonatomic,assign)NSInteger is_order_school;
__string(thumb_image_url);
__string(en_name);
__string(cn_name);
__string(city);
__string(state);
__string(rank);
__string(grade);
__string(setup_year);
__string(sid);
__string(web);
__string(total_students);
__string(ap_count);

@end
