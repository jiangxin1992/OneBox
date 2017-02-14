//
//  UITextField+Custom.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Custom)

+(UITextField *)getTextFieldWithPlaceHolder:(NSString *)_placeHolder WithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithTextColor:(UIColor *)_textColor WithLeftView:(UIView *)_leftView WithRightView:(UIView *)_rightView WithSecureTextEntry:(BOOL )_isSecure;

@end
