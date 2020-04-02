//
//  chooseModel.m
//  OneBox
//
//  Created by 谢江新 on 15/5/15.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "chooseModel.h"

@implementation chooseModel
+(NSMutableArray *)parsingWithJsonDataForModel:(NSDictionary *)dict
{
    NSMutableArray *mutablearr=[[NSMutableArray alloc] init];
    NSArray *array=[[dict objectForKey:@"data"] objectForKey:@"order_schools"];
    //    order_schools_count
    //    follow_schools_count;
    //@property (nonatomic,copy)NSArray *prices;



    for (NSDictionary *_dict in array) {
        chooseModel *model=[[chooseModel alloc] init];


        if([_dict objectForKey:@"school_id"]!=[NSNull null])
        {
            model.sid=[[_dict objectForKey:@"school_id"] integerValue];

        }else
        {
            model.sid=1;
            
        }
        if([_dict objectForKey:@"cn_state"]!=[NSNull null])
        {
            model.cn_state=[_dict objectForKey:@"cn_state"];

        }else
        {
            model.cn_state=@"";
            
        }
        if([_dict objectForKey:@"prices"]!=[NSNull null])
        {
            model.prices=[_dict objectForKey:@"prices"];

        }else
        {
            model.prices=[[NSArray alloc] init];

        }

        if([_dict objectForKey:@"full_address"]!=[NSNull null])
        {
            model.full_address=[_dict objectForKey:@"full_address"];
        }else
        {
            model.full_address=@"";
        }

        if([_dict objectForKey:@"step_no"]!=[NSNull null])
        {
            model.step_no=[[_dict objectForKey:@"step_no"] integerValue];
        }else
        {
            model.step_no=-1;
        }

        if([_dict objectForKey:@"setup_year"]!=[NSNull null])
        {
            model.setup_year=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"setup_year"] longValue]];
        }else
        {
            model.setup_year=@"";
        }
        if([_dict objectForKey:@"en_name"]!=[NSNull null])
        {
            model.en_name=[_dict objectForKey:@"en_name"];
        }else
        {
            model.en_name=@"";
        }
        if([_dict objectForKey:@"cn_name"]!=[NSNull null])
        {
            model.cn_name=[_dict objectForKey:@"cn_name"];
        }else
        {
            model.cn_name=@"";
        }
        if([_dict objectForKey:@"cn_city"]!=[NSNull null])
        {
            model.cn_city=[_dict objectForKey:@"cn_city"];
        }else
        {
            model.cn_city=@"";
        }
        if([_dict objectForKey:@"school_address"]!=[NSNull null])
        {
            model.school_address=[_dict objectForKey:@"school_address"];
        }else
        {
            model.school_address=@"";
        }
        if([_dict objectForKey:@"student_sex_limit"]!=[NSNull null])
        {
            model.student_sex_limit=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"student_sex_limit"] integerValue]];
        }else
        {
            model.student_sex_limit=@"1";
        }

        if([_dict objectForKey:@"boarding_day"]!=[NSNull null])
        {
            model.boarding_day=[_dict objectForKey:@"boarding_day"];
        }else
        {
            model.boarding_day=@"boarding_day";
        }
        if([_dict objectForKey:@"isesl"]!=[NSNull null])
        {
            model.isesl=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"isesl"] integerValue]];
        }else
        {
            model.isesl=@"1";
        }

        if([_dict objectForKey:@"total_students"]!=[NSNull null])
        {
            model.total_students=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"total_students"] integerValue]];
        }else
        {
            model.total_students=@"0";
        }
        if([_dict objectForKey:@"ap_count"]!=[NSNull null])
        {
            model.ap_count=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"ap_count"] integerValue]];
        }else
        {
            model.ap_count=@"0";
        }
        if([_dict objectForKey:@"sat_avg"]!=[NSNull null])
        {
            model.sat_avg=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"sat_avg"] integerValue]];
        }else
        {
            model.sat_avg=@"0";
        }


        //        if([_dict objectForKey:@"prices"]!=[NSNull null])
        //        {
        //            NSArray *_arr=[_dict objectForKey:@"prices"];
        //            if(_arr.count)
        //            {
        //                NSDictionary*__dict=_arr[0];
        //                if([__dict objectForKey:@"price"]!=[NSNull null])
        //                {
        //                    model.tuition=[[NSString alloc] initWithFormat:@"%d",[[__dict objectForKey:@"price"] integerValue]];
        //                }else
        //                {
        //                    model.tuition=@"0";
        //                }
        //            }else
        //            {
        //                model.tuition=@"0";
        //            }
        //
        //        }else
        //        {
        //            model.tuition=@"0";
        //        }
        //
        //        model.alimony=@"2048";
        if([_dict objectForKey:@"goal_id"]!=[NSNull null])
        {
            model.goal_id=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"id"] longValue]];
        }else
        {
            model.goal_id=@"1";
        }
        
        [mutablearr addObject:model];
    }
    
    
    //学费
    //    __string(tuition);
    //    //生活费
    //    __string(alimony);
    
    
    
    
    return mutablearr;
    
}
@end
