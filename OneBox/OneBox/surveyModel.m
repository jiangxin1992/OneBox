//
//  surveyModel.m
//  OneBox
//
//  Created by 谢江新 on 15/2/11.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "surveyModel.h"

@implementation surveyModel
+(surveyModel *)parsingWithJsonDataForModel:(NSDictionary *)dict
{

    surveyModel *model = [[surveyModel alloc]init];
    NSDictionary *_dict=[dict objectForKey:@"data"];
    JXLOG(@"%@",_dict);
    if([_dict objectForKey:@"full_address"]!=[NSNull null])
    {

        model.full_address=[_dict objectForKey:@"full_address"];
    }else
    {
        model.full_address=@"";
    }



    if([_dict objectForKey:@"en_name"]!=[NSNull null])
    {
        model.en_name=[_dict objectForKey:@"en_name"];
    }else
    {
        model.en_name=@"";
    }

    if([_dict objectForKey:@"boarding_day"]!=[NSNull null])
    {


            model.boarding_day=[_dict objectForKey:@"boarding_day"];


    }else
    {
//        没有nsnull的时候不显示
        model.boarding_day=@"";
    }

    if([_dict objectForKey:@"setup_year"]!=[NSNull null])
    {
        model.setup_year=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"setup_year"] longValue]];
    }else
    {

        model.setup_year=@"";
    }

    if([_dict objectForKey:@"schoolid"]!=[NSNull null])
    {
        model.schoolid=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"schoolid"] longValue]];
    }else
    {

        model.schoolid=@"1";
    }

    if([_dict objectForKey:@"cn_name"]!=[NSNull null])
    {
        model.cn_name=[_dict objectForKey:@"cn_name"];
    }else
    {

        model.cn_name=@"";
    }

    if([_dict objectForKey:@"address"]!=[NSNull null])
    {
        model.address=[_dict objectForKey:@"address"];
    }else
    {

        model.address=@"";
    }

    if([_dict objectForKey:@"isesl"]!=[NSNull null])
    {
        model.isesl=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"isesl"] integerValue]];
    }else
    {

        model.isesl=@"";

    }

    if([_dict objectForKey:@"total_students"]!=[NSNull null])
    {
        if([[_dict objectForKey:@"total_students"] integerValue]==0)
        {
             model.total_students=@"";
        }else
        {
            model.total_students=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"total_students"] integerValue]];
        }

    }else
    {

        model.total_students=@"";
    }

    if([_dict objectForKey:@"ap_count"]!=[NSNull null])
    {
        if([[_dict objectForKey:@"ap_count"] integerValue]==0)
        {
            model.ap_count=@"";
        }else
        {
            model.ap_count=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"ap_count"] integerValue]];
        }

    }else
    {

        model.ap_count=@"";
    }


    if([_dict objectForKey:@"sat_avg"]!=[NSNull null])
    {
        if([[_dict objectForKey:@"sat_avg"] integerValue]==0)
        {
            model.sat_avg=@"";
        }else
        {
            model.sat_avg=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"sat_avg"] integerValue]];
        }

    }else
    {

        model.sat_avg=@"";
    }

    if([_dict objectForKey:@"student_sex_limit"]!=[NSNull null])
    {
        model.student_sex_limit=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"student_sex_limit"] integerValue]];
    }else
    {

        model.student_sex_limit=@"";
    }

    return model;

}
@end
