//
//  academicRecordModel.m
//  OneBox
//
//  Created by 谢江新 on 15/5/18.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "academicRecordModel.h"

@implementation academicRecordModel
+(academicRecordModel *)parsingWithJsonDataForModel:(NSDictionary *)dict
{
    NSDictionary *_dict=[dict objectForKey:@"data"];
    academicRecordModel *model=[[academicRecordModel alloc] init];
    [model setValuesForKeysWithDictionary:_dict];
    return model;
}
@end
