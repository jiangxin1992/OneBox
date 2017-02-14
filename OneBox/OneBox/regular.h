//
//  regular.h
//  OneBox
//
//  Created by 谢江新 on 15-2-3.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface regular : NSObject
/**
 * 单例
 */
+ (id)sharedManager;

/** 用户是否打开推送开关*/
+ (BOOL)isEnableAPNS;

/** 获取保留小数点后两位数的字符串*/
+ (NSString *)getRoundNum:(CGFloat )num;

/**
 * 获取html
 * content 内容
 * font 字体大小
 * 字体颜色
 */
+ (NSString *)getHTMLStringWithContent:(NSString *)content WithFont:(NSString *)font WithColorCode:(NSString *)color;
/**
 * 固定内容 字体下
 * 获取高度
 */
+(CGFloat )getHeightWithWidth:(CGFloat )width WithContent:(NSString *)content WithFont:(UIFont *)font;

/**
 * 固定内容 字体下
 * 获取宽度
 */
+(CGFloat )getWidthWithHeight:(CGFloat )height WithContent:(NSString *)content WithFont:(UIFont *)font;

/** 获取过去时间的时间区间*/
+(NSString *)getSpacingTime:(long)createTime;

/**
 * 根据shareAdvise获取当前label高度
 */
+(CGFloat )getHeightWithContent:(NSString *)shareAdvise WithWidth:(CGFloat)Width WithFont:(CGFloat )font;

/**
 * 添加view边框
 * 黑色 边框宽度为1
 */
+(void)setBorder:(UIView *)view;
/**
 * 裁剪
 */
+(void)setZeroBorder:(UIView *)view;
/**
 * 添加自定义边框
 */
+(void)setBorder:(UIView *)view WithColor:(UIColor *)color WithWidth:(CGFloat )width;
/**
 * 取消线程
 */
+(void)dispatch_cancel:(dispatch_source_t )_time;
/**
 * 获取时间戳对应的nsdate
 */
+(NSDate*)zoneChange:(long)time;

/**
 * 根据当前时间差 获取对应的剩余时间字符串
 */
+(NSString *)getTimeStr:(long)time;

/**
 * 时间戳转时间
 */
+(NSString *)getTimeStr:(long)time WithFormatter:(NSString *)_formatter;
/**
 * 获取时间戳
 */
+(long )getTimeWithTimeStr:(NSString *)time;

/**
 * 获取当前时间戳
 */
+(long)date;

/**
 * 进入系统设置
 */
+(void)pushSystem;
/**
 * 键盘消失
 */
+(void)dismissKeyborad;


/** 中国大陆手机号判断*/
+ (BOOL)isMobilePhoneOrtelePhone:(NSString *)mobileNum ;

/**
 * 电子邮箱正则
 */
+ (BOOL )emailVerify:(NSString *)email;
/**
 * 正则匹配用户密码6-15位数字和字母组合
 */
+ (BOOL)checkPassword:(NSString *) password;

/**
 * 验证码格式验证
 */
+(BOOL )codeVerify:(NSString *)phone;

/**
 * 邮编格式验证
 */
+(BOOL )PostCodeVerify:(NSString *)phone;

/**
 * 手机号码格式验证
 */
+(BOOL )phoneVerify:(NSString *)phone;

/**
 * 纯数字验证
 */
+(BOOL )numberVerift:(NSString *)phone;

/**
 * 固定电话区号正则
 */
+(BOOL )telephoneAreaCode:(NSString *)telephoneArea;

/**
 * 加密
 */
+ (NSString *)md5:(NSString *)str;

/**
 * 获取中文字体
 */
+(UIFont *)getFont:(CGFloat )font;

/**
 * 获取英文字体
 */
+(UIFont *)get_en_Font:(CGFloat )font;

/**
 * 获取alert视图
 * title标题内容
 */
+ (UIAlertView *)alertTitle_Simple_OLD:(NSString *)title;
+(UIAlertController *)alertTitle_Simple:(NSString *)title;

/**
 * 获取alert视图
 * title标题内容
 * 点击OK回调
 */
+(UIAlertController *)alertTitle_Simple:(NSString *)title WithBlock:(void(^)())block;

/**
 * 获取alert视图
 * title标题内容
 * 点击OK回调
 * 带了个取消
 */
+(UIAlertController *)alertTitleCancel_Simple:(NSString *)title WithBlock:(void(^)())block;

/**
 * 网络错误下的alert视图
 */
+(UIAlertController *)alert_NONETWORKING;

/**
 * 设置字间距
 */
+ (NSAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern;

+ (UIButton *)createBtnWithRect:(CGRect) rect WithTitle:(NSString *)title WithNormalStr:(NSString *)nStr WithSelectStr:(NSString *)sStr;
+ (UIButton *)createBtnWithRect:(CGRect)rect WithTitle:(NSString *)title WithNormalColor:(UIColor *)normalColor WithSelectColor:(UIColor *)selectColor WithTitleFont:(UIFont *)font;
+ (UIImageView *)createTitleView:(NSString *)title WithRect:(CGRect )rect WithImg:(NSString *)imageName WithtitleColor:(UIColor *)_color WithTextAlignment:(NSInteger) type;
+ (UIImageView *)createImgView:(NSString *)imageName WithRect:(CGRect )rect;
+ (UIView *)createView:(CGRect )rect WithColor:(UIColor *)_color;
+ (UILabel *)createLabelView:(NSString *)title Withrect:(CGRect )rect WithTextColor:(UIColor *)_color WithTextAlignment:(NSInteger) type WithFont:(CGFloat )_font;

+ (void)createProgress:(NSString *)title;
+ (void)createSuccessProgress;
+  (void)removeProgress;
+ (UIView *)returnNavView:(NSString *)title withmaxwidth:(CGFloat )maxwidth;

+ (UIButton *)CustomButtonWithFrame:(CGRect )rect;

+ (UITextField *)createTextField:(CGRect)rect withReturnKeyType: (UIReturnKeyType) returnKeyType textColor: (UIColor *) textColor font: (UIFont *) font textAlignment: (NSTextAlignment) textAlignment toDelegate: (UIViewController<UITextFieldDelegate> *) delegate tag: (NSInteger) tag;

//+ (void)checkLogin;
@end
