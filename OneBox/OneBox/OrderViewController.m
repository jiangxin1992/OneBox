//
//  OrderViewController.m
//  OneBox
//
//  Created by 顾鹏 on 15/5/12.
//  Copyright (c) 2015年 谢江新. All rights reserved.
//

#import "OrderViewController.h"
#import "CusOrder.h"
#import "CusStarView.h"
#import "HttpRequestManager.h"
#import "orderRowModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface OrderViewController ()
{
//    CusOrder *order;
//    UIView *backStar;
    NSMutableArray *starsArr;
    NSMutableArray *arr;
    
}
@end

@implementation OrderViewController
- (void)loadView
{
    UIScrollView *view = [[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.view = view;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    starsArr = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView=[[ToolManager sharedManager] returnNavView:@"我的订单"];
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    UIBarButtonItem *_btn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(popviewAction)];
    self.navigationItem.leftBarButtonItem=_btn;
    
//    order = [[CusOrder alloc] init];
//    [order setType:0 andRect:CGRectMake(10, 46, kScreenWidth - 20, 226)];
//    [self.view addSubview:order];
//
//    backStar = [[UIView alloc] initWithFrame:CGRectMake(10,272, kScreenWidth - 20, 100)];
//    backStar.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:backStar];
//    [self createStar];
    
}
-(void)popviewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareData
{
    NSString *orderUrl = [NSString stringWithFormat:@"%@/v1/orders?token=%@",DNS,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    [HttpRequestManager GET:orderUrl complete:^(NSData *data) {
       arr = [orderRowModel parsingWithJsonDataForModel:data];
        for (int i = 0; i < arr.count; i ++) {
            [self createAllView:arr[i] andCount:i];
        }
        for (int i = 0; i < starsArr.count; i ++) {
            for (int j = 0; j < 5; j ++) {
                UIButton *btn =starsArr[i][j];
                NSLog(@"%dcount",[btn tag]);
            }
        }
        NSLog(@"count%d",starsArr.count);
        
        UIScrollView *scroView = (UIScrollView *)self.view;
        scroView.contentSize = CGSizeMake(0, 450 * (arr.count));
//        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(backStar.frame.origin.x, CGRectGetMaxY(backStar.frame), backStar.frame.size.width, 40)];
//        bottomView.backgroundColor = [UIColor colorWithRed:107/255.0 green:203/255.0 blue:202/255.0 alpha:1.0];
//        [self.view addSubview:bottomView];
//        NSString *date = [self changeDate:[arr[0] created_at]];
//        UILabel *timeLabel  = [regular createLabelView:[NSString stringWithFormat:@"%@支付",date] Withrect:CGRectMake(0, 0, bottomView.frame.size.width, 25) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:12.0];
//        NSAttributedString *timeStr = [regular createAttributeString:[NSString stringWithFormat:@"%@支付",date] andFloat:@(3.0)];
//        [timeLabel setAttributedText:timeStr];
//        [bottomView addSubview:timeLabel];
//        
//        UILabel *priceLabel = [regular createLabelView:[NSString stringWithFormat:@"￥%d",[arr[0] price] ]Withrect:CGRectMake(0, CGRectGetMaxY(timeLabel.frame), bottomView.frame.size.width, 15) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:12.0];
//        [bottomView addSubview:priceLabel];
//        UIButton *timeBtn = [regular createBtnWithRect:CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height) WithTitle:nil WithNormalColor:nil WithSelectColor:nil WithTitleFont:nil];
//        [timeBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
//        NSAttributedString *priceStr = [regular createAttributeString:[NSString stringWithFormat:@"￥%d",[arr[0] price] ] andFloat:@(1.5f)];
//        [priceLabel setAttributedText:priceStr];
//        [bottomView addSubview:timeBtn];

    } failed:^{
        NSLog(@"失败");
    }];
}
- (void)createAllView:(orderRowModel *)model andCount:(NSInteger)i
{
   CusOrder * order = [[CusOrder alloc] init];
    [order setType:model.user_id - 1 andRect:CGRectMake(10, 46 + 450 * i, kScreenWidth - 20, 226)];
    [self.view addSubview:order];
    
//   UIView* backStar = [[UIView alloc] initWithFrame:CGRectMake(10,272 + 400 *i, kScreenWidth - 20, 100)];
//    backStar.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:backStar];

    
    
    UIView *backStarNew = [[UIView alloc] initWithFrame:CGRectMake(10,272 + 450 * i, kScreenWidth - 20, 100)];
    backStarNew.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backStarNew];
    [self createStar:backStarNew andCount:i];
    

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(backStarNew.frame.origin.x, CGRectGetMaxY(backStarNew.frame), backStarNew.frame.size.width, 40)];
    bottomView.backgroundColor = [UIColor colorWithRed:107/255.0 green:203/255.0 blue:202/255.0 alpha:1.0];
    [self.view addSubview:bottomView];
    NSString *date = [self changeDate:[model created_at]];
    NSAttributedString *timeStr;
    if (model.status == 0) {
        timeStr = [regular createAttributeString:[NSString stringWithFormat:@"%@下单",date] andFloat:@(3.0)];
    }
    else
    {
        timeStr = [regular createAttributeString:[NSString stringWithFormat:@"%@已支付",date] andFloat:@(3.0)];
    }
    UILabel *timeLabel  = [regular createLabelView:[NSString stringWithFormat:@"%@支付",date] Withrect:CGRectMake(0, 0, bottomView.frame.size.width, 20) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:12.0];
    [timeLabel setAttributedText:timeStr];
    [bottomView addSubview:timeLabel];
    
    UILabel *priceLabel = [regular createLabelView:[NSString stringWithFormat:@"￥%d",[model price]]Withrect:CGRectMake(0, CGRectGetMaxY(timeLabel.frame), bottomView.frame.size.width, 15) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:12.0];
    [bottomView addSubview:priceLabel];
    UIButton *timeBtn = [regular createBtnWithRect:CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height) WithTitle:nil WithNormalColor:nil WithSelectColor:nil WithTitleFont:nil];
    timeBtn.tag = i;
    if (model.status == 1) {
        timeBtn.userInteractionEnabled = NO;
    }
    [timeBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *priceStr = [regular createAttributeString:[NSString stringWithFormat:@"￥%d",[model price] ] andFloat:@(1.5f)];
    [priceLabel setAttributedText:priceStr];
    [bottomView addSubview:timeBtn];
    
}
- (void)pay:(UIButton *)btn
{
//    NSArray *tradeNO = @[@"100",@"1000",@"10000"];
//    NSArray *price = @[@(0.1),@(0.2),@(0.3)];
    Order *order = [[Order alloc] init];
    order.partner = PARTNER;
    order.seller = SELLER;
    order.tradeNO = [arr[btn.tag] trade_no]; //订单ID(由商家□自□行制定)
    order.productName = [arr[btn.tag] title]; //商品标题
    order.productDescription = @"专案包括专家在线问答支持，全程疑难解答；DSL表格填写；签证材料准备辅助；约签及通知提醒；面试视频辅导(1次)"; //商品描述
    order.amount = @"0.01";
    order.notifyURL = @"http://120.26.192.105:5000/v1/alipay/notify"; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    NSString *appScheme = @"OneBox";
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    id<DataSigner> signer = CreateRSADataSigner(PRIVATEKEY);
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        NSLog(@"%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];}
    
    
}

- (NSString *)changeDate:(NSString *)str
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    //    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *date = [dateFormat dateFromString:str];
    NSLog(@"Nsdate=%@",date);
    
    [dateFormat setDateFormat:@"YYYY/MM/dd"];
    NSString *dateTime = [dateFormat stringFromDate:date];
    NSLog(@"DateTime=%@",dateTime);
    return dateTime;
}
- (void)createStar:(UIView *)backStar andCount:(NSInteger)j
{
    UILabel *grayLabel = [[UILabel alloc] init];
    grayLabel.textColor = [UIColor grayColor];
    grayLabel.font = [UIFont systemFontOfSize:12.0];
    grayLabel.frame = CGRectMake(0,10, backStar.frame.size.width, 20);
    grayLabel.textAlignment = NSTextAlignmentCenter;
    grayLabel.text = @"满 意 度 评 星";
//    grayLabel.backgroundColor  =[UIColor whiteColor];
    [backStar addSubview:grayLabel];
    
    //    UIButton *btn = [regular createBtnWithRect:CGRectMake(100, 100, 100, 100) WithTitle:@"测试" WithNormalColor:[UIColor redColor] WithSelectColor:nil WithTitleFont:nil];
    //    [self addSubview:btn];
    //    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *starList = @[@"工作态度",@"专业水准",@"完成情况"];
    for (int i = 0; i < starList.count; i ++) {
        UILabel *single = [regular createLabelView:starList[i] Withrect:CGRectMake(25, CGRectGetMaxY(grayLabel.frame) + 5 + 20 * i, 100, 15) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:13.0];
        //        single.backgroundColor = [UIColor redColor];
        NSAttributedString * str = [regular createAttributeString:starList[i] andFloat:@(4.0)];
        single.attributedText = str;
        single.font = [UIFont fontWithName:@"Skia" size:11.0];
        single.textColor = [UIColor colorWithRed:77/255.0 green:190/255.0 blue:217/255.0 alpha:1.0];
        [backStar addSubview:single];
//        UILabel *single = [regular createLabelView:listSev[i] Withrect:CGRectMake(50, 105 + 20 * i, 100, 15) WithTextColor:[UIColor whiteColor] WithTextAlignment:1 WithFont:13.0];
//        [backViewBottom addSubview:single];
        UIView *starView = [self createStar:CGRectMake(CGRectGetMaxX(single.frame) + 10, CGRectGetMinY(single.frame), 100, 20) andType:i andJ:j];
        [backStar addSubview:starView];
        
        
    }}
