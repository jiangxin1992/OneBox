//
//  SouSuoCitiesHeaderView.m
//  OneBox
//
//  Created by yyj on 2018/4/23.
//  Copyright © 2018年 谢江新. All rights reserved.
//

#import "SouSuoCitiesHeaderView.h"

@implementation SouSuoCitiesHeaderView
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
- (void)PrepareUI{}

#pragma mark - --------------UIConfig----------------------
-(void)UIConfig{

    UIButton *touchbtn = [UIButton getCustomImgBtnWithImageStr:@"setting_意见" WithSelectedImageStr:nil];
    [self addSubview:touchbtn];
    [touchbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(80*_Scale);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(70);
    }];
    [touchbtn addTarget:self action:@selector(saysomething_to_us) forControlEvents:UIControlEventTouchUpInside];

    NSArray *titlearr = @[@"要找的学校没有收录？",@"告诉我们吧。"];
    UIView *lastView = nil;
    for (int i=0; i<2; i++) {
        UILabel *label = [UILabel getLabelWithAlignment:1 WithTitle:titlearr[i] WithFont:13.f WithTextColor:_define_blue_color WithSpacing:2.0];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            if(!lastView){
                make.top.mas_equalTo(touchbtn.mas_bottom).with.offset(15);
            }else{
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(0);
            }
            make.height.mas_equalTo(60*_Scale);
        }];

        lastView = label;
    }

}

#pragma mark - --------------UpdateUI----------------------
-(void)updateUI{}

#pragma mark - --------------系统代理----------------------

#pragma mark - --------------自定义响应----------------------
-(void)saysomething_to_us{
    if(_SouSuoCitiesViewBlock){
        _SouSuoCitiesViewBlock(@"saysomething_to_us");
    }
}

#pragma mark - --------------自定义方法----------------------


#pragma mark - --------------other----------------------


@end
