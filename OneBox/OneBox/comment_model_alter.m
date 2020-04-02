//
//  comment_model_alter.m
//  OneBox
//
//  Created by 谢江新 on 15/5/10.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "comment_model_alter.h"

@implementation comment_model_alter
+(NSMutableArray *)parsingWithJsonDict:(NSDictionary *)dict
{
    NSMutableArray *returnArr=[[NSMutableArray alloc] init];
    NSArray *arr=[dict objectForKey:@"data"];
    for (NSDictionary *__dict in arr) {
        comment_model_alter *model=[self getdata:__dict];

        [returnArr addObject:model];
    }
    return returnArr;
}

+(comment_model_alter *)getdata:(NSDictionary *)dict
{
    comment_model_alter *model=[[comment_model_alter alloc] init];
    if([dict objectForKey:@"id"]!=[NSNull null])
    {
        model.comment_id=[[NSString alloc] initWithFormat:@"%ld",(long)[[dict objectForKey:@"id"] integerValue]];
    }else
    {
        model.comment_id=@"";
    }

    if([dict objectForKey:@"user"]!=[NSNull null])
    {
//        cell
//        is_server
        NSDictionary *__dict=[dict objectForKey:@"user"];

        if([__dict objectForKey:@"cell"]!=[NSNull null])
        {
            model.cell=[__dict  objectForKey:@"cell"];
        }else
        {
            model.cell=@"";
        }


        if([__dict objectForKey:@"ease_mob_username"]!=[NSNull null])
        {
            model.ease_mob_username=[__dict  objectForKey:@"ease_mob_username"];
        }else
        {
            model.ease_mob_username=@"";
        }

        if([__dict objectForKey:@"id"]!=[NSNull null])
        {
            model.user_id=[[NSString alloc] initWithFormat:@"%ld",(long)[[__dict objectForKey:@"id"] integerValue] ];
        }else
        {
            model.user_id=@"";
        }

        if([__dict objectForKey:@"username"]!=[NSNull null])
        {
            model.user_name=[[NSString alloc] initWithFormat:@"%@",[__dict objectForKey:@"username"]];
        }else
        {
            model.user_name=@"";
        }


        if([__dict objectForKey:@"avatar"]!=[NSNull null])
        {
            model.user_avatar=[[NSString alloc] initWithFormat:@"%@",[__dict objectForKey:@"avatar"]];
        }else
        {
            model.user_avatar=@"headImg_login1";
        }
    }else
    {
        model.user_id=@"";
        model.user_name=@"headImg_login1";
        model.user_name=@"";
    }


    if([dict objectForKey:@"content"]!=[NSNull null])
    {
        model.content=[dict objectForKey:@"content"];
    }else
    {
        model.content=@"";
    }


    if([dict objectForKey:@"created_at"]!=[NSNull null])
    {
        model.created_at=[dict objectForKey:@"created_at"];
    }else
    {
        model.created_at=@"";
    }

    if([dict objectForKey:@"votes_count"]!=[NSNull null])
    {
        model.votes_count=[[dict objectForKey:@"votes_count"] integerValue];
    }else
    {
        model.votes_count=0;
    }

    if([dict objectForKey:@"had_voted"]!=[NSNull null])
    {
        model.had_voted=[[dict objectForKey:@"had_voted"] boolValue];
    }else
    {
        model.had_voted=NO;
    }

    if([dict objectForKey:@"is_server"]!=[NSNull null])
    {
        model.is_server=[[dict objectForKey:@"is_server"] boolValue];
    }else
    {
        model.is_server=NO;
    }


    return model;
}


@end
