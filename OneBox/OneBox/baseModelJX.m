//
//  baseModelJX.m
//  ActivitiesTreasure-iOSSSS
//
//  Created by jiang_xin on 14-11-25.
//  Copyright (c) 2014年 Terry. All rights reserved.
//

#import "baseModelJX.h"

@implementation baseModelJX
+(NSMutableArray *)parsingWithJsonData:(NSData *)data WithKey:(NSString *)key WithSecondKey:(NSString *)secondKey
{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dict = (NSDictionary *)res;
    NSArray*arr=dict[key][secondKey];
    for (NSDictionary *dict in arr) {
        id model = [[self alloc]init];
        //KVC
        [model setValuesForKeysWithDictionary:dict];
        //        model._id=[[dict objectForKey:@"id"] longValue];
        [dataArray addObject:model];
    }
    return dataArray;

}
+(NSMutableArray *)parsingWithJsonData:(NSData *)data WithKey:(NSString *)key
{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *dict = (NSDictionary *)res;
    NSArray*arr=dict[key];
    for (NSDictionary *dict in arr) {
        id model = [[self alloc]init];
        //KVC
        [model setValuesForKeysWithDictionary:dict];
//        model._id=[[dict objectForKey:@"id"] longValue];
        [dataArray addObject:model];
    }
    return dataArray;
}

+ (id)parsingWithDataForModel:(NSData *)data WithKey:(NSString *)_key
{
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *_dict=(NSDictionary*)res;
    NSDictionary *dict=_dict[_key];
    JXLOG(@"detail %@",dict);
    id model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;

}
+(id)parsingWithJsonDataForModel:(NSData *)data
{
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *_dict=(NSDictionary*)res;
    NSDictionary *dict=_dict[@"results"];
    id model = [[self alloc]init];
    [model setValuesForKeysWithDictionary:dict];
    return model;

}

+(NSMutableArray *)parsingWithXMLData:(NSData *)data
{
    return nil;
}

+(id)parsingWithXMLDataForModel:(NSData *)data
{
    return nil;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //    JXLOG(@"%@",key);
}
@end
