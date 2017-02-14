//
//  graduationModel.m
//  OneBox
//
//  Created by 谢江新 on 15/2/22.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "graduationModel.h"

@implementation graduationModel
+(NSMutableArray *)parsingWithJsonArr:(NSArray *)arr
{
    NSMutableArray *mutableArr=[[NSMutableArray alloc] init];
    for (NSDictionary *_dict in arr) {
        graduationModel *model=[[graduationModel alloc] init];
        if([_dict objectForKey:@"rank"]==[NSNull null])
        {
            model.rank=@"";
        }else
        {
            model.rank=[[NSString alloc] initWithFormat:@"%ld",(long)[[_dict objectForKey:@"rank"] integerValue]];
        }

        if([_dict objectForKey:@"cn_name"]==[NSNull null])
        {
            model.cn_name=@"";
        }else
        {
            model.cn_name=[_dict objectForKey:@"cn_name"];
        }
        if([_dict objectForKey:@"en_name"]==[NSNull null])
        {
            model.en_name=@"";
        }else
        {
            model.en_name=[_dict objectForKey:@"en_name"];
        }

        if([_dict objectForKey:@"en_city"]==[NSNull null])
        {
            model.en_city=@"";
        }else
        {
            model.en_city=[_dict objectForKey:@"en_city"];
        }

        if([_dict objectForKey:@"short_name"]==[NSNull null])
        {
            model.short_name=@"";
        }else
        {
            model.short_name=[_dict objectForKey:@"short_name"];
        }

        [mutableArr addObject:model];
    }
    return mutableArr;
}

@end
