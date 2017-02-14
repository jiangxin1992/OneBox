//
//  chooseModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/15.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chooseModel : NSObject
+(NSMutableArray *)parsingWithJsonDataForModel:(NSDictionary *)dict;
@property (nonatomic,assign)NSInteger step_no;


@property (nonatomic,assign)NSInteger sid;
__string(full_address);
//建校时间
__string(setup_year);
//中英文名
__string(en_name);
__string(cn_name);
//城市
__string(cn_city);
//地址
__string(school_address);
//混校类型（int）
__string(student_sex_limit);
//走读寄宿
__string(boarding_day);
//isesl（int）
__string(isesl);
//学生数(int)
__string(total_students);
//ap课程(int)
__string(ap_count);
__string(cn_state);
//sat(float)
__string(sat_avg);
@property (nonatomic,copy)NSArray *prices;
//学费
//__string(tuition);
//生活费
//__string(alimony);

//学校id
__string(goal_id);

@end
