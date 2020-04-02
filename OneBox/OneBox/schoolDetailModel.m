//
//  schoolDetailModel.m
//  OneBox
//
//  Created by 谢江新 on 15/5/7.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "schoolDetailModel.h"

@implementation schoolDetailModel
+(schoolDetailModel *)parsingWithJsonDataForModel:(NSDictionary *)dict
{
    JXLOG(@"dict==%@",dict);
    schoolDetailModel *model=[[schoolDetailModel alloc] init];
    if([dict objectForKey:@"school_ratings"]!=[NSNull null])
    {
        if([[dict objectForKey:@"school_ratings"] objectForKey:@"main"] ==[NSNull null])
        {
            model.ratings_avg=@"0";

        }else
        {
            model.ratings_avg=[[NSString alloc] initWithFormat:@"%.1f",[[[dict objectForKey:@"school_ratings"] objectForKey:@"main"] floatValue]];

        }

    }else
    {
        model.ratings_avg=@"0";
    }

    if([dict objectForKey:@"school_ratings"]!=[NSNull null])
    {

        if([dict objectForKey:@"school_ratings"]==nil)
        {
            model.school_ratings=nil;
        }else
        {
            model.school_ratings=[[NSMutableDictionary alloc] initWithDictionary:[dict objectForKey:@"school_ratings"]];
        }

    }else
    {
        model.school_ratings=nil;
    }


    if([dict objectForKey:@"logo_url"]!=[NSNull null])
    {
        model.logo_url=[dict objectForKey:@"logo_url"];
    }else
    {
        model.logo_url=nil;
    }
    if([dict objectForKey:@"is_junior"]==[NSNull null])
    {
        model.is_junior=@"0";
    }else
    {
        model.is_junior=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"is_junior"] longValue]];
    }
//    has_religiou
    if([dict objectForKey:@"has_religiou"]==[NSNull null])
    {
        model.has_religiou=@"0";
    }else
    {
        model.has_religiou=[[NSString alloc] initWithFormat:@"%d",[[dict objectForKey:@"has_religiou"] boolValue]];
    }


//    uniform
    if([dict objectForKey:@"uniform"]==[NSNull null])
    {
        model.uniform=@"0";
    }else
    {
        model.uniform=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"uniform"] longValue]];
    }


    if([dict objectForKey:@"is_senior"]==[NSNull null])
    {
        model.is_senior=@"0";
    }else
    {
        model.is_senior=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"is_senior"] longValue]];
    }
    
    if([dict objectForKey:@"admission_officers_json"]!=[NSNull null])
    {
        model.admission_officers_json=[dict objectForKey:@"admission_officers_json"];
    }else
    {
        model.admission_officers_json=[[NSArray alloc] init];
    }

    
    if([dict objectForKey:@"races"]!=[NSNull null])
    {
        model.races=[dict objectForKey:@"races"];
    }else
    {
        model.races=[[NSArray alloc] init];
    }

    if([dict objectForKey:@"school_preferreds"]!=[NSNull null])
    {
        model.school_preferreds=[dict objectForKey:@"school_preferreds"];
    }else
    {
        model.school_preferreds=[[NSArray alloc] init];

    }
    if([dict objectForKey:@"sports_images"]!=[NSNull null])
    {
        model.sports_images=[dict objectForKey:@"sports_images"];
    }else
    {
        model.sports_images=[[NSArray alloc] init];

    }


    if([dict objectForKey:@"act_avg"]!=[NSNull null])
    {
        model.act_avg=[[NSString alloc] initWithFormat:@"%ld",(long)[[dict objectForKey:@"act_avg"] integerValue]];
    }else
    {
        model.act_avg=@"0";
    }
    
    if([dict objectForKey:@"grade"]!=[NSNull null])
    {

        model.grade=[dict objectForKey:@"grade"];

    }else
    {
        model.grade=@"";
    }
//    square
    if([dict objectForKey:@"square"]!=[NSNull null])
    {

        if([[dict objectForKey:@"square"] isEqualToString:@""])
        {
            model.square=@"";
        }else
        {
            model.square=[dict objectForKey:@"square"];
        }


    }else
    {
        model.square=@"";
    }
