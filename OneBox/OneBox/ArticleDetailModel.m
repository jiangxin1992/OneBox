//
//  schoolDetailModel.m
//  OneBox
//
//  Created by 谢江新 on 15/5/7.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "ArticleDetailModel.h"

@implementation ArticleDetailModel
+(ArticleDetailModel *)parsingWithJsonDataForModel:(NSDictionary *)dict
{
    NSDictionary *_dict=[dict objectForKey:@"data"];
    ArticleDetailModel *model=[[ArticleDetailModel alloc] init];
    //    __string(content);
    if([_dict objectForKey:@"app_html_url"]!=[NSNull null])
    {
        if([_dict objectForKey:@"app_html_url"]!=nil)
        {
            model.app_html_url=[_dict objectForKey:@"app_html_url"];
        }else
        {
            model.app_html_url=@"";
        }

    }else
    {
        model.app_html_url=@"";
    }
//
    if([_dict objectForKey:@"share_link"]!=[NSNull null])
    {
        if([_dict objectForKey:@"share_link"]!=nil)
        {
            model.share_link=[_dict objectForKey:@"share_link"];
        }else
        {
            model.share_link=@"";
        }

    }else
    {
        model.share_link=@"";
    }
//    __string(m_id);//id long
    if([_dict objectForKey:@"id"]!=[NSNull null])
    {
        if([_dict objectForKey:@"id"]!=nil)
        {
            model.m_id=[[NSString alloc] initWithFormat:@"%ld",[[_dict objectForKey:@"id"] longValue]];
            
        }else
        {
            model.m_id=nil;
        }

    }else
    {
        model.m_id=nil;
    }

//    __string(created_at);//str
    if([_dict objectForKey:@"created_at"]!=[NSNull null])
    {
        if([_dict objectForKey:@"created_at"]!=nil)
        {

            NSString *title=[_dict objectForKey:@"created_at"];

            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];

            NSDate *date = [dateFormat dateFromString:title];

            [dateFormat setDateFormat:@"YY/MM/dd"];
            NSString *dateTime = [dateFormat stringFromDate:date];

            model.created_at=dateTime;
        }else
        {
            model.created_at=@"";
        }
    }else
    {
        model.created_at=@"";
    }

//    __string(title);
    if([_dict objectForKey:@"title"]!=[NSNull null])
    {
        if([_dict objectForKey:@"title"]!=nil)
        {
            model.title=[_dict objectForKey:@"title"];
        }else
        {
            model.title=@"";
        }
    }else
    {
        model.title=@"";
    }

//    @property (nonatomic,assign)BOOL had_voted;
    if([_dict objectForKey:@"had_voted"]!=[NSNull null])
    {
        if([_dict objectForKey:@"had_voted"]!=nil)
        {
            model.had_voted=[[_dict objectForKey:@"had_voted"] boolValue];
        }else
        {
            model.had_voted=NO;
        }
    }else
    {
        model.had_voted=NO;
    }
//    @property (nonatomic,assign)NSInteger votes_count;
    if([_dict objectForKey:@"votes_count"]!=[NSNull null])
    {
        if([_dict objectForKey:@"votes_count"]!=nil)
        {
            model.votes_count=[[_dict objectForKey:@"votes_count"] integerValue];
        }else
        {
            model.votes_count=0;
        }
    }else
    {
        model.votes_count=0;
    }
//    @property (nonatomic,assign)NSInteger follows_count;
    if([_dict objectForKey:@"follows_count"]!=[NSNull null])
    {
        if([_dict objectForKey:@"follows_count"]!=nil)
        {
            model.follows_count=[[_dict objectForKey:@"follows_count"] integerValue];
        }else
        {
            model.follows_count=0;
        }
    }else
    {
        model.follows_count=0;
    }
//    @property (nonatomic,assign)NSInteger comments_count;
    if([_dict objectForKey:@"comments_count"]!=[NSNull null])
    {
        if([_dict objectForKey:@"comments_count"]!=nil)
        {
            model.comments_count=[[_dict objectForKey:@"comments_count"] integerValue];
        }else
        {
            model.comments_count=0;
        }
    }else
    {
        model.comments_count=0;
    }
//    @property (nonatomic,assign)BOOL had_followed;
    if([_dict objectForKey:@"had_followed"]!=[NSNull null])
    {
        if([_dict objectForKey:@"had_followed"]!=nil)
        {
            model.had_followed=[[_dict objectForKey:@"had_followed"] boolValue];
        }else
        {
            model.had_followed=0;
        }
    }else
    {
        model.had_followed=0;
    }
//    @property (nonatomic,copy)NSDictionary *user;
    if([_dict objectForKey:@"user"]!=[NSNull null])
    {
        if([_dict objectForKey:@"user"]!=nil)
        {
            model.user=[_dict objectForKey:@"user"];
        }else
        {
            model.user=nil;
        }
    }else
    {
        model.user=nil;
    }

    
    return model;
}
@end
