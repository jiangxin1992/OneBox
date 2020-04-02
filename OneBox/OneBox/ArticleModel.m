 //
//  ArticleModel.m
//  OneBox
//
//  Created by 谢江新 on 15/2/6.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

+(NSMutableArray *)parsingData:(NSDictionary *)_dict
{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
//            type pic 没有等于nil，title没有等于空字符串
    if((_dict[@"data"]!=[NSNull null]))
    {
        NSArray*arr=_dict[@"data"] ;
        for (NSDictionary *dict in arr) {
            ArticleModel *model = [[ArticleModel alloc]init];
            if([dict objectForKey:@"id"]!=[NSNull null])
            {
                if([dict objectForKey:@"id"]==nil)
                {
                    model.m_id=nil;
                }else
                {
                     model.m_id=[[NSString alloc] initWithFormat:@"%ld",[[dict objectForKey:@"id"] longValue]];
                }
            }else
            {
                model.m_id=nil;
            }

            model.isapp=NO;
            if([dict objectForKey:@"title"]!=[NSNull null])
            {
                if([dict objectForKey:@"title"]==nil)
                {
                    model.title=@"";

                }else
                {
                    model.title=[dict objectForKey:@"title"];
                }

            }else
            {
                model.title=@"";
            }

            if([dict objectForKey:@"thumb_url"]!=[NSNull null])
            {
                if([dict objectForKey:@"thumb_url"]==nil)
                {
                    model.thumb_url=@"";

                }else
                {
                    model.thumb_url=[dict objectForKey:@"thumb_url"];
                }

            }else
            {
                model.thumb_url=@"";
            }

            if([dict objectForKey:@"desc"]!=[NSNull null])
            {
                if([dict objectForKey:@"desc"]==nil)
                {
                    model.desc=@"";

                }else
                {
                    model.desc=[dict objectForKey:@"desc"];
                }
            }else
            {
                model.desc=@"";
            }

            [dataArray addObject:model];
        }

    }
    return dataArray;

}

@end
