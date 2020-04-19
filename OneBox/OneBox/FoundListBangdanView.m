//
//  FoundListBangdanView.m
//  OneBox
//
//  Created by yyj on 2018/4/9.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "FoundListBangdanView.h"

@interface FoundListBangdanView()

@end

@implementation FoundListBangdanView
#pragma mark - --------------生命周期--------------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self SomePrepare];
        [self UIConfig];
    }
    return self;
}
#pragma mark - --------------SomePrepare--------------
- (void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}
- (void)PrepareData{}
- (void)PrepareUI{
}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{
    //创建榜单按钮
    [self createBangdanBtn];
}
//创建榜单按钮
-(void)createBangdanBtn{
    //        创建按钮
    UIView *lastView = nil;
    for (int i = 0; i < 4; i++) {

        UIButton *btn = [UIButton getCustomBackImgBtnWithImageStr:[self getImageName:i] WithSelectedImageStr:nil];
        [self addSubview:btn];

        CGFloat _x_bianju = (ScreenWidth - 450*_Scale)/2.0f;
        CGFloat _y_bianju = (ScreenHeight - 450*_Scale)/2.0f;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(190*_Scale);
            if(i%2 == 0){
                make.left.mas_equalTo(_x_bianju);
            }else{
                make.left.mas_equalTo(lastView.mas_right).with.offset(70*_Scale);
            }
            if(i/2 == 0){
                make.top.mas_equalTo(_y_bianju);
            }else{
                if(i%2 == 0){
                    make.top.mas_equalTo(lastView.mas_bottom).with.offset(70*_Scale);
                }else{
                    make.top.mas_equalTo(lastView);
                }
            }
        }];

        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.0f;
        [btn addTarget:self action:@selector(bangdanAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 750+i;

        lastView = btn;
    }
}
#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)bangdanAction:(UIButton *)btn
{
    if(_bangdanViewBlock){
        NSInteger buttonIndex = btn.tag - 750;
        if(buttonIndex == 0){
            _bangdanViewBlock(@"bangdan_niche");
        }else if(buttonIndex == 1){
            _bangdanViewBlock(@"bangdan_business_insider");
        }else if(buttonIndex == 2){
            _bangdanViewBlock(@"bangdan_prep_review");
        }else if(buttonIndex == 3){
            _bangdanViewBlock(@"bangdan_blueribbon");
        }
    }
}

#pragma mark - --------------自定义方法----------------------
-(NSString *)getImageName:(NSInteger )index{
    NSString *imagename = nil;
    if(index == 0)
    {
        imagename=@"bangdan_niche";
    }else if(index == 1)
    {
        imagename=@"bangdan_business_insider";
    }else if(index == 2)
    {
        imagename=@"bangdan_prep_review";
    }else if(index == 3)
    {
        imagename=@"bangdan_blueribbon";
    }
    return imagename;
}
#pragma mark - --------------other----------------------

@end
