 //
//  foundModel.m
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "foundModel.h"

@implementation foundModel
+(NSMutableArray *)parsingData:(NSDictionary *)_dict
{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
//    &&()
//    ![_dict[@"list"] isEqualToString:@"0"];
    
    NSArray*arr=_dict[@"data"];
//    &&(![_dict[@"list"] isKindOfClass:[NSString class]])
    if((_dict[@"data"]!=[NSNull null]))
    {
        for (NSDictionary *dict in arr) {
            foundModel *model = [[foundModel alloc]init];
            //KVC
//            [model setValuesForKeysWithDictionary:dict];

//is_order_school

            if(dict[@"rank"]!=[NSNull null])
            {
                model.rank=[[NSString alloc] initWithFormat:@"%ld",(long)[dict[@"rank"] integerValue]];
            }else
            {
                model.rank=@"";
            }


            if(dict[@"en_name"]!=[NSNull null])
            {
                model.en_name=dict[@"en_name"];
            }else
            {
                model.en_name=@"";
            }

            if(dict[@"thumb_image_url"]!=[NSNull null])
            {
                model.thumb_image_url=dict[@"thumb_image_url"];
            }else
            {
                model.thumb_image_url=@"";
            }

            if(dict[@"is_order_school"]!=[NSNull null])
            {
            model.is_order_school=[dict[@"is_order_school"] integerValue];
                if(model.is_order_school==0)
                {
                    model.if_order_school=NO;

                }else
                {
                    model.if_order_school=YES;
                }
            }else
            {
                model.is_order_school=0;
                model.if_order_school=NO;
            }

            model.isapp=NO;
            if(dict[@"setup_year"]!=[NSNull null])
            {
                model.setup_year=[[NSString alloc] initWithFormat:@"%ld",[dict[@"setup_year"] longValue]];
            }else
            {
                model.setup_year=@"";
            }

            if(dict[@"cn_name"]!=[NSNull null])
            {
                model.cn_name=dict[@"cn_name"];
            }else
            {
                model.cn_name=@"";
            }

            if(dict[@"city"]!=[NSNull null])
            {
                model.city=dict[@"city"];
            }else
            {
                model.city=@"";
            }

            if(dict[@"web"]!=[NSNull null])
            {
                model.web=dict[@"web"];
            }else
            {
                model.web=@"";
            }

            if(dict[@"state"]!=[NSNull null])
            {
                model.state=dict[@"state"];
            }else
            {
                model.state=@"";
            }

            if(dict[@"total_students"]!=[NSNull null])
            {
                model.total_students=[[NSString alloc] initWithFormat:@"%ld",[dict[@"total_students"] longValue]];
            }else
            {
                model.total_students=@"";
            }

            if(dict[@"ap_count"]!=[NSNull null])
            {
                model.ap_count=[[NSString alloc] initWithFormat:@"%ld",[dict[@"ap_count"] integerValue]];
            }else
            {
                model.ap_count=@"";
            }

            if(dict[@"id"]!=[NSNull null])
            {
                model.sid=dict[@"id"];
            }else
            {
                model.sid=@"";
            }

            if(dict[@"grade"]!=[NSNull null])
            {
                model.grade=dict[@"grade"];
            }else
            {
                model.grade=@"";
            }


            [dataArray addObject:model];
        }

    }
    return dataArray;

}

@end
