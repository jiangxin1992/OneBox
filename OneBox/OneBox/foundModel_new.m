 //
//  foundModel.m
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "foundModel_new.h"

@implementation foundModel_new
+(NSMutableArray *)parsingData:(NSDictionary *)_dict
{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];

    NSArray*arr=[_dict[@"data"] objectForKey:@"modules"];
//            type pic 没有等于nil，title没有等于空字符串
    if((_dict[@"data"]!=[NSNull null]))
    {
        for (NSDictionary *dict in arr) {
            foundModel_new *model = [[foundModel_new alloc]init];
            model.isAppear = @(NO);
            if([dict objectForKey:@"data"]!=[NSNull null])
            {
                if([[dict objectForKey:@"data"]isKindOfClass:[NSDictionary class]])
                {

                    model.data=[dict objectForKey:@"data"];
                }else
                {
                    model.data=[[NSDictionary alloc] init];
                }

            }else
            {
                model.data=[[NSDictionary alloc] init];
            }

            if([dict objectForKey:@"m_type"]!=[NSNull null])
            {
                if([[dict objectForKey:@"m_type"] isKindOfClass:[NSString class]])
                {
                    model.m_type=[dict objectForKey:@"m_type"];
                }else
                {
                    model.m_type=nil;
                }
            }else
            {
                model.m_type=nil;

            }

            if([dict objectForKey:@"title"]!=[NSNull null])
            {
                if([[dict objectForKey:@"title"] isKindOfClass:[NSString class]])
                {
                    model.title=[dict objectForKey:@"title"];
                }else
                {
                    model.title=@"";
                }
            }else
            {
                model.title=@"";

            }

            if([dict objectForKey:@"title_en"]!=[NSNull null])
            {
                if([[dict objectForKey:@"title_en"] isKindOfClass:[NSString class]])
                {
                    model.title_en=[dict objectForKey:@"title_en"];
                }else
                {
                    model.title_en=@"";
                }
            }else
            {
                model.title_en=@"";

            }

            if([dict objectForKey:@"pic"]!=[NSNull null])
            {
                if([[dict objectForKey:@"pic"] isKindOfClass:[NSString class]])
                {
                    model.pic=[dict objectForKey:@"pic"];
                }else
                {
                    model.pic=nil;
                }
            }else
            {
                model.pic=nil;

            }
            if([dict objectForKey:@"f_title_en"]!=[NSNull null])
            {
                if([[dict objectForKey:@"f_title_en"] isKindOfClass:[NSString class]])
                {
                    model.f_title_en=[dict objectForKey:@"f_title_en"];
                }else
                {
                    model.f_title_en=nil;
                }
            }else
            {
                model.f_title_en=nil;

            }
            if([dict objectForKey:@"f_title"]!=[NSNull null])
            {
                if([[dict objectForKey:@"f_title"] isKindOfClass:[NSString class]])
                {
                    model.f_title=[dict objectForKey:@"f_title"];
                }else
                {
                    model.f_title=nil;
                }
            }else
            {
                model.f_title=nil;

            }



            [dataArray addObject:model];
        }

    }
    return dataArray;

}

@end
