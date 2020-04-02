//
//  serviceController.m
//  OneBox
//
//  Created by 谢江新 on 15/3/9.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "serviceController.h"
#import "Tools.h"
@interface serviceController ()

@end

@implementation serviceController
{
    UIScrollView *_scrollView;
    UIView *_headview;
    
    CGFloat _contentlabelHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self UIConfig];
}
-(void)prepareData
{
    _contentlabelHeight=((CGSize )[Tools sizeOfStr:@"22" andFont:[UIFont systemFontOfSize:17.0f] andMaxSize:CGSizeMake(200, 99999) andLineBreakMode:NSLineBreakByWordWrapping]).height;
    self.navigationItem.titleView=[[ToolManager sharedManager] returnNavView:@"目标学校"];
    self.view.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1];
}
-(void)UIConfig
{
    [self createScrollView];
    [self createHeadView];
    [self createCardView];

}
-(void)createCardView
{
    
    CGFloat _y_p=CGRectGetMaxY(_headview.frame)+90*_Scale;
    NSDictionary *_dict1=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:@"－申请全案－",@"title",@[@"目标学校全部申请表格及材料准备;",@"5所学校申请，保证2所学校录取"],@"content",nil],@"dict",@"a",@"type",@"box_serve_头像",@"headimg",@"￥18000",@"price",[UIColor colorWithRed:242.0f/255.0f green:107.0f/255.0f blue:85.0f/255.0f alpha:1],@"color",nil];
    
     NSDictionary *_dict2=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:@"－签证全案－",@"title",@[@"专案在线问答支持，全程疑难指导;",@"DS160表格填写,",@"签证材料准备辅助",@"约签及通知提醒",@"面试视频辅导(1次)"],@"content",nil],@"dict",@"b",@"type",@"box_serve_头像",@"headimg",@"￥1600",@"price",[UIColor colorWithRed:242.0f/255.0f green:107.0f/255.0f blue:85.0f/255.0f alpha:1],@"color",nil];
    
    NSDictionary *_dict3=[[NSDictionary alloc] initWithObjectsAndKeys:[[NSDictionary alloc] initWithObjectsAndKeys:@"－赴美服务－",@"title",@[@"陪飞或接机",@"寄宿家庭管理",@"在美监护",@"每月家长报告等"],@"content",nil],@"dict",@"c",@"type",@"box_serve_头像",@"headimg",@"获取更多",@"price",[UIColor colorWithRed:245.0f/255.0f green:202.0f/255.0f blue:65.0f/255.0f alpha:1],@"color",nil];
    
    NSArray *_dataArray=@[_dict1,_dict2,_dict3];
    
    for (int i=0; i<_dataArray.count; i++) {
        NSDictionary *_dict=_dataArray[i];
        UIView *_cardView=[self createCard:@"box_serve_头像" WithType:_dict[@"type"] WithContent:_dict[@"dict"] WithPrice:_dict[@"price"] With_y_p:_y_p WithPriceColor:_dict[@"color"]];
        [_scrollView addSubview:_cardView];
        _y_p=CGRectGetMaxY(_cardView.frame)+90*_Scale;
        if(i==_dataArray.count-1)
        {
            _scrollView.contentSize=CGSizeMake(ScreenWidth, CGRectGetMaxY(_cardView.frame)+tabbarHeight);
        }
        
        
    }
}
-(void)createHeadView
{
    
    _headview=[[UIView alloc] initWithFrame:CGRectMake(20*_Scale, 80*_Scale, ScreenWidth-40*_Scale, 494*_Scale)];
    _headview.backgroundColor=self.view.backgroundColor;

    [_scrollView addSubview:_headview];
    
    UIImageView *upview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-40*_Scale, 180*_Scale)];
    upview.image=[UIImage imageNamed:@"box_serve_申请加速"];
    [_headview addSubview:upview];
    
    UIImageView *_head=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_headview.frame)/2)-60*_Scale, -60*_Scale, 120*_Scale, 120*_Scale)];
    _head.image=[UIImage imageNamed:@"box_serve_飞机"];
    [upview addSubview:_head];
    
    CGFloat labelHeight=(CGRectGetHeight(upview.frame)- CGRectGetMaxY(_head.frame)-((40*_Scale/2)-4*_Scale)-20*_Scale)/2;
    CGFloat _y_p=CGRectGetMaxY(_head.frame)+10*_Scale;
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(upview.frame), labelHeight)];
        NSString *title=i==0?@"申请加速":@"获得我们指定方案的全程指导";
        label.text=title;
        label.textColor=[UIColor whiteColor];
        label.textAlignment=1;
        [upview addSubview:label];
        _y_p+=labelHeight;
    }
    
    UIImageView *middleView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame)+8*_Scale, CGRectGetWidth(_headview.frame), 240*_Scale)];
    middleView.image=[UIImage imageNamed:@"box_serve_申请辅助"];
    [_headview addSubview:middleView];
    
    CGFloat __y_p=15*_Scale-4*_Scale+20*_Scale;
    CGFloat top_labHeight=60*_Scale;
    CGFloat _labelheight=(CGRectGetHeight(middleView.frame)-__y_p-top_labHeight-10*_Scale)/3;
    CGFloat _height=0;
    NSArray *titlearray=@[@"－申请辅助－",@"在线问答支持，全程疑难指导;",@"目标学校申请表格及材料清单提供;",@"申请递交，面试安排等全程美校沟通。"];
    for (int i=0; i<titlearray.count; i++) {
        _height=i==0?top_labHeight:_labelheight;
        CGRect _rect=CGRectMake(0, __y_p, CGRectGetWidth(middleView.frame), _height);
        UILabel *label=[[UILabel alloc] initWithFrame:_rect];
        label.text=titlearray[i];
        label.textAlignment=1;
        label.textColor=[UIColor whiteColor];
        [middleView addSubview:label];
        __y_p+=_height;
    }
    
    UIImageView *connectView=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_headview.frame)/2)-20*_Scale, CGRectGetMaxY(upview.frame)-16*_Scale, 40*_Scale, 40*_Scale)];
    connectView.image=[UIImage imageNamed:@"box_serve_a.b.c圆点"];
    [_headview addSubview:connectView];
    
    UIImageView *downView=[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame)+4*_Scale, CGRectGetWidth(_headview.frame), CGRectGetHeight(_headview.frame)-CGRectGetMaxY(middleView.frame)-4*_Scale)];
    downView.image=[UIImage imageNamed:@"box_serve_获取更多信息"];
    [_headview addSubview:downView];
    UILabel *_contentlabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(downView.frame), CGRectGetHeight(downView.frame))];
    [downView addSubview:_contentlabel];
    _contentlabel.text=@"￥680";
    _contentlabel.textAlignment=1;
    _contentlabel.textColor=[UIColor whiteColor];
    
}
-(void)createScrollView
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight+tabbarHeight)];

    _scrollView.backgroundColor=self.view.backgroundColor;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.contentSize=CGSizeMake(ScreenWidth, ScreenHeight);
    [self.view addSubview:_scrollView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}
