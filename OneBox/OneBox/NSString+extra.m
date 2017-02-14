//
//  NSString+extra.m
//  OneBox
//
//  Created by 顾鹏 on 15/3/4.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "NSString+extra.h"

@implementation NSString (extra)
+ (BOOL )isNilOrEmpty: (NSString *) str;
{
    if (str && ![str isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}

@end
