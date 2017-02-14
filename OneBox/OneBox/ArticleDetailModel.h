//
//  schoolDetailModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/7.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

@interface ArticleDetailModel : baseModelJX
+(ArticleDetailModel *)parsingWithJsonDataForModel:(NSDictionary *)dict;
__string(share_link);
__string(app_html_url);
__string(m_id);//id long
__string(created_at);//str
__string(title);
@property (nonatomic,assign)BOOL had_voted;
@property (nonatomic,assign)NSInteger votes_count;
@property (nonatomic,assign)NSInteger follows_count;
@property (nonatomic,assign)NSInteger comments_count;
@property (nonatomic,assign)BOOL had_followed;
@property (nonatomic,copy)NSDictionary *user;

@end
