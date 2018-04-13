//
//  ToolManager.h
//  OneBox
//
//  Created by 谢江新 on 15/3/2.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ToolManager : NSObject
//管理者
-(UIImageView *)createTitleView:(NSString *)title WithRect:(CGRect )rect WithImg:(NSString *)imageName WithtitleColor:(UIColor *)_color WithTextAlignment:(NSInteger) type Withjiange:(CGFloat)jiange;
+(BOOL)is_right_locationWithLong:(double)_long WithLat:(double)_lat;
+(id)sharedManager;
+ (BOOL)validateMobile:(NSString *)mobileNum;
-(void)loginWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure pastdue:(void(^)(void))pastdue;
//封装的数据请求
-(void)NetworkRequest:(NSString *)path bodyStr:(NSString *)body ispost:(BOOL )_ispost success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

//自定义view
-(UIImageView *)showSuccessfulOperationViewWithTitle:(NSString *)title WithImg:(NSString *)imagename Withtype:(NSInteger)type;


-(UIButton *)createBtnWithRect:(CGRect) rect WithTitle:(NSString *)title WithNormalStr:(NSString *)nStr WithSelectStr:(NSString *)sStr;
-(UIImageView *)createTitleView:(NSString *)title WithRect:(CGRect )rect WithImg:(NSString *)imageName WithtitleColor:(UIColor *)_color WithTextAlignment:(NSInteger)type ;

-(UIImageView *)createImgView:(NSString *)imageName WithRect:(CGRect )rect;
-(UIView *)createView:(CGRect )rect WithColor:(UIColor *)_color;
-(UILabel *)createLabelView:(NSString *)title Withrect:(CGRect )rect WithTextColor:(UIColor *)_color WithTextAlignment:(NSInteger) type WithFont:(CGFloat )_font;
-(UIButton *)CustomButtonWithFrame:(CGRect )rect;
-(UIAlertView *)alertTitle_Simple:(NSString *)title;

//创建进度条
-(void)createProgress:(NSString *)title;
-(void)removeProgress;

-(UIImageView *)createTitleView:(NSString *)title WithRect:(CGRect )rect WithImg:(NSString *)imageName WithtitleColor:(UIColor *)_color WithTextAlignment:(NSInteger) type WithFontName:(NSString *)str WithFont:(CGFloat )_font;

-(UIView *)returnNavView:(NSString *)title withmaxwidth:(CGFloat )maxwidth;
+ (NSAttributedString *)createAttributeString:(NSString *)str andFloat:(NSNumber*)nsKern;

@end
