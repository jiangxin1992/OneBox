//
//  usermodel.m
//  OneBox
//
//  Created by 谢江新 on 15/9/2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "usermodel.h"

@implementation usermodel
+(usermodel *)parsingData_single:(NSDictionary *)_dict
{
    usermodel *model=[self getmodel:_dict];

    return model;
}
+(NSMutableArray *)parsingData:(NSDictionary *)_dict
{
    NSMutableArray *arrdata=[[NSMutableArray alloc] init];

//    __string(avatar);
//    __string(ease_mob_password);
//    __string(user_id);
//    __string(ease_mob_uuid);
//    __string(username);
//    __string(ease_mob_username);
//    __string(level);
    NSArray *dataArray=[_dict objectForKey:@"data"];
    for (int i=0; i<dataArray.count; i++) {
        NSDictionary *dictdata=dataArray[i];
        usermodel *model=[self getmodel:dictdata];
        [arrdata addObject:model];

    }
    return arrdata;
}
+(usermodel *)getmodel:(NSDictionary *)dictdata
{
    usermodel *model=[[usermodel alloc] init];
    if(([dictdata objectForKey:@"avatar"]!=nil)&&([dictdata objectForKey:@"avatar"]!=[NSNull null]))
    {
        model.avatar=[dictdata objectForKey:@"avatar"];
    }else
    {
        model.avatar=@"";
    }

    if(([dictdata objectForKey:@"title"]!=nil)&&([dictdata objectForKey:@"title"]!=[NSNull null]))
    {
        model.title=[dictdata objectForKey:@"title"];
    }else
    {
        model.title=@"";
    }

    if(([dictdata objectForKey:@"token"]!=nil)&&([dictdata objectForKey:@"token"]!=[NSNull null]))
    {
        model.token=[dictdata objectForKey:@"token"];
    }else
    {
        model.token=@"";
    }

    if(([dictdata objectForKey:@"cell"]!=nil)&&([dictdata objectForKey:@"cell"]!=[NSNull null]))
    {
        model.cell=[dictdata objectForKey:@"cell"];
    }else
    {
        model.cell=@"";
    }

    if(([dictdata objectForKey:@"is_following"]!=nil)&&([dictdata objectForKey:@"is_following"]!=[NSNull null]))
    {
        model.is_following=[[dictdata objectForKey:@"is_following"] boolValue];
    }else
    {
        model.is_following=NO;
    }

    if(([dictdata objectForKey:@"is_server"]!=nil)&&([dictdata objectForKey:@"is_server"]!=[NSNull null]))
    {
        model.is_server=[[dictdata objectForKey:@"is_server"] boolValue];
    }else
    {
        model.is_server=NO;
    }


    //        is_block
    if(([dictdata objectForKey:@"block2"]!=nil)&&([dictdata objectForKey:@"block2"]!=[NSNull null]))
    {
        model.is_block2=[[dictdata objectForKey:@"block2"] integerValue];
    }else
    {
        model.is_block2=1;
    }

    if(([dictdata objectForKey:@"block1"]!=nil)&&([dictdata objectForKey:@"block1"]!=[NSNull null]))
    {
        model.is_block1=[[dictdata objectForKey:@"block1"] integerValue];
    }else
    {
        model.is_block1=1;
    }


    if(([dictdata objectForKey:@"mark"]!=nil)&&([dictdata objectForKey:@"mark"]!=[NSNull null]))
    {
        model.mark=[dictdata objectForKey:@"mark"];
    }else
    {
        model.mark=@"";
    }


    if(([dictdata objectForKey:@"ease_mob_password"]!=nil)&&([dictdata objectForKey:@"ease_mob_password"]!=[NSNull null]))
    {
        model.ease_mob_password=[dictdata objectForKey:@"ease_mob_password"];
    }else
    {
        model.ease_mob_password=@"";
    }


    if(([dictdata objectForKey:@"id"]!=nil)&&([dictdata objectForKey:@"id"]!=[NSNull null]))
    {
        model.user_id=[[NSString alloc] initWithFormat:@"%ld",(long)[[dictdata objectForKey:@"id"] integerValue]];
    }else
    {
        model.user_id=@"";
    }


    if(([dictdata objectForKey:@"ease_mob_uuid"]!=nil)&&([dictdata objectForKey:@"ease_mob_uuid"]!=[NSNull null]))
    {
        model.ease_mob_uuid=[dictdata objectForKey:@"ease_mob_uuid"];
    }else
    {
        model.ease_mob_uuid=@"";
    }


    if(([dictdata objectForKey:@"ease_mob_activated"]!=nil)&&([dictdata objectForKey:@"ease_mob_activated"]!=[NSNull null]))
    {
        model.ease_mob_activated=[[dictdata objectForKey:@"ease_mob_activated"] boolValue];
    }else
    {
        model.ease_mob_activated=NO;
    }



    if(([dictdata objectForKey:@"username"]!=nil)&&([dictdata objectForKey:@"username"]!=[NSNull null]))
    {
        model.username=[dictdata objectForKey:@"username"];
    }else
    {
        model.username=@"";
    }

    if(([dictdata objectForKey:@"ease_mob_username"]!=nil)&&([dictdata objectForKey:@"ease_mob_username"]!=[NSNull null]))
    {
        model.ease_mob_username=[dictdata objectForKey:@"ease_mob_username"];
    }else
    {
        model.ease_mob_username=@"";
    }

    if(([dictdata objectForKey:@"ease_mob_username"]!=nil)&&([dictdata objectForKey:@"ease_mob_username"]!=[NSNull null]))
    {
        model.ease_mob_username=[dictdata objectForKey:@"ease_mob_username"];
    }else
    {
        model.ease_mob_username=@"";
    }


    if(([dictdata objectForKey:@"level"]!=nil)&&([dictdata objectForKey:@"level"]!=[NSNull null]))
    {
        model.level=[[dictdata objectForKey:@"level"] longValue];
    }else
    {
        model.level=1;
    }
    return model;

}
@end
