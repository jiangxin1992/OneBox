//
//  ApplyFilemodel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/19.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyFilemodel : NSObject
+(ApplyFilemodel *)parsingWithJsonDataForModel:(NSDictionary *)dict;

@property (nonatomic,assign)NSInteger bank_savings;
@property (nonatomic,assign)NSInteger diploma;
@property (nonatomic,assign)NSInteger passport;
@property (nonatomic,assign)NSInteger reading;
@property (nonatomic,assign)NSInteger recommend_letter;
@property (nonatomic,assign)NSInteger school_apply_table;
@property (nonatomic,assign)NSInteger school_reports;
@property (nonatomic,assign)NSInteger study_reports;
@property (nonatomic,assign)NSInteger test_score;
@property (nonatomic,assign)NSInteger is_reading;
@property (nonatomic,assign)NSInteger ds160;
@property (nonatomic,assign)NSInteger visa_pay;
@property (nonatomic,assign)NSInteger sevis_fee_pay;
@property (nonatomic,assign)NSInteger a120;
@property (nonatomic,assign)NSInteger picture;
@property (nonatomic,assign)NSInteger income;
@property (nonatomic,assign)NSInteger person_tax;
@property (nonatomic,assign)NSInteger salary;
@property (nonatomic,assign)NSInteger house;
@property (nonatomic,assign)NSInteger household;
@property (nonatomic,assign)NSInteger manage_notice;

@end
