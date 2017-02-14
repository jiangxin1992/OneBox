//
//  UIView+Frame.h
//  百思不得姐
//
//  Created by qianfeng on 16/3/9.
//  Copyright (c) 2016年 谢翼华. All rights reserved.
//

#import <UIKit/UIKit.h>

#define __float(__k__) @property(nonatomic,assign) CGFloat __k__

@interface UIView (Frame)

//在分类中声明property,只会生成方法的声明，不会生成方法的实现和带有下划线的成员变量
__float(fr_width);

__float(fr_height);

__float(fr_x);

__float(fr_y);

@end
