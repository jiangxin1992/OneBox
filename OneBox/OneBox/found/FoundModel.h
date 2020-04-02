//
//  FoundModel.h
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

@interface FoundModel : baseModelJX

+(NSMutableArray *)parsingData:(NSDictionary *)dict;

@property (nonatomic, strong) NSNumber *isAppear;
@property (nonatomic, assign) BOOL if_order_school;
@property (nonatomic, assign) NSInteger is_order_school;
@property (nonatomic, strong) NSString *thumb_image_url;
@property (nonatomic, strong) NSString *en_name;
@property (nonatomic, strong) NSString *cn_name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *grade;
@property (nonatomic, strong) NSString *setup_year;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *web;
@property (nonatomic, strong) NSString *total_students;
@property (nonatomic, strong) NSString *ap_count;

@end
