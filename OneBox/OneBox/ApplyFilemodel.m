//
//  ApplyFilemodel.m
//  OneBox
//
//  Created by 谢江新 on 15/5/19.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ApplyFilemodel.h"

@implementation ApplyFilemodel
+(ApplyFilemodel *)parsingWithJsonDataForModel:(NSDictionary *)dict
{
    ApplyFilemodel *model=[[ApplyFilemodel alloc] init];
    NSDictionary *_dict=[[dict objectForKey:@"data"] objectForKey:@"documents"];

    if([_dict objectForKey:@"study_reports"]!=[NSNull null])
    {
        model.study_reports=[[_dict objectForKey:@"study_reports"] integerValue];
    }else
    {
        model.study_reports=0;
    }
    if([_dict objectForKey:@"school_reports"]!=[NSNull null])
    {
        model.school_reports=[[_dict objectForKey:@"school_reports"] integerValue];
    }else
    {
        model.school_reports=0;
    }
    if([_dict objectForKey:@"school_apply_table"]!=[NSNull null])
    {
        model.school_apply_table=[[_dict objectForKey:@"school_apply_table"] integerValue];
    }else
    {
        model.school_apply_table=0;
    }

    if([_dict objectForKey:@"recommend_letter"]!=[NSNull null])
    {
        model.recommend_letter=[[_dict objectForKey:@"recommend_letter"] integerValue];
    }else
    {
        model.recommend_letter=0;
    }

    if([_dict objectForKey:@"reading"]!=[NSNull null])
    {
        model.reading=[[_dict objectForKey:@"reading"] integerValue];
    }else
    {
        model.reading=0;
    }
    if([_dict objectForKey:@"passport"]!=[NSNull null])
    {
        model.passport=[[_dict objectForKey:@"passport"] integerValue];
    }else
    {
        model.passport=0;
    }
    if([_dict objectForKey:@"bank_savings"]!=[NSNull null])
    {
        model.bank_savings=[[_dict objectForKey:@"bank_savings"] integerValue];
    }else
    {
        model.bank_savings=0;
    }

    if([_dict objectForKey:@"diploma"]!=[NSNull null])
    {
        model.diploma=[[_dict objectForKey:@"diploma"] integerValue];
    }else
    {
        model.diploma=0;
    }
    
    if([_dict objectForKey:@"test_score"]!=[NSNull null])
    {
        model.test_score=[[_dict objectForKey:@"test_score"] integerValue];
    }else
    {
        model.test_score=0;
    }

    if([_dict objectForKey:@"is_reading"]!=[NSNull null])
    {
        model.is_reading=[[_dict objectForKey:@"is_reading"] integerValue];
    }else
    {
        model.is_reading=0;
    }
    
    if([_dict objectForKey:@"ds160"]!=[NSNull null])
    {
        model.ds160=[[_dict objectForKey:@"ds160"] integerValue];
    }else
    {
        model.ds160=0;
    }
    
    if([_dict objectForKey:@"visa_pay"]!=[NSNull null])
    {
        model.visa_pay=[[_dict objectForKey:@"visa_pay"] integerValue];
    }else
    {
        model.visa_pay=0;
    }
    if([_dict objectForKey:@"sevis_fee_pay"]!=[NSNull null])
    {
        model.sevis_fee_pay=[[_dict objectForKey:@"sevis_fee_pay"] integerValue];
    }else
    {
        model.sevis_fee_pay=0;
    }
    
    if([_dict objectForKey:@"a120"]!=[NSNull null])
    {
        model.a120=[[_dict objectForKey:@"a120"] integerValue];
    }else
    {
        model.a120=0;
    }

    if([_dict objectForKey:@"picture"]!=[NSNull null])
    {
        model.picture=[[_dict objectForKey:@"picture"] integerValue];
    }else
    {
        model.picture=0;
    }

    if([_dict objectForKey:@"income"]!=[NSNull null])
    {
        model.income=[[_dict objectForKey:@"income"] integerValue];
    }else
    {
        model.income=0;
    }

    if([_dict objectForKey:@"person_tax"]!=[NSNull null])
    {
        model.person_tax=[[_dict objectForKey:@"person_tax"] integerValue];
    }else
    {
        model.person_tax=0;
    }
    
    if([_dict objectForKey:@"salary"]!=[NSNull null])
    {
        model.salary=[[_dict objectForKey:@"salary"] integerValue];
    }else
    {
        model.salary=0;
    }
    
    if([_dict objectForKey:@"house"]!=[NSNull null])
    {
        model.house=[[_dict objectForKey:@"house"] integerValue];
    }else
    {
        model.house=0;
    }
    
    if([_dict objectForKey:@"household"]!=[NSNull null])
    {
        model.household=[[_dict objectForKey:@"household"] integerValue];
    }else
    {
        model.household=0;
    }

    if([_dict objectForKey:@"manage_notice"]!=[NSNull null])
    {
        model.manage_notice=[[_dict objectForKey:@"manage_notice"] integerValue];
    }else
    {
        model.manage_notice=0;
    }


    return model;
}
@end
