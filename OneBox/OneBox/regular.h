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
+ (regular *)shared;
+(UIFont *)getFont:(CGFloat )font;
+(UIFont *)get_en_Font:(CGFloat )font;
+ (BOOL )isNilOrEmpty: (NSString *) str;
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


+ (UIAlertView *)alertTitle_Simple:(NSString *)title;
+ (UITextField *)createTextField:(CGRect)rect withReturnKeyType: (UIReturnKeyType) returnKeyType textColor: (UIColor *) textColor font: (UIFont *) font textAlignment: (NSTextAlignment) textAlignment toDelegate: (UIViewController<UITextFieldDelegate> *) delegate tag: (NSInteger) tag;

#pragma mark ---------------- 缓存处理 -----------------
/**
 *  获取缓存大小（带单位）
 *
 *  @return 缓存大小（带单位）, 单位 M，小于1M用kb
 */
- (NSString *) getCacheSize;

/**
 *  获取指定缓存文件路径
 *
 *  @param appendPath 指定子路径，为空或Nil时返回整个缓存文件夹大小
 *
 *  @return 指定缓存文件路径
 */
- (NSString *) getCachesPathWithAppendPath: (NSString *) appendPath;

/**
 *  清理指定类型的指定路径文件(NSHomeDirectory 目录下)
 *
 *  @param fullPath 指定全路径，如果为空或者nil，表示整个NSDocumentDirectory
 *  @param extension  指定文件类型如 m4r,如果为空或者nil,表示删除所有文件
 */
- (void) clearFileWithPath: (NSString *) fullPath withExtension: (NSString *) extension;
//+ (void)checkLogin;
+ (NSAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern;
@end
