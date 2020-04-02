//
//  UITextField+Custom.m
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UITextField+Custom.h"

@implementation UITextField (Custom)
+(UITextField *)getTextFieldWithPlaceHolder:(NSString *)_placeHolder WithAlignment:(NSInteger )_alignment WithFont:(CGFloat )_font WithTextColor:(UIColor *)_textColor WithLeftView:(UIView *)_leftView WithRightView:(UIView *)_rightView WithSecureTextEntry:(BOOL )_isSecure
{
    UITextField *_textfield=[[UITextField alloc] init];
    if(_textColor){
        _textfield.textColor=_textColor;
    }else
    {
        _textfield.textColor=_define_black_color;
    }
    if(_placeHolder){
        _textfield.placeholder=_placeHolder;
    }
    if(_font){
        _textfield.font=[regular getFont:_font];
    }
    if(_leftView){
        _textfield.leftViewMode=UITextFieldViewModeAlways;
        _textfield.leftView=_leftView;
    }
    if(_rightView){
        _textfield.rightViewMode=UITextFieldViewModeAlways;
        _textfield.rightView=_rightView;
    }
    if(_isSecure)
    {
        _textfield.secureTextEntry=_isSecure;
    }else
    {
        _textfield.secureTextEntry=NO;
    }

    _textfield.textAlignment=_alignment;

    return _textfield;
}
@end
