//
//  TabbarItem.m
//  爱限免
//
//  Created by huangdl on 14-9-28.
//  Copyright (c) 2014年 1000phone. All rights reserved.
//

#import "TabbarItem.h"

@implementation TabbarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置normal状态下 title的颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        self.backgroundColor=[UIColor redColor];
        //设置select状态下 title的颜色
        [self setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.5] forState:UIControlStateSelected];
        //设置字体大小

        self.titleLabel.font=[regular get_en_Font:9.5f];
        //设置居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;

    }
    return self;
}

//覆盖父类的方法,取消高亮状态
-(void)setHighlighted:(BOOL)highlighted
{

}
//返回图片的frame
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{

    if(self.type==1)
    {
        //为box的时候
        return CGRectMake((ScreenWidth/5.0f-32)/2.0f, (kTabBarHeight-32)/2.0f, 32, 32);
    }else if(self.type==0)
    {
        return CGRectMake((ScreenWidth/5.0f-32)/2.0f, (kTabBarHeight-32)/2.0f, 32 , 32);
    }else if(self.type==2)
    {
        return CGRectMake((ScreenWidth/5.0f-18)/2.0f, (kTabBarHeight-18)/2.0f, 18 , 18);
    }else if(self.type==4)
    {
        return CGRectMake((ScreenWidth/5.0f-18)/2.0f, (kTabBarHeight-18)/2.0f, 18 , 18);
    }else
    {
        return CGRectMake((ScreenWidth/5.0f-30)/2.0f, (kTabBarHeight-30)/2.0f, 30 , 30);
    }

}

@end










