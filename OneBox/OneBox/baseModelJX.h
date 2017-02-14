//
//  baseModelJX.h
//  ActivitiesTreasure-iOSSSS
//
//  Created by jiang_xin on 14-11-25.
//  Copyright (c) 2014年 Terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface baseModelJX : NSObject
+(NSMutableArray *)parsingWithJsonData:(NSData *)data WithKey:(NSString *)key WithSecondKey:(NSString *)secondKey;
+(NSMutableArray *)parsingWithJsonData:(NSData *)data WithKey:(NSString *)key;

+(id)parsingWithJsonDataForModel:(NSData *)data WithKey:(NSString *)_key;
+(NSMutableArray *)parsingWithXMLData:(NSData *)data;

+(id)parsingWithXMLDataForModel:(NSData *)data;
+ (id)parsingWithDataForModel:(NSData *)data WithKey:(NSString *)_key;

@end
