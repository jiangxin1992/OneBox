//
//  surveyModel.h
//  OneBox
//
//  Created by 谢江新 on 15/2/11.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

#import <Foundation/Foundation.h>

@interface surveyModel : baseModelJX
+(surveyModel *)parsingWithJsonDataForModel:(NSDictionary *)dict;
//__string(progress);
//@property (nonatomic,assign)NSInteger progress;
//__string(selected);
//__string(officerisfollow);
//__string(total);
//__string(is_day_junior_school);
//__string(count_followed_school);


//@property (nonatomic,assign)NSInteger userId;
//@property (nonatomic,copy)NSArray *admission_officer;

//__string(square);

//__string(EName);‘


//is_teamwork
__string(is_teamwork);
__string(is_identification);

//is_identification
__string(full_address);
//英文名
__string(en_name);
//走读类型
__string(boarding_day);
//建校年份(long)
__string(setup_year);
//学校id（id long）
//@property (nonatomic,assign)NSInteger schoolid;
__string(schoolid);
//中文名
__string(cn_name);
//地址
__string(address);
//是否esl(int)
__string(isesl);
//学生数(long)
__string(total_students);
//ap课程数量(int)
__string(ap_count);
//sat平均分double
__string(sat_avg);
//男女校(int)
__string(student_sex_limit);


//__string(category);
//
//__string(city);
//
//__string(state);
//
//__string(nativeprice);
//__string(interprice);
//__string(satavg);
//
//__string(admission_officer_id);
//
//__string(setupyear);
//__string(web);
//__string(phone);
//__string(count_commented_school);
//__string(email);
//__string(Grade);
//__string(apcount);
//__string(isESL);
//__string(is_boarding_junior_school);
//__string(is_boarding_senior_school);
//__string(CName);
//__string(is_day_senior_school);
////__string(address);
//__string(schoolisfollow);
//__string(isPraise);
//@property (nonatomic,copy)NSArray*headImg;


@end
