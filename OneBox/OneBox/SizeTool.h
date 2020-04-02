//
//  SizeTool.h
//  OneBox
//
//  Created by 顾鹏 on 15/3/2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SizeTool : NSObject
+(CGSize)sizeOfStr:(NSString *)str andFont:(UIFont *)font andMaxSize:(CGSize)size andLineBreakMode:(NSLineBreakMode)mode;
@end
