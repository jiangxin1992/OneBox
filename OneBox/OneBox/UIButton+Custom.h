//
//  UIButton+Custom.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)

/**
 * 创建带title 的自定义 btn
 */
+(UIButton *)getCustomTitleBtnWithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithSpacing:(CGFloat )_spacing WithNormalTitle:(NSString *)_normalTitle WithNormalColor:(UIColor *)_normalColor WithSelectedTitle:(NSString *)_selectedTitle WithSelectedColor:(UIColor *)_selectedColor;

/**
 * 创建带image 的自定义 btn
 */
+(UIButton *)getCustomImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr;

/**
 * 创建带backimage 的自定义 btn
 */
+(UIButton *)getCustomBackImgBtnWithImageStr:(NSString *)_normalImageStr WithSelectedImageStr:(NSString *)_selectedImageStr;

/**
 * 创建自定义 btn
 */
+(UIButton *)getCustomBtn;

@end
