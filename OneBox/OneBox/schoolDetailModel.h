//
//  schoolDetailModel.h
//  OneBox
//
//  Created by 谢江新 on 15/5/7.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "baseModelJX.h"

@interface schoolDetailModel : baseModelJX
+(schoolDetailModel *)parsingWithJsonDataForModel:(NSDictionary *)dict;

/** 取值范围有 ["", "city"城市, "outskirt"郊区, "town"城镇, "village"乡村]*/
__string(areal_type);

/** 宗教名称*/
__string(religiou_name);

/** 大学榜单排名 business_insider(Business Insider 排名)  niche(Niche School 排名)  prep_review(Prep Review 排名)*/
__dict(ranks);

/** 种族数组*/
__array(races);

@property (nonatomic,copy)NSMutableDictionary *school_ratings;
__string(share_link);
__string(square);
__string(asian_students);
__string(has_religiou);
__string(uniform);
__string(is_senior);
__string(is_junior);


@property (nonatomic,copy) NSArray *admission_officers_json;
__string(act_avg);
__string(grade);
__string(phone);
__string(email);
__string(web);
__string(latitude);
__string(longtitude);
__string(full_address);
__string(city);
__string(cn_state);
__string(en_city);
__string(en_state);
__string(en_description);

@property (nonatomic,copy)NSArray *school_preferreds;
//课外活动图片
@property (nonatomic,copy)NSArray *sports_images;
//班级大小
__string(class_size);
//是否合作
__string(is_teamwork);
//是否认证
__string(is_identification);
//学校荣誉
@property (nonatomic,copy)NSArray*edu_certifications_json;
//学校的照片
@property (nonatomic,copy)NSArray*feature_images;
//学校的视频
@property (nonatomic,copy)NSArray*feature_video;
//学校的英文名字
__string(en_name);
//学校的中文名字
__string(cn_name);
//建校年份(long)
__string(setup_year);
//混校类型(int)
__string(student_sex_limit);
//寄宿走读
__string(boarding_day);
//是否esl(int)
__string(isesl);
__string(admission_officer_avatar);
__string(logo_url);

//收藏数量(int)
@property (nonatomic,assign) NSInteger follows_count;

//点赞数(int)
@property (nonatomic,assign) NSInteger votes_count;
//当前评分数(int)
@property (nonatomic,assign) NSInteger ratings_count;

//平均评分(cgfloat)
__string(ratings_avg);
//是否收藏(bool)
@property (nonatomic,assign) BOOL had_followed;
//是否点赞(bool)
@property (nonatomic,assign) BOOL had_voted;
//是否评分(bool)
@property (nonatomic,assign) BOOL had_rating;
//当前用户对学校评分(cgfloat)
@property (nonatomic,assign) CGFloat rating_score;

//学校描述（description）
@property (nonatomic,copy) NSString *miaoshu;
//总学生人数(int)
@property (nonatomic,assign) NSInteger total_students;

//ap课程数(int)
__string(ap_count);

//sat平均分(cgfloat)
__string(sat_avg);

//ap课程列表
@property (nonatomic,copy)NSArray *ap_course_list;
@property (nonatomic,copy)NSArray *extra_en_activity_list;
@property (nonatomic,copy)NSArray *extra_en_organization_list;
@property (nonatomic,copy)NSArray *en_ap_course_list;

//国际生人数（int）
@property (nonatomic,assign) NSInteger international_students;

//老师人数（int）
@property (nonatomic,assign) NSInteger teachers_count;

//年级信息(NSDictionary)
@property (nonatomic,copy) NSDictionary *grade_number;
//课外组织列表
@property (nonatomic,copy)NSArray *extra_organization_list;
//课外活动列表
@property (nonatomic,copy)NSArray *extra_activity_list;
//学费inter_or_native(native，international)
@property (nonatomic,copy)NSArray *school_skus;

@end
