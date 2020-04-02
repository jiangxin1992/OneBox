//
//  academicRecordModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface academicRecordModel : NSObject

+(academicRecordModel *)parsingWithJsonDataForModel:(NSDictionary *)dict;

@property (nonatomic,assign)NSInteger user_id;
//申请年级
@property (nonatomic,assign)NSInteger apply_grade;
//学校类别
__string(boarding_day);
//学校性质
@property (nonatomic,assign)NSInteger student_sex_limit;
//倾向州
@property (nonatomic,assign)NSInteger trend_us_state_id;
//倾向城市
@property (nonatomic,assign)NSInteger trend_us_city_id;
//中文姓
__string(family_name);
//中文名
__string(given_name);
//性别 0女1男
@property (nonatomic,assign)NSInteger sex;
//生日
__string(birth);
//电话
__string(cell);
//qq
__string(qq);
//email
__string(email);
//gpa
@property (nonatomic,assign)CGFloat gpa;
@property (nonatomic,assign)CGFloat sat;
@property (nonatomic,assign)CGFloat ssat;
@property (nonatomic,assign)CGFloat isee;
@property (nonatomic,assign)CGFloat toefl;
@property (nonatomic,assign)CGFloat toefl_junior;
@property (nonatomic,assign)CGFloat ielts;
@property (nonatomic,assign)CGFloat slate;
@property (nonatomic,assign)CGFloat act;

@end