//
//    class_size
    if([dict objectForKey:@"class_size"]!=[NSNull null])
    {

        model.class_size=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"class_size"] longValue]];

    }else
    {
        model.class_size=@"";
    }

    if([dict objectForKey:@"admission_officer_avatar"]!=[NSNull null])
    {

        model.admission_officer_avatar=[dict objectForKey:@"admission_officer_avatar"];

    }else
    {
        model.admission_officer_avatar=@"";
    }
//asian_students
    if([dict objectForKey:@"asian_students"]!=[NSNull null])
    {

        model.asian_students=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"asian_students"] longValue]];

    }else
    {
        model.asian_students=@"";
    }

    if([dict objectForKey:@"latitude"]!=[NSNull null])
    {

        model.latitude=[dict objectForKey:@"latitude"];

    }else
    {
        model.latitude=@"";
    }

    if([dict objectForKey:@"longtitude"]!=[NSNull null])
    {

        model.longtitude=[dict objectForKey:@"longtitude"];

    }else
    {
        model.longtitude=@"";
    }

    if([dict objectForKey:@"en_description"]!=[NSNull null])
    {

        model.en_description=[dict objectForKey:@"en_description"];

    }else
    {
        model.en_description=@"";
    }
    if([dict objectForKey:@"share_link"]!=[NSNull null])
    {

        model.share_link=[dict objectForKey:@"share_link"];

    }else
    {
        model.share_link=@"";
    }
    
    if([dict objectForKey:@"religiou_name"]!=[NSNull null])
    {
        
        model.religiou_name=[dict objectForKey:@"religiou_name"];
        
    }else
    {
        model.religiou_name=@"";
    }
    
    if([dict objectForKey:@"areal_type"]!=[NSNull null])
    {
        
        model.areal_type=[dict objectForKey:@"areal_type"];
        
    }else
    {
        model.areal_type=@"";
    }
    

    if([dict objectForKey:@"en_state"]!=[NSNull null])
    {

        model.en_state=[dict objectForKey:@"en_state"];

    }else
    {
        model.en_state=@"";
    }
    if([dict objectForKey:@"en_city"]!=[NSNull null])
    {

        model.en_city=[dict objectForKey:@"en_city"];

    }else
    {
        model.en_city=@"";
    }

    if([dict objectForKey:@"full_address"]!=[NSNull null])
    {

        model.full_address=[dict objectForKey:@"full_address"];

    }else
    {
        model.full_address=@"";
    }
    if([dict objectForKey:@"city"]!=[NSNull null])
    {

        model.city=[dict objectForKey:@"city"];

    }else
    {
        model.city=@"";
    }
    if([dict objectForKey:@"cn_state"]!=[NSNull null])
    {

        model.cn_state=[dict objectForKey:@"cn_state"];

    }else
    {
        model.cn_state=@"";
    }
    if([dict objectForKey:@"email"]!=[NSNull null])
    {

        model.email=[dict objectForKey:@"email"];

    }else
    {
        model.email=@"";
    }
    if([dict objectForKey:@"web"]!=[NSNull null])
    {

        model.web=[dict objectForKey:@"web"];

    }else
    {
        model.web=@"";
    }

    if([dict objectForKey:@"phone"]!=[NSNull null])
    {

        model.phone=[dict objectForKey:@"phone"];

    }else
    {
        model.phone=@"";
    }



    if([dict objectForKey:@"is_teamwork"]!=[NSNull null])
    {

        model.is_teamwork=[[NSString alloc] initWithFormat:@"%ld",(long)[[dict objectForKey:@"is_teamwork"] integerValue]];

    }else
    {
        model.is_teamwork=[[NSString alloc] initWithFormat:@"%d",0];
    }


    if([dict objectForKey:@"is_identification"]!=[NSNull null])
    {

        model.is_identification=[[NSString alloc] initWithFormat:@"%ld",(long)[[dict objectForKey:@"is_identification"] integerValue]];

    }else
    {
        model.is_identification=[[NSString alloc] initWithFormat:@"%d",0];
    }




    if([dict objectForKey:@"edu_certifications_json"]!=[NSNull null])
    {

        model.edu_certifications_json=[dict objectForKey:@"edu_certifications_json"];

    }else
    {
        model.edu_certifications_json=[[NSArray alloc] init];
    }
    if([dict objectForKey:@"feature_images"]!=[NSNull null])
    {
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        for (NSDictionary *__dict in [dict objectForKey:@"feature_images"]) {
            [arr addObject:[__dict objectForKey:@"url"]];
        }
        model.feature_images=arr;

    }else
    {
        model.feature_images=[[NSArray alloc] init];
    }

    if([dict objectForKey:@"video_addrs"]!=[NSNull null])
    {
        if([dict objectForKey:@"video_addrs"]!=nil&&[[dict objectForKey:@"video_addrs"] isKindOfClass:[NSArray class]]){
            model.feature_video=[dict objectForKey:@"video_addrs"];
        }else
        {
            model.feature_video=[[NSArray alloc] init];
        }
    }else
    {
        model.feature_video=[[NSArray alloc] init];
    }


    if([dict objectForKey:@"en_name"]!=[NSNull null])
    {
        model.en_name=[dict objectForKey:@"en_name"];
    }else
    {
        model.en_name=@"";
    }

    if([dict objectForKey:@"cn_name"]!=[NSNull null])
    {
        model.cn_name=[dict objectForKey:@"cn_name"];
    }else
    {
        model.cn_name=@"";

    }

    if([dict objectForKey:@"setup_year"]!=[NSNull null])
    {
        model.setup_year=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"setup_year"] longValue]];
    }else
    {
        model.setup_year=@"";

    }


    if([dict objectForKey:@"student_sex_limit"]!=[NSNull null])
    {
        model.student_sex_limit=[[NSString alloc] initWithFormat:@"%d",[[dict objectForKey:@"student_sex_limit"] intValue]];
    }else
    {
        model.student_sex_limit=@"";
    }

    if([dict objectForKey:@"boarding_day"]!=[NSNull null])
    {

        model.boarding_day=[dict objectForKey:@"boarding_day"];
    }else
    {
        model.boarding_day=@"";
    }

    if([dict objectForKey:@"isesl"]!=[NSNull null])
    {
        model.isesl=[[NSString alloc] initWithFormat:@"%d",[[dict objectForKey:@"isesl"] intValue]];
    }else
    {
        model.isesl=@"";
    }
    if([dict objectForKey:@"follows_count"]!=[NSNull null])
    {
        model.follows_count=[[dict objectForKey:@"follows_count"] integerValue];
    }else
    {
        model.follows_count=0;
    }

    if([dict objectForKey:@"follows_count"]!=[NSNull null])
    {
        model.follows_count=[[dict objectForKey:@"follows_count"] integerValue];
    }else
    {
        model.follows_count=0;
    }

    if([dict objectForKey:@"votes_count"]!=[NSNull null])
    {
        model.votes_count=[[dict objectForKey:@"votes_count"] integerValue];
    }else
    {
        model.votes_count=0;
    }

    if([dict objectForKey:@"ratings_count"]!=[NSNull null])
    {
        model.ratings_count=[[dict objectForKey:@"ratings_count"] integerValue];
    }else
    {
        model.ratings_count=0;
    }



    if([dict objectForKey:@"had_followed"]!=[NSNull null])
    {
        model.had_followed=[[dict objectForKey:@"had_followed"] boolValue];
    }else
    {
        model.had_followed=NO;
    }


    if([dict objectForKey:@"had_voted"]!=[NSNull null])
    {
        model.had_voted=[[dict objectForKey:@"had_voted"] boolValue];
    }else
    {
        model.had_voted=NO;
    }

    if([dict objectForKey:@"had_rating"]!=[NSNull null])
    {
        model.had_rating=[[dict objectForKey:@"had_rating"] boolValue];
    }else
    {
        model.had_rating=NO;
    }

    if([dict objectForKey:@"rating_score"]!=[NSNull null])
    {
        model.rating_score=[[dict objectForKey:@"rating_score"] floatValue];
    }else
    {
        model.rating_score=0.0f;
    }

    if([dict objectForKey:@"description"]!=[NSNull null])
    {
        model.miaoshu=[dict objectForKey:@"description"];
    }else
    {
        model.miaoshu=@"";
    }

    if([dict objectForKey:@"total_students"]!=[NSNull null])
    {
        model.total_students=[[dict objectForKey:@"total_students"] integerValue];
    }else
    {
        model.total_students=0;
    }

    if([dict objectForKey:@"ap_count"]!=[NSNull null])
    {
        model.ap_count=[[NSString alloc] initWithFormat:@"%ld",(long)[[dict objectForKey:@"ap_count"] integerValue]];
    }else
    {
        model.ap_count=@"0";
    }

    if([dict objectForKey:@"sat_avg"]!=[NSNull null])
    {
        model.sat_avg=[[NSString alloc] initWithFormat:@"%ld",(long)[[dict objectForKey:@"sat_avg"] integerValue]];
    }else
    {
        model.sat_avg=@"0";
    }


    if([dict objectForKey:@"ap_course_list"]!=[NSNull null])
    {
        model.ap_course_list=[dict objectForKey:@"ap_course_list"] ;
    }else
    {
        model.ap_course_list=[[NSArray alloc] init];
    }


    if([dict objectForKey:@"extra_en_activity_list"]!=[NSNull null])
    {
        model.extra_en_activity_list=[dict objectForKey:@"extra_en_activity_list"] ;
    }else
    {
        model.extra_en_activity_list=[[NSArray alloc] init];
    }
    if([dict objectForKey:@"extra_en_organization_list"]!=[NSNull null])
    {
        model.extra_en_organization_list=[dict objectForKey:@"extra_en_organization_list"] ;
    }else
    {
        model.extra_en_organization_list=[[NSArray alloc] init];
    }

    if([dict objectForKey:@"en_ap_course_list"]!=[NSNull null])
    {
        model.en_ap_course_list=[dict objectForKey:@"en_ap_course_list"] ;
    }else
    {
        model.en_ap_course_list=[[NSArray alloc] init];
    }
    if([dict objectForKey:@"international_students"]!=[NSNull null])
    {
        model.international_students=[[dict objectForKey:@"international_students"] integerValue];
    }else
    {
        model.international_students=0;
    }

    if([dict objectForKey:@"teachers_count"]!=[NSNull null])
    {
        model.teachers_count=[[dict objectForKey:@"teachers_count"] integerValue];
    }else
    {
        model.teachers_count=0;
    }

    if([dict objectForKey:@"grade_number"]!=[NSNull null])
    {
        model.grade_number=[dict objectForKey:@"grade_number"] ;
    }else
    {
        model.grade_number=[[NSDictionary alloc] init];
    }
    

    if([dict objectForKey:@"ranks"]!=[NSNull null])
    {
        model.ranks=[dict objectForKey:@"ranks"] ;
    }else
    {
        model.ranks=[[NSDictionary alloc] init];
    }

    if([dict objectForKey:@"extra_organization_list"]!=[NSNull null])
    {
        model.extra_organization_list=[dict objectForKey:@"extra_organization_list"] ;
    }else
    {
        model.extra_organization_list=[[NSArray alloc] init];
    }

    model.extra_organization_list=[dict objectForKey:@"extra_organization_list"] ;
    if([dict objectForKey:@"extra_organization_list"]!=[NSNull null])
    {
        model.extra_organization_list=[dict objectForKey:@"extra_organization_list"] ;
    }else
    {
        model.extra_organization_list=[[NSArray alloc] init];
    }
    
    if([dict objectForKey:@"extra_activity_list"]!=[NSNull null])
    {
        model.extra_activity_list=[dict objectForKey:@"extra_activity_list"] ;
    }else
    {
        model.extra_activity_list=[[NSArray alloc] init];
    }
    
    if([dict objectForKey:@"school_skus"]!=[NSNull null])
    {
        model.school_skus=[dict objectForKey:@"school_skus"] ;
    }else
    {
        model.school_skus=[[NSArray alloc] init];
    }
    
    
    return model;
}
@end
