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

@property (nonatomic, strong) NSNumber *isAppear;

@property (nonatomic, copy) NSDictionary *data;
@property (nonatomic, copy) NSString *m_type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *title_en;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *f_title_en;
@property (nonatomic, copy) NSString *f_title;

@end