- (UIView *)createStar:(CGRect)rect andType:(NSInteger)type andJ:(NSInteger)j
{
    UIView*view_star=[[UIView alloc] initWithFrame:rect];
    [self.view addSubview:view_star];
    NSMutableArray *Arr=[[NSMutableArray alloc] init];
    NSInteger starNum=5;
    for (int i=0; i<starNum; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(i*CGRectGetHeight(view_star.frame), 0, CGRectGetHeight(view_star.frame)-10*_Scale, CGRectGetHeight(view_star.frame)-10*_Scale);
        [btn setImage:[UIImage imageNamed:@"school_评星"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"school_评星灰色"] forState:UIControlStateNormal];
        btn.tag= type*5 + i + j* 15;
//        if(type == 0){
            [btn addTarget:self action:@selector(star_action:) forControlEvents:UIControlEventTouchUpInside];
//        else if (type == 1)
//        {
//            [btn addTarget:self action:@selector(star_action_two:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        else
//        {
//            [btn addTarget:self action:@selector(star_action_third:) forControlEvents:UIControlEventTouchUpInside];
//        }
        [Arr addObject:btn];
        [view_star addSubview:btn];
    }
    [starsArr addObject:Arr];
    return view_star;
    
    
    }

-(void)star_action:(UIButton *)btn
{
    
    for (int i = 0; i < 5; i++) {
        UIButton *_btn=starsArr[btn.tag/5][i] ;
        if(_btn.tag<=btn.tag)
        {
            _btn.selected=YES;
        }
        else
        {
            _btn.selected=NO;
        }
        
    }
    //    }
    
}
- (void)star_action_two:(UIButton *)btn
{
    for (int i=0; i<[starsArr[1] count]; i++) {
        UIButton *_btn=starsArr[1][i] ;
        if(2*i<=btn.tag)
        {
            _btn.selected=YES;
        }
        else
        {
            _btn.selected=NO;
        }
        
    }
    
}
- (void)star_action_third:(UIButton *)btn
{
    for (int i=0; i<[starsArr[2] count]; i++) {
        UIButton *_btn=starsArr[2][i];
        if(3*i<=btn.tag)
        {
            _btn.selected=YES;
        }
        else
        {
            _btn.selected=NO;
        }
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
