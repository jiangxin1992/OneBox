//
//  UIImageView+Custom.m
//  DDAY
//
//  Created by yyj on 16/7/14.
//  Copyright © 2016年 YYJ. All rights reserved.
//

#import "UIImageView+Custom.h"

#import "UIImageView+CornerRadius.h"

@implementation UIImageView (Custom)


+(UIImageView *)getImgWithImageStr:(NSString *)_imageStr
{
    UIImageView *imageview=[[UIImageView alloc] init];
    imageview.userInteractionEnabled=YES;
    if(_imageStr){
        imageview.image=[UIImage imageNamed:_imageStr];
    }
    imageview.contentMode=UIViewContentModeScaleAspectFit;
    return imageview;
}



+(UIImageView *)getMaskImageView
{
    UIImageView *mengban=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    mengban.userInteractionEnabled=YES;
    mengban.contentMode=UIViewContentModeScaleToFill;
    mengban.image=[UIImage imageNamed:@"System_Mask"];
    return mengban;
}
+(UIImageView *)getCustomImg
{
    UIImageView *img=[[UIImageView alloc] init];
    img.contentMode=1;
    return img;
}
+(UIImageView *)getCornerRadiusImg
{
    UIImageView *imageView = [[UIImageView alloc] initWithRoundingRectImageView];
    imageView.contentMode=1;
    return imageView;
}
//+(UIImageView *)getloadImageUrlStr:(NSString *)_urlStr WithSize:(NSInteger )size placeHolderImageName:(NSString *)placeHolderStr radius:(CGFloat)radius WithContentMode:(NSInteger )contentModel
//{
//    UIImageView *imageview=[UIImageView getCornerRadiusImg];
//    imageview.userInteractionEnabled=YES;
//    imageview.contentMode=contentModel;
//    if(contentModel==0)
//    {
//        [imageview JX_ScaleToFill_loadImageUrlStr:_urlStr WithSize:size placeHolderImageName:placeHolderStr radius:radius];
//    }else if(contentModel==1)
//    {
//        [imageview JX_ScaleAspectFit_loadImageUrlStr:_urlStr WithSize:size placeHolderImageName:placeHolderStr radius:radius ];
//    }else
//    {
//        [imageview JX_ScaleAspectFill_loadImageUrlStr:_urlStr WithSize:size placeHolderImageName:placeHolderStr radius:radius ];
//    }
//
//    return imageview;
//}
@end
