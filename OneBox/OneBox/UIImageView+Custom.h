//
//  UIImageView+Custom.h
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Custom)

/**
 * 创建imageview 带image
 */
+(UIImageView *)getImgWithImageStr:(NSString *)_imageStr;

/**
 * 创建蒙板
 */
+(UIImageView *)getMaskImageView;

/**
 * 创建自定义 image
 */
+(UIImageView *)getCustomImg;

+(UIImageView *)getCornerRadiusImg;

/**
 * 获取imageview 网络加载的
 */
//+(UIImageView *)getloadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius WithContentMode:(NSInteger )contentModel;

@end
