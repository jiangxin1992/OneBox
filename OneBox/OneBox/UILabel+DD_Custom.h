//
//  UILabel+DD_Custom.h
//  DDAY
//
//  Created by yyj on 16/7/15.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DD_Custom)

+(UILabel *)getLabelWithAlignment:(NSInteger )_alignment WithTitle:(NSString *)_title WithFont:(CGFloat )_font WithTextColor:(UIColor *)_textColor WithSpacing:(CGFloat )_spacing;

@end
