//
//  SizeTool.m
//  OneBox
//
//  Created by 顾鹏 on 15/3/2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "SizeTool.h"

@implementation SizeTool
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode
{
    NSLog(@"版本号:%f",[[[UIDevice currentDevice]systemVersion]doubleValue]);
    CGSize s;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0) {
        NSLog(@"ios7以后版本");
        // NSDictionary *dic=@{NSFontAttributeName:font};
        NSMutableDictionary  *mdic=[NSMutableDictionary dictionary];
        [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        [mdic setObject:font forKey:NSFontAttributeName];
        s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:mdic context:nil].size;
    }
    else
    {
        NSLog(@"ios7之前版本");
        s=[str sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
    }
    return s;
}

@end