-(UIView *)createCard:(NSString *)headName WithType:(NSString *)type WithContent:(NSDictionary *)dict WithPrice:(NSString*)price With_y_p:(CGFloat )y_p WithPriceColor:(UIColor *)color
{
    NSArray *contentArray=dict[@"content"];
    UIView *_card=[[UIView alloc] initWithFrame:CGRectMake(20*_Scale, y_p, CGRectGetWidth(_scrollView.frame)-40*_Scale, 430*_Scale+contentArray.count*_contentlabelHeight)];
    _card.backgroundColor=self.view.backgroundColor;

    
    UIView *upview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_card.frame), 200*_Scale)];
    upview.backgroundColor=[UIColor whiteColor];
    [_card addSubview:upview];
    UIImageView *_head=[[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_card.frame)/2)-60*_Scale, -60*_Scale, 120*_Scale, 120*_Scale)];
    _head.image=[UIImage imageNamed:headName];
    [upview addSubview:_head];

    CGFloat _label_height=(200-60-30-20)*_Scale/2;
    CGFloat _y_p=CGRectGetMaxY(_head.frame);
    _y_p+=10*_Scale;
    for (int i=0; i<2; i++) {
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, _y_p, CGRectGetWidth(_card.frame), _label_height)];
        NSString *content=i==0?@"王大美":@"申请专案";
        label.text=content;
        label.textAlignment=1;
        label.textColor=[UIColor colorWithRed:66.0f/255.0f green:178.0f/255.0f blue:209.0f/255.0f alpha:1];
        _y_p+=_label_height;
        [upview addSubview:label];
    }
    
    
    UIView *middleView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upview.frame), CGRectGetWidth(_card.frame), 170*_Scale+contentArray.count*_contentlabelHeight)];
    middleView.backgroundColor=[UIColor colorWithRed:65.0f/255.0f green:177.0f/255.0f blue:207.0f/255.0f alpha:1];
    [_card addSubview:middleView];
    
    UIImageView *_typeImg=[[ToolManager sharedManager] createTitleView:type WithRect:CGRectMake((CGRectGetWidth(middleView.frame)/2)-30*_Scale, -30*_Scale, 60*_Scale, 60*_Scale) WithImg:@"box_serve_a.b.c圆点" WithtitleColor:[UIColor whiteColor] WithTextAlignment:1];

    [middleView addSubview:_typeImg];
//    110 60
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_typeImg.frame)+30*_Scale, CGRectGetWidth(middleView.frame), 110*_Scale-CGRectGetMaxY(_typeImg.frame)-30*_Scale)];
    titleLabel.textAlignment=1;
    titleLabel.text=[[NSString alloc] initWithFormat:@"- %@ -",dict[@"title"]];
    titleLabel.textColor=[UIColor whiteColor];
    [middleView addSubview:titleLabel];
    
    
    CGFloat __y_p=CGRectGetMaxY(titleLabel.frame);
    
    for (int i=0; i<contentArray.count; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, __y_p, CGRectGetWidth(middleView.frame), _contentlabelHeight)];
        label.textAlignment=1;
        label.text=contentArray[i];
        label.textColor=[UIColor whiteColor];
        [middleView addSubview:label];
        __y_p+=_contentlabelHeight;
    }
    
    
    
    UIView *downView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(middleView.frame)+4*_Scale, CGRectGetWidth(_card.frame), (60-4)*_Scale)];
    downView.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:84.0f/255.0f blue:68.0f/255.0f alpha:1];
    downView.backgroundColor=color;
    UILabel *pricelabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(downView.frame), CGRectGetHeight(downView.frame))];
    pricelabel.textAlignment=1;
    pricelabel.text=price;
    pricelabel.textColor=[UIColor whiteColor];
    [downView addSubview:pricelabel];
    [_card addSubview:downView];
    
    return _card;
}


-(void)viewWillAppear:(BOOL)animated
{
    [[CustomTabbarController sharedManager] tabbarHide];
}

@end
