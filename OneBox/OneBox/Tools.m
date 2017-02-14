//
//  Tools.m
//  爱限免
//
//  Created by huangdl on 14-10-10.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import "Tools.h"

@implementation Tools
//做ios版本之间的适配
//不同的ios版本,调用不同的方法,实现相同的功能
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode
{
    JXLOG(@"版本号:%f",[[[UIDevice currentDevice]systemVersion]doubleValue]);
    CGSize s;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0) {
        JXLOG(@"ios7以后版本");
        NSMutableDictionary  *mdic=[NSMutableDictionary dictionary];
        [mdic setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        [mdic setObject:font forKey:NSFontAttributeName];
        s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:mdic context:nil].size;
    }
    else
    {
        JXLOG(@"ios7之前版本");
        s=[str sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
    }
    return s;
}

@end
