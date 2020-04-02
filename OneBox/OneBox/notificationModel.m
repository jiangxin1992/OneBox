//
//  notificationModel.m
//  OneBox
//
//  Created by 谢江新 on 15/8/27.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "notificationModel.h"

@implementation notificationModel

+(NSMutableArray *)parsingWithArrForModel:(NSData *)data
{
    NSMutableArray *arrFriends = [[NSMutableArray alloc] init];
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *_dict=(NSDictionary*)res;
    NSArray *array=_dict[@"data"];
    for (int i = 0; i < array.count;i++) {
        NSDictionary *dict=array[i];
        notificationModel * model = [[notificationModel alloc]init];


//        __string(updated_at);


//        __string(send_avatar);
//        __string(sender);
        if([dict objectForKey:@"sender"]==[NSNull null])
        {

            model.sender=@"";
        }else
        {
            if([[dict objectForKey:@"sender"] isEqualToString:@""])
            {
                model.sender=@"";
            }else
            {
                model.sender=[dict objectForKey:@"sender"];

            }
        }

        if([dict objectForKey:@"send_avatar"]==[NSNull null])
        {

            model.send_avatar=@"http://7ximo7.com2.z0.glb.qiniucdn.com/assets/images/avatar3.png";
        }else
        {
            if([[dict objectForKey:@"send_avatar"] isEqualToString:@""])
            {
                model.send_avatar=@"http://7ximo7.com2.z0.glb.qiniucdn.com/assets/images/avatar3.png";
            }else
            {
                model.send_avatar=[dict objectForKey:@"send_avatar"];

            }
        }

        if([dict objectForKey:@"updated_at"]!=[NSNull null])
        {

            model.updated_at=[dict objectForKey:@"updated_at"];
        }else
        {
            model.updated_at=@"";
        }
//        detail_TIME
        if([dict objectForKey:@"created_at"]!=[NSNull null])
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            //            判断是否超过一天
            NSDate *NiceNewdate = [dateFormat dateFromString:[dict objectForKey:@"created_at"]];

            NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
                //                today
            [dateFormat1 setDateFormat:@"MM/dd HH:mm"];

            model.detail_TIME = [dateFormat1 stringFromDate:NiceNewdate];
            
        }else
        {
            model.detail_TIME=@"";
        }


        if([dict objectForKey:@"created_at"]!=[NSNull null])
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//            判断是否超过一天
            NSDate *NiceNewdate = [dateFormat dateFromString:[dict objectForKey:@"created_at"]];
            NSTimeInterval time= [NiceNewdate timeIntervalSince1970];
            NSDate *nowdate=[NSDate date];
            NSTimeInterval time_now= [nowdate timeIntervalSince1970];

            NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];

            if((time/(24*60*60))==(time_now/(24*60*60)))
            {
//                today
                [dateFormat1 setDateFormat:@"HH:mm"];

            }else if((time_now/(24*60*60))-(time/(24*60*60))>365)
            {
                [dateFormat1 setDateFormat:@"YYYY/MM"];
            }else
            {
                [dateFormat1 setDateFormat:@"MM/dd"];

            }

            model.created_at = [dateFormat1 stringFromDate:NiceNewdate];

        }else
        {
            model.created_at=@"";
        }

        if(dict[@"is_readed"]!=[NSNull null])
        {
            if([[dict objectForKey:@"is_readed"] longValue]==0)
            {
                model.is_readed=NO;
            }else
            {
                model.is_readed=YES;
            }
        }else
        {
            model.is_readed=NO;
        }

        if(dict[@"body"]!=[NSNull null])
        {
            model.body=[dict objectForKey:@"body"];
        }else
        {
            model.body=@"";
        }
        if(dict[@"extra_info"]!=[NSNull null])
        {
            model.extra_info=[dict objectForKey:@"extra_info"];
        }else
        {
            model.extra_info=[[NSDictionary alloc] init];
        }
        


        if(dict[@"total_students"]!=[NSNull null])
        {
            model.NOT_ID=[[NSString alloc] initWithFormat:@"%ld",[dict[@"id"] longValue]];
        }else
        {
            model.NOT_ID=@"";
        }

        if(dict[@"user_id"]!=[NSNull null])
        {
            model.user_id=[[NSString alloc] initWithFormat:@"%ld",[dict[@"user_id"] longValue]];
        }else
        {
            model.user_id=@"";
        }

        [arrFriends addObject:model];

    }
    return arrFriends;
}

@end
