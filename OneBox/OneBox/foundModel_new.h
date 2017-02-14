//
//  foundModel.h
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

@interface foundModel_new : baseModelJX
+(NSMutableArray *)parsingData:(NSDictionary *)dict;
@property(nonatomic,assign) BOOL isapp;

@property (nonatomic,copy)NSDictionary *data;
__string(m_type);
__string(title);
__string(title_en);
__string(pic);
__string(f_title_en);
__string(f_title);



@end
