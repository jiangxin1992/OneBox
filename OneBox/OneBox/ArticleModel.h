//
//  foundModel.h
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

@interface ArticleModel : baseModelJX
+(NSMutableArray *)parsingData:(NSDictionary *)dict;
@property(nonatomic,assign) BOOL isapp;
__string(m_id);
__string(title);
__string(desc);
__string(thumb_url);
@end
