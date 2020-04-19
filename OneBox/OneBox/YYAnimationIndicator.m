//
//  YYAnimationIndicator.m
//  AnimationIndicator
//
//  Created by 王园园 on 14-8-26.
//  Copyright (c) 2014年 王园园. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "YYAnimationIndicator.h"

@implementation YYAnimationIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isAnimating = NO;
        imageView = [UIImageView getCustomImg];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-10*_Scale*2);
        }];
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        for (int i=0; i<31; i++) {
            NSString *str=[[NSString alloc] initWithFormat:@"archive-in%d",i];
            UIImage *image=[UIImage imageNamed:str];
            [arr addObject:image];
        }
        //设置动画帧
        imageView.animationImages=arr;
        
        
        Infolabel = [UILabel getLabelWithAlignment:1 WithTitle:nil WithFont:14.0f WithTextColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1] WithSpacing:0];
        [self addSubview:Infolabel];
        [Infolabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-40*_Scale);
            make.right.mas_equalTo(40*_Scale);
            make.top.mas_equalTo(self.mas_bottom).with.offset(0);
            make.height.mas_equalTo(20*_Scale*2);
        }];
        Infolabel.backgroundColor = [UIColor clearColor];
        Infolabel.font = [regular get_en_Font:14.0f];
        self.layer.hidden = YES;

    }
    return self;
}


- (void)startAnimation
{
    _isAnimating = YES;
    self.layer.hidden = NO;
    [self doAnimation];
}

-(void)doAnimation{
    
    Infolabel.text = _loadtext;
    //设置动画总时间
    imageView.animationDuration=1.5;
    //设置重复次数,0表示不重复
    imageView.animationRepeatCount=0;
    //开始动画
    [imageView startAnimating];
}

- (void)stopAnimationWithLoadText:(NSString *)text withType:(BOOL)type;
{
    _isAnimating = NO;
    Infolabel.text = text;
    if(type){
        
        [UIView animateWithDuration:0.3f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [imageView stopAnimating];
            self.layer.hidden = YES;
            self.alpha = 1;
        }];
    }else{
        [imageView stopAnimating];
        [imageView setImage:[UIImage imageNamed:@"archive-in1"]];
    }
    
}


-(void)setLoadText:(NSString *)text;
{
    if(text){
        _loadtext = text;
    }
}

@end
